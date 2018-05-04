#!/bin/bash
# Name: dxf2pcb.sh
#
# Converts a dxf file to a pcb layout using pstoedit.  You'll also
# need the dxf2fig utility from http://homepage.usask.ca/~ijm451/fig/
# 
# Usage: dxf2pcb.sh <fig file to open>

set -e # bash should exit the script if any statement returns a non-true 
       #return value
usage="$(basename "$0") [-h] [-s n] -- convert a dxf to pcb via xfig

options:
    -h -- show this help text
    -s -- set scale value

You'll need to determine the scale factor by knowing some actual
dimension in the drawing, and measuring this dimension in the xfig
file. A better way to do this conversion is to simply print the output
from a dxf viewer to postscript, then use pstoedit -f pcb
"

# Default values
scale=1

while getopts ':hs:' option; do
    case "$option" in
	h) echo "$usage"
	    exit
	    ;;
	s) scale=$OPTARG
	    ;;
	:) printf "missing argument for -%s\n" "$OPTARG" >&2
	    echo "$usage" >&2
	    exit 1
	    ;;
	\?) printf "illegal option: -%s\n" "$OPTARG" >&2
	    echo "$usage" >&2
	    exit 1
	    ;;
    esac
done
shift $((OPTIND-1))


# Create some temporary files with the same base name but
# different file extensions.  Always quote filename parameters to
# preserve space characters.
epsfile="$(echo $1|sed 's/\..\{3\}$/.eps/')"
pcbfile="$(echo $1|sed 's/\..\{3\}$/.pcb/')"
xfigfile="$(echo $1|sed 's/\..\{3\}$/.fig/')"
# Convert from dxf to xfig
# Usage  : dxf2fig [[options] <dxffile> <figfile>]
#
#   Options: -p <1-3>     : viewplane , 1=xy, 2=xz, 3=yz
#            -f <0-4>     : papersize , 0=A0, 1=A1, ... , 4=A4
#            -v [-v ...]  : give (lots of) debug information
# Use -f 0 to get maximum resolution
dxf2fig -f 0 "$1"


# Use transfig to create the Encapsulated Postscript (eps) file.
# Options:
# -L -- language.  Use eps for Encapsulated Postscript
# -m -- magnification.  Set this to 1 for original size.
fig2dev -L eps -m $scale "$xfigfile" "$epsfile"
# Convert to pcb using pstoedit.
pstoedit -f "pcb" "$epsfile" "$pcbfile"

