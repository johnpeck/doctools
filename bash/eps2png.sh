#!/bin/bash
# Name: eps2png.sh
#
# Converts an eps file generated with gnuplot to a png using ghostscript
# and imagemagick
#
# Usage: eps2png.sh <eps file to open>

set -e # bash should exit the script if any statement returns a non-true 
       #return value
if [ -z "$1" ]
then
    echo "Usage: eps2png.sh <eps file>"
else  
    # Create some temporary files with the same base name but
    # different file extensions.  Always quote filename parameters to
    # preserve space characters.
    epsfile="$(echo $1|sed 's/\..\{3\}$/.eps/')"
    pngfile="$(echo $1|sed 's/\..\{3\}$/.png/')"
    # Convert to png using ghostscript.
    gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -dGraphicsAlphaBits=4 \
        -sOutputFile="$pngfile" -r300 "$epsfile"
    # Finally, use Imagemagick to trim the image.
    convert "$pngfile" -trim +repage "$pngfile"
fi
