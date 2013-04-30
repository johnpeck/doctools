#!/bin/bash
# spellcheck.sh
#
# Spell check an entire latex document
#-----------------------------------------------------------------------

# Remove any default custom dictionary
if [ -a /home/john/.aspell.en.pws ]; then
    rm /home/john/.aspell.en.pws
fi

