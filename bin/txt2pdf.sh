#!/bin/bash
# Name: txt2pdf.sh
#
# Converts a text file to a pdf using Ted and ps2pdf
#
# Usage: txt2pdf.sh <text file to open>
if [ -z "$1" ]
then
    echo "No argument"
else  
    textfile="$(echo $1|sed 's/\..\{3\}$/.txt/')"
    cp "$1" "$textfile"
    rtfile=$(echo $1|sed 's/\..\{3\}$/.rtf/')
    psfile=$(echo $1|sed 's/\..\{3\}$/.ps/')
    Ted --saveTo $textfile $rtfile
    Ted --printToFile $rtfile $psfile
    ps2pdf $psfile
fi
