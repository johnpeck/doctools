#!/bin/bash
# Name: ttytitle.sh

set -e # bash should exit the script if any statement returns a non-true 
       #return value
usage="$(basename "$0") [-h] -- Set title for mintty terminal

options:
    -h -- show this help text
"



while getopts 'h' option; do
    case "$option" in
	h) echo "$usage"
	    exit
	    ;;
    esac
done
shift $((OPTIND-1))  # This tells getopts to move on to the next argument

if [ $# -eq 0 ]
then
   echo "$usage"
   exit
else
    title="$1"
    echo -ne "\e]0;$title\a"
fi




