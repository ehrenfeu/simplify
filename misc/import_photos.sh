#!/bin/sh

BASE="/media/${USER}/disk/DCIM"
MARKER="${BASE}/.last_imported"

if ! [ -r "$MARKER" ] ; then
    echo "Can't find '$MARKER', doing nothing!"
    exit 1
fi

TGT="/scratch/pictures/$(date +%Y)/INCOMING"
if ! [ -d "$TGT" ] ; then
    echo "Can't find target directory '$TGT', stopping."
    exit 2
fi

LAST=$(cat $MARKER)
cd "$BASE"
for file in $(find -type f -newer $LAST -and -not -iname '.last_imported') ; do
    cp -v "$file" "$TGT"
done

echo "$file" > "$MARKER"

