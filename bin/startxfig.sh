#!/bin/bash
# Name: startxfig.sh
#
# Starts xfig with options
#
# Usage: startxfig.sh <fig file to open>

thisdir="$PWD"
xfigdir="/doctools/xfig"
libstr=$thisdir$docdir
if [ -z "$1"] 
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
		
	 

