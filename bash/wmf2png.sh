#!/bin/bash
# Name: wmf2png.sh
#
# Converts a wmf file to a png using libwmf and inkscape
#
# Usage: wmf2png.sh <height in pixels> <wmf file>

set -e # bash should exit the script if any statement returns a
       # non-true return value

if [ "$#" -ne 2 ]; then
    echo "Usage: wmf2png.sh <height in pixels> <wmf file>"
    exit 64
fi
 
# Create some temporary files with the same base name but
# different file extensions.  Always quote filename parameters to
# preserve space characters.
wmffile="$(basename "$2")"
pngfile="$(echo "$wmffile"|sed 's/\..\{3\}$/.png/')"
svgfile="$(echo "$wmffile"|sed 's/\..\{3\}$/.svg/')"
wmf2svg "$2" -o "$svgfile"
inkscape -f "$svgfile" -h $1 -e "$pngfile"


