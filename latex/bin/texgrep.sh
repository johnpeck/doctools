#!/bin/bash
# texgrep - searches for a text pattern contained in files
#   located inside the texmf trees
# usage: texgrep pattern [extension]
# usage examples:
#   texgrep phantomsection sty
#   texgrep \\\\def\\\\phantomsection
if [ $# -eq 0 ]; then
  echo 1>&2 Usage: texgrep pattern [extension]
  exit 1
fi
for path in TEXMFMAIN TEXMFDIST TEXMFHOME
do
 find `kpsewhich --var-value=$path` -name "*$2" |xargs grep $1
done
exit 0
