#!/bin/bash
#

set -e

if [ -z "$BACKUPTOOLS_INC" ] ; then
    echo "ERROR: BACKUPTOOLS_INC variable undefined!"
    exit 1
fi

__OLDPWD=$PWD
cd $BACKUPTOOLS_INC
for INC_FILE in $(ls *.inc.sh) ; do
    # echo -n "Loading '$INC_FILE'..."
    source $INC_FILE
    # echo " [DONE]"
done
cd "$__OLDPWD"
