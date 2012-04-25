#!/bin/bash
# Name: pdfpage.sh
#
# Tears out a page of a pdf
#
# Usage: pdfpage.sh <page> <pdf file>
set -e # bash should exit the script if any statement returns a non-true 
       #return value
EXPECTED_ARGS=2
E_BADARGS=65

# Check to see that we got the right number of arguments
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: pdfpage.sh <page number> <pdf file>"
  exit $E_BADARGS
fi

pagestr="page""$1"
pagefile="$(echo $2 | sed 's/\./_'"$pagestr".'/')"
pdftk A="$2" cat "A${1}" output "$pagefile"
echo "Page $1 from $2 torn out to "$pagefile"."
