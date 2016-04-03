#!/bin/bash
# Name: fig2pcb.sh
#
# Converts a fig file generated with xfig to a pcb layout using pstoedit
# 
# Usage: fig2pcb.sh <fig file to open>

set -e # bash should exit the script if any statement returns a non-true 
       #return value
if [ -z "$1" ]
then
    echo "Usage: fig2pcb.sh <fig file>"
else  
    # Create some temporary files with the same base name but
    # different file extensions.  Always quote filename parameters to
    # preserve space characters.
    epsfile="$(echo $1|sed 's/\..\{3\}$/.eps/')"
    pcbfile="$(echo $1|sed 's/\..\{3\}$/.pcb/')"
    # Use transfig to create the Encapsulated Postscript (eps) file.
    # Options:
    # -L -- language.  Use eps for Encapsulated Postscript
    # -m -- magnification.  Set this to 1 for original size.
    fig2dev -L eps -m 1 "$1" "$epsfile"
    # Convert to pcb using pstoedit.
    pstoedit -f "pcb" "$epsfile" "$pcbfile"
fi
