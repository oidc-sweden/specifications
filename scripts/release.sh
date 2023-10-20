#!/bin/bash
#
# release.sh
#
# Author: Martin Lindström
#

INSTALL_DIR=$(dirname $0)

#
# usage
#
usage() {
    echo 1>&2 "usage: $0 <input directory> <output directory>"
    echo 1>&2 "  Where <input directory> is the directory containing the specifications"
}

#
# Check parameters.
#
if [ $# -lt 2 ]; then
    usage
    exit 127
fi

INPUT_DIR=${1%/}
OUTPUT_DIR=${2%/}

declare -a SPECIFICATIONS=("swedish-oidc-profile.md"
    "swedish-oidc-claims-specification.md"
    "request-parameter-extensions.md"
    "oidc-signature-extension.md"
    "claim-mappings-to-other-specs.md")

#
# Produce HTML
#
for spec in "${SPECIFICATIONS[@]}"
do
    echo "Processing ${spec} ..."
    ORIENTATION="p"
#    if [ "${spec}" == "xxx" ] || [ "${spec}" == "yyy" ];
#    then
#	ORIENTATION="l"
#    fi
    ${INSTALL_DIR}/tohtml.sh ${INPUT_DIR}/"${spec}" ${OUTPUT_DIR} -o $ORIENTATION
done

#
# Create the template for the index.html file
#
#${INSTALL_DIR}/tohtml.sh ${INSTALL_DIR}/templates/index.md ${OUTPUT_DIR} -o p

exit 0





