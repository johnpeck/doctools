#!/bin/bash
# Name: startxfig.sh
#
# Starts xfig with options
#
# Usage: startxfig.sh

thisdir="$PWD"
xfigdir="/doctools/xfig"
libstr=$thisdir$docdir
xfig -library_dir "$libstr" \
	-cbg beige -freehand_resolution 1 \
	-nosplash -showlengths -startpsFont Helvetica \
	-inches
	 

