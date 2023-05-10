## Converting specifications into HTML

All releases of the specifications are published to <https://www.oidc.se/specifications>. We use the script
`tohtml.sh` to produce HTML from our specifications written in Markdown. This script also sets up the CSS-files
for printing the HTML-files.

### Prerequisites

In order to run the `tohtml.sh` script you need the following:

* Not be on a Windows machine ...
* Have a working installation of [Node.js](https://nodejs.org).
* Install generate-md, see <https://github.com/mixu/markdown-styles>.

### Usage

    usage: tohtml.sh <markdown file> <output directory> [-o <orientation>]
      Where orientation is p (for portrait) or l (for landscape).
      The 'orientation' is for printing.

When running the `tohtml.sh` script you may assign the page orientation to be used when printing the resulting HTML.
Portrait mode is default, but some specifications are better suited in landscape mode (due to wide tables).

### Producing PDF

Currently, I haven't found a good enough CLI tool to take us from HTML to PDF. The available ones doesn't follow CSS very well. Therefore, the solution at this point is to use Google Chrome and "Print to PDF". Remember to uncheck the "Headers and footers" option and to check the "Background graphics" option.

### Releasing

We use GitHub pages when publishing the specifications in HTML format. The script `release.sh` may be used for this purpose. It transforms all specifications into HTML and creates a template `index.html` file with links to all specifications. This index file should later be manually edited so that items such as "changes since last version" and a description of the release are added.

    usage: release.sh <input directory> <output directory>
      Where <input directory> is the directory containing the specifications
  



