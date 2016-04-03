#!/bin/bash
# Name: install.sh
#
# Copies some of the more useful scripts to /usr/local/bin
#
# Usage: install.sh
set -e # bash should exit the script if any statement returns a non-true 
       #return value
thisdir="$PWD"
XFIGDIR="../xfig" # Where my xfig figures are sourced from
XFIGDEST="/usr/local/share/docxfig/" # Where the figures will be copied to
# My inkscape files
MYINK="../inkscape"

# Where my personal scripts will go
scriptdir="/usr/local/bin"

# Where inkscape stores its configuration files
INKCONFIG="/home/john/.config/inkscape"

# Create xfig figure libraries
if [ ! -d "$XFIGDEST" ]; then
      mkdir -p "$XFIGDEST"
      echo "Created xfig figure library at" "$XFIGDEST"
fi

if [ -d "$XFIGDEST" ]; then
      cp -R "$XFIGDIR/." "$XFIGDEST"
      echo "Copied xfig figure libraries to" "$XFIGDEST"
fi

# Copy inkscape templates
if [ ! -d "$INKCONFIG/templates" ]; then
      mkdir -p "$INKCONFIG/templates"
      echo "Created inkscape template directory at" "$INKCONFIG/templates"
fi

if [ -d "$INKCONFIG/templates" ]; then
      cp -R "$MYINK/templates/"* "$INKCONFIG/templates"
      echo "Copied inkscape templates to" "$INKCONFIG/templates"
fi


cp txt2pdf.sh "/usr/local/bin"
echo "Copied txt2pdf.sh to /usr/local/bin."
cp pdfpage.sh "/usr/local/bin"
echo "Copied pdfpage.sh to /usr/local/bin."
cp fig2dxf.sh "/usr/local/bin"
echo "Copied fig2dxf.sh to /usr/local/bin."
cp startxfig.sh "/usr/local/bin"
echo "Copied startxfig.sh to /usr/local/bin."
cp code2fig.sh "/usr/local/bin"
echo "Copied code2fig.sh to /usr/local/bin."
cp txt2fig.pl "/usr/local/bin"
echo "Copied txt2fig.pl to /usr/local/bin."
cp fig2png.sh "/usr/local/bin"
echo "Copied fig2png.sh to /usr/local/bin."
cp bashmarks.sh "/usr/local/bin"
echo "Copied bashmarks.sh to /usr/local/bin."
cp swgrep "/usr/local/bin"
echo "Copied swgrep to /usr/local/bin."
cp eps2png.sh "/usr/local/bin"
echo "Copied eps2png.sh to /usr/local/bin"
cp gerbsplode.sh "/usr/local/bin"
chmod a+x /usr/local/bin/gerbsplode.sh
echo "Copied gerbsplode.sh to /usr/local/bin"
cp svg2png.sh "/usr/local/bin"
chmod a+x /usr/local/bin/svg2png.sh
echo "Copied svg2png.sh to /usr/local/bin"
cp wmf2png.sh "/usr/local/bin"
chmod a+x /usr/local/bin/wmf2png.sh
echo "Copied wmf2png.sh to /usr/local/bin"
scriptname=fig2pcb
cp $scriptname.sh $scriptdir
chmod a+x $scriptdir/$scriptname.sh
echo "Copied $scriptname.sh to $scriptdir"
