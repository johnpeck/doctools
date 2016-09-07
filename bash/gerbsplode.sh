#!/bin/bash
# Name: gerbsplode.sh
#
# Unzips a set of gerber files and fires up gerbv to view them.
#
# Usage: gerbsplode.sh <zipped up gerbers>

set -e # bash should exit the script if any statement returns a
       # non-true return value

if [ "$#" -ne 1 ]; then
    echo "Usage: gerbsplode.sh <zipped up gerbers>"
    exit 64
fi

# Remove temporary directory
rm -rf gerbtemp

# Create temporary directory and unzip files into it
mkdir gerbtemp
cp "$1" gerbtemp
cd gerbtemp
unzip "$1" 

# Fire up gerbv
gerbv * &
