#!/bin/bash
# Name: blogpic.sh
#
# Converts an image file for use on my blog.  Requires imagemagick.
# 
# Usage: blogpic.sh <image file>

set -e # bash should exit the script if any statement returns a non-true 
       #return value
if [ -z "$1" ]
then
    echo "Usage: blogpic.sh <image file>"
else 
    # The output filename
    blog_pic_filename="$(echo $1|sed 's/[[:alnum:]]*/&_blog/')"
    # Reduce the image to be 600 pixels wide while maintaining aspect ratio
    convert -resize "600>" "$1" "$blog_pic_filename"
    echo "Output written to ""$blog_pic_filename"
fi
