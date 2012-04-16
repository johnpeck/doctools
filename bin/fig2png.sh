#!/bin/bash
# Name: fig2png.sh
#
# Converts a fig file generated with xfig to a png using ghostscript
# and imagemagick
#
# Usage: fig2png.sh <fig file to open>
if [ -z "$1" ]
then
    echo "Usage: fig2png.sh <fig file>"
else  
    # Create some temporary files with the same base name but
    # different file extensions.  Always quote filename parameters to
    # preserve space characters.
    epsfile="$(echo $1|sed 's/\..\{3\}$/.eps/')"
    pngfile="$(echo $1|sed 's/\..\{3\}$/.png/')"
    # Use transfig to create the Encapsulated Postscript (eps) file.
    # Options:
    # -L -- language.  Use eps for Encapsulated Postscript
    # -Z -- maxdimension.  Chooses magnification based on a maximum dimension.
    #       The units are inches if the fig file was created with imperial
    #       units, and centimeters otherwise.
    fig2dev -L eps -Z 8 "$1" "$epsfile"
    # Convert to png using ghostscript.
    gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -dGraphicsAlphaBits=4 \
        -sOutputFile="$pngfile" -r300 "$epsfile"
    # Finally, use Imagemagick to trim the image.  Note that all resizing
    # should be done in the fig2dev step to preserve image resolution.
    convert "$pngfile" -trim +repage "$pngfile"
fi
