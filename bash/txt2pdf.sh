#!/bin/bash
# Name: txt2pdf.sh
#
# Converts a text file to a pdf using Ted and ps2pdf
#
# Usage: txt2pdf.sh <text file to open>
set -e # bash should exit the script if any statement returns a non-true 
       #return value
EXPECTED_ARGS=1
E_BADARGS=65
       
# Check to see that we got the right number of arguments
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: txt2pdf.sh <text file>"
  exit $E_BADARGS
fi

# Create some temporary files with the same base name but
# different file extensions.  Always quote filename parameters to
# preserve space characters.
cleanfile="clean.txt"
textfile="$(echo $1|sed 's/\..\{3\}$/.txt/')"
rtfile="$(echo $1|sed 's/\..\{3\}$/.rtf/')"
psfile="$(echo $1|sed 's/\..\{3\}$/.ps/')"
pdfile="$(echo $1|sed 's/\..\{3\}$/.pdf/')"
# Ted determines file format by the file extension.  We thus need
# to make sure our input file ends in .txt
if [ "$1" != "$textfile" ]
then
    cp "$1" "$textfile"
fi
# Only allow these specific characters in the text file:
#    octal 11: tab
#    octal 12: linefeed
#    octal 15: carriage return
#    octal 40 through octal 176: all the "good" keyboard characters
tr -cd '\11\12\15\40-\176' < "$textfile" > "$cleanfile"
# Finally, use Ted to format the text file in rich text...
Ted --saveTo "$cleanfile" "$rtfile"
# ...and then to dump the rich text file to postscript.
Ted --printToFile "$rtfile" "$psfile"
# ps2pdf invokes Ghostscript for pdf conversion
ps2pdf "$psfile"
# Clean up temporary files
if [ "$1" != "$textfile" ]
then
    rm "$textfile"
fi
echo "$1" "--->" "$pdfile"
rm "$rtfile"
rm "$psfile"
rm "$cleanfile"

