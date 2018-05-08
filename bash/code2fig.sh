#!/bin/bash
# Name: code2fig.sh
#
# Converts a text file into an xfig file with monospaced font.  Requires
# perl and the txt2fig.pl script from 
# http://andrew.triumf.ca/andrew/xfig/txt2fig
#
# I modified the perl script to simply default to the text parameters
# I like.
# 
# Usage: code2fig.sh <text file>

set -e # bash should exit the script if any statement returns a non-true 
       #return value
if [ -z "$1" ]
then
    echo "Usage: code2fig.sh <text file>"
else 
    # The output filename
    figfile="$(echo $1|sed 's/\..*/.fig/')"
    cat "$1" | txt2fig.pl > "$figfile"
    echo "Output written to ""$figfile"
fi
