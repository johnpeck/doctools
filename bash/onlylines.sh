#!/bin/bash
# Name: onlylines.sh

set -e # bash should exit the script if any statement returns a non-true 
       #return value
usage="$(basename "$0") [-h] -- Extract lines from a file

options:
    -h -- show this help text
    -s -- starting line
    -e -- ending line
"

# Set defaults
starting_line=1
ending_line=0


while getopts 'hs:e:' option; do
    case "$option" in
	h) echo "$usage"
	    exit
	    ;;
	s) starting_line=$OPTARG
	   ;;
	e) ending_line=$OPTARG
	   ;;
    esac
done
shift $((OPTIND-1))  # This tells getopts to move on to the next argument

if [ $# -eq 0 ]
then
   echo "$usage"
   exit
else
    if [ $ending_line -eq 0 ]
    then
	ending_line=$(cat $1 | wc -l)
	end_code="end"
    else
	end_code=$ending_line
    fi
    fullfile=$(basename "$1")
    extension="${fullfile##*.}"
    basename="${fullfile%.*}"
    cutfile="$basename"_"$starting_line"_"$end_code".$extension
    sed -n "$starting_line","$ending_line"p $1 > $cutfile
fi




