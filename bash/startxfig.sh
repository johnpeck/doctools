#!/bin/bash
# Name: startxfig.sh
#
# Starts xfig with options
#
# Usage: startxfig.sh <fig file to open>
THISDIR="$(pwd -P)"

# Location of my personal xfig libraries is symbolically linked to
# /usr/local/share/xfig after running the install script in bash.
LIBSTR="/usr/local/share/docxfig"
if [ -z "$1" ] 
then
	xfig -library_dir "$LIBSTR" \
		-cbg beige -freehand_resolution 1 \
		-nosplash -showlengths -startpsFont Helvetica \
		-inches
else
	xfig -library_dir "$LIBSTR" \
		-cbg beige -freehand_resolution 1 \
		-nosplash -showlengths -startpsFont Helvetica \
		-inches "$1"
fi


