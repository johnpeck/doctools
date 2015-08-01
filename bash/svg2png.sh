#!/bin/bash
# Name: fig2png.sh
#
# Converts a svg file to a png using inkscape
#
# Usage: svg2png.sh <height in pixes> <svg file>

set -e # bash should exit the script if any statement returns a
       # non-true return value

if [ "$#" -ne 2 ]; then
    echo "Usage: svg2png.sh <height in pixels> <svg file>"
    exit 64
fi
 
# Create some temporary files with the same base name but
# different file extensions.  Always quote filename parameters to
# preserve space characters.
svgfile="$(basename "$2")"
pngfile="$(echo "$svgfile"|sed 's/\..\{3\}$/.png/')"
inkscape -f "$2" -h $1 -e "$pngfile"


