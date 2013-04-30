#!/bin/bash
# spellcheck.sh
# Spell check the ec100 manual
#
# Needs these word list files:
# ec100_cmds.list -- list of remote commands
# ec100_jargon.list -- Electrochemistry-specific words
#-----------------------------------------------------------------------

# Remove any default custom dictionary
if [ -a /home/john/.aspell.en.pws ]; then
    rm /home/john/.aspell.en.pws
fi
aspell --lang=en create master ./ec100_cmds.rws < ./ec100_cmds.list
aspell --lang=en create master ./ec100_jargon.rws < ./ec100_jargon.list
