#!/bin/bash
# Name: startxrandr.sh
#
# Sets up displays
#
# Usage: startxrandr.sh

set -e # bash should exit the script if any statement returns a
       # non-true return value

if [ "$#" -ne 1 ]; then
    echo "Usage: startxrandr.sh"
    exit 64
fi

xrandr --auto --output DP2 --mode 1920x1080+0+0 --left-of eDP1
