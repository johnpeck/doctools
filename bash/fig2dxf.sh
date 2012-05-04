#!/bin/bash
# Name: fig2dxf.sh
#
# Converts a fig file generated with xfig to a dxf using pstoedit
# 
# Usage: fig2dxf.sh <fig file to open>

set -e # bash should exit the script if any statement returns a non-true 
       #return value
if [ -z "$1" ]
then
    echo "Usage: fig2dxf.sh <fig file>"
else  
    # Create some temporary files with the same base name but
    # different file extensions.  Always quote filename parameters to
    # preserve space characters.
    epsfile="$(echo $1|sed 's/\..\{3\}$/.eps/')"
    dxffile="$(echo $1|sed 's/\..\{3\}$/.dxf/')"
    # Use transfig to create the Encapsulated Postscript (eps) file.
    # Options:
    # -L -- language.  Use eps for Encapsulated Postscript
    # -m -- magnification.  Set this to 1 for original size.  This can't
    #       be used with the -Z option.
    # -Z -- maxdimension.  Chooses magnification based on a maximum dimension.
    #       The units are inches if the fig file was created with imperial
    #       units, and centimeters otherwise.
    fig2dev -L eps -m 1 "$1" "$epsfile"
    # Convert to dxf using pstoedit.
    pstoedit -f "dxf" "$epsfile" "$dxffile"
fi
