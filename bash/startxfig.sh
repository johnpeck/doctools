#!/bin/bash
# Name: startxfig.sh
#
# Starts xfig with options
#
# Usage: startxfig.sh <fig file to open>
thisdir="$PWD"
# Location of my personal xfig libraries is symbolically linked to
# /usr/local/share/xfig after running the install script in bash.
libstr=/usr/local/share/docxfig
if [ -z "$1" ] 
then
	xfig -library_dir "$libstr" \
		-cbg beige -freehand_resolution 1 \
		-nosplash -showlengths -startpsFont Helvetica \
		-inches
else
	xfig -library_dir "$libstr" \
		-cbg beige -freehand_resolution 1 \
		-nosplash -showlengths -startpsFont Helvetica \
		-inches "$1"
fi


