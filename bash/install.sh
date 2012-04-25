#!/bin/bash
# Name: install.sh
#
# Copies some of the more useful scripts to /usr/local/bin
#
# Usage: install.sh
set -e # bash should exit the script if any statement returns a non-true 
       #return value
cp txt2pdf.sh "/usr/local/bin"
echo "Copied txt2pdf.sh to /usr/local/bin."
cp pdfpage.sh "/usr/local/bin"
echo "Copied pdfpage.sh to /usr/local/bin."
