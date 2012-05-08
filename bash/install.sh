#!/bin/bash
# Name: install.sh
#
# Copies some of the more useful scripts to /usr/local/bin
#
# Usage: install.sh
set -e # bash should exit the script if any statement returns a non-true 
       #return value
thisdir="$PWD"
xfigdir="$PWD/../xfig" # Where my xfig figures are sourced from
xfigdest="/usr/local/share/docxfig" # Where the figures will be copied to

if [ ! -d "$xfigdest" ]; then
    	mkdir "$xfigdest"
	echo "Created xfig figure library at" "$xfigdest"
fi

if [ -d "$xfigdest" ]; then
	cp --recursive "$xfigdir/." "$xfigdest"
	echo "Copied xfig figure libraries to" "$xfigdest"
fi
cp txt2pdf.sh "/usr/local/bin"
echo "Copied txt2pdf.sh to /usr/local/bin."
cp pdfpage.sh "/usr/local/bin"
echo "Copied pdfpage.sh to /usr/local/bin."
cp fig2dxf.sh "/usr/local/bin"
echo "Copied fig2dxf.sh to /usr/local/bin."
cp startxfig.sh "/usr/local/bin"
echo "Copied startxfig.sh to /usr/local/bin."

