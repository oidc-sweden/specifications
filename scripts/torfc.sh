#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage:
  torfc.sh <markdown-file> [-draft [TAG] | -release]

Modes:
  -draft [TAG]   Generate draft HTML. Optional TAG defaults to "main".
  -release       Generate release HTML.
EOF
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

mode=""
draft_tag="main"
md_file=""

# Parse args (flags may appear before or after the file)
while [ $# -gt 0 ]; do
  case "$1" in
    -draft)
      [ "${mode:-}" = "release" ] && fail "Cannot use -draft and -release at the same time."
      mode="draft"
      shift
      if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then
        draft_tag="$1"
        shift
      fi
      ;;
    -release)
      [ "${mode:-}" = "draft" ] && fail "Cannot use -draft and -release at the same time."
      mode="release"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      fail "Unknown option: $1"
      ;;
    *)
      if [ -z "${md_file:-}" ]; then
        md_file="$1"
        shift
      else
        fail "Unexpected extra argument: $1"
      fi
      ;;
  esac
done

[ -n "${md_file:-}" ] || { usage >&2; exit 1; }
[ -f "$md_file" ] || fail "Markdown file not found: $md_file"

if [ -z "${mode:-}" ]; then
  mode="draft"
  echo "Generating in draft mode"
fi

# Absolute directory of the markdown file (portable)
md_dir=$(CDPATH= cd -- "$(dirname -- "$md_file")" && pwd)
md_base=$(basename -- "$md_file")

# Extract seriesInfo.value in a POSIX-awk compatible way:
# - enter section on [seriesInfo]
# - leave section on next [something]
# - within section, find: value = "..."
series_value=$(
  awk '
    BEGIN { in_series=0 }
    /^[[:space:]]*\[seriesInfo\][[:space:]]*$/ { in_series=1; next }
    in_series && /^[[:space:]]*\[[^]]+\][[:space:]]*$/ { in_series=0 }
    in_series && /^[[:space:]]*value[[:space:]]*=/ {
      line=$0
      sub(/^[[:space:]]*value[[:space:]]*=[[:space:]]*"/, "", line)
      sub(/"[[:space:]]*$/, "", line)
      print line
      exit
    }
  ' "$md_dir/$md_base"
)

[ -n "${series_value:-}" ] || fail "Could not find value = \"...\" under [seriesInfo] in: $md_file"

html_name="${series_value}.html"
xml_name="${series_value}.xml"

# Run docker from md_dir so the /data mount matches and output files appear there
(
  cd "$md_dir"
  docker run --rm -v "$(pwd)":/data danielfett/markdown2rfc "$md_base"
)

html_src="$md_dir/$html_name"
xml_src="$md_dir/$xml_name"

[ -f "$html_src" ] || fail "Expected HTML not found after docker run: $html_src"
[ -f "$xml_src" ] || fail "Expected XML not found after docker run: $xml_src"

if [ "$mode" = "release" ]; then
  dest_dir="$md_dir/docs"
  dest_file="$html_name"
else
  dest_dir="$md_dir/docs/drafts"
  dest_file="${series_value}-${draft_tag}.html"
fi

mkdir -p "$dest_dir"
mv -f "$html_src" "$dest_dir/$dest_file"
rm -f "$xml_src"

echo "HTML placed at: $dest_dir/$dest_file"
