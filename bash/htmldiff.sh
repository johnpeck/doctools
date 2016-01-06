#!/bin/bash
# Name: htmldiff.sh
#
# Sends git diff output to diff.html
#
# Usage: htmldiff.sh
#
# Download ansi2html.sh from http://www.pixelbeat.org/scripts
# Make sure it's in your path and executable
git --no-pager diff --color-words | ansi2html.sh > diff.html
