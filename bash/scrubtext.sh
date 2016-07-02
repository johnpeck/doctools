#!/bin/bash
# Name: scrubtext.sh

set -e # bash should exit the script if any statement returns a non-true 
       #return value
usage="$(basename "$0") [-h] -- scrub non-ASCII characters from text file

options:
    -h -- show this help text

This command uses the -c and -d arguments to the tr command to remove
all the characters from the input stream other than the ASCII octal
values that are shown between the single quotes. This command
specifically allows the following characters to pass through this Unix
filter:

octal 11: tab
octal 12: linefeed
octal 15: carriage return
octal 40 through octal 176: all the 'good' keyboard characters 
"

# Default values
scale=1

while getopts ':h' option; do
    case "$option" in
	h) echo "$usage"
	    exit
	    ;;
	\?) printf "illegal option: -%s\n" "$OPTARG" >&2
	    echo "$usage" >&2
	    exit
	    ;;
    esac
done




# Create some temporary files
clean_file="$1.clean"
# Remove characters
tr -cd '\11\12\15\40-\176' < $1 > $clean_file

# Clean up
rm $1
cp $clean_file $1
rm $clean_file


