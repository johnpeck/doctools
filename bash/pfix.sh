#!/bin/bash
# Name: pfix.sh
#
# Fix file and directory permissions
#
# Usage: pfix.sh <directory name>

set -e # bash should exit the script if any statement returns a non-true
       #return value
if [ -z "$1" ]
then
    echo "Usage: pfix.sh <directory name>"
else
    # Make sure we can actually find the directory
    chmod a+rw "$1"
    # Set the directory permissions to 755
    find "$1" -type d -print0 | xargs -0 chmod 755
    # Set the directory's file permissions to 644
    find "$1" -type f -print0 | xargs -0 chmod 644
fi
