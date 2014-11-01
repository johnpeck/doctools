#!/bin/bash
# Name: fig2png.sh
#
# Converts a fig file generated with xfig to a png using ghostscript
# and imagemagick
#
# Usage: fig2png.sh <max pixels> <fig file to open>

set -e # bash should exit the script if any statement returns a
       # non-true return value

if [ "$#" -ne 2 ]; then
    echo "Usage: fig2png.sh <max pixels> <fig file>"
    exit 64
fi
 
# Create some temporary files with the same base name but
# different file extensions.  Always quote filename parameters to
# preserve space characters.
epsfile="$(echo $2|sed 's/\..\{3\}$/.eps/')"
pngfile="$(echo $2|sed 's/\..\{3\}$/.png/')"
# Use transfig to create the Encapsulated Postscript (eps) file.
# Options:
# -L -- language.  Use eps for Encapsulated Postscript
# -Z -- maxdimension.  Chooses magnification based on a maximum dimension.
#       The units are inches if the fig file was created with imperial
#       units, and centimeters otherwise.  Assumes 300dpi.
zsize=$(echo "scale=2; $1 / 300" | bc) 
fig2dev -L eps -Z $zsize "$2" "$epsfile"
# Convert to png using ghostscript.
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -dGraphicsAlphaBits=4 \
    -dTextAlphaBits=4 -sOutputFile="$pngfile" -r300 "$epsfile"
# Finally, use Imagemagick to trim the image.  Note that all resizing
# should be done in the fig2dev step to preserve image resolution.
convert "$pngfile" -trim +repage "$pngfile"

