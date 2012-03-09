#!/bin/bash
# Name: startxfig.sh
#
# Starts xfig with options
#
# Usage: startxfig.sh
libstr="$PWD/doctools/xfig"
xfig -library_dir $libstr \
	-cbg beige -freehand_resolution 1 \
	-nosplash -showlengths -startpsFont Helvetica \
	-inches
	 

