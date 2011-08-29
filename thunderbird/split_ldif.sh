#!/bin/bash
#
# this is a tool to split a LDIF file exported from thunderbird's
# addressbook into multiple files (one per entry), using the "dn:"
# (distinguished name) field as the resulting files names

### first entry:
# sed '/^\s*$/,$d' file.ldif

### the rest:
# sed '1,/^\s*$/d' file.ldif

_exit_usage() {
    cat << __USAGE__
USAGE:

$0 thunderbird-addressbook-export.ldif

__USAGE__
exit 1
}

if ! [ -r "$1" ] ; then
    _exit_usage
fi

TGT="$(basename $1)_ldif-splits"
FIRST="$TGT/_first.ldif"
REST="$TGT/_rest.ldif"
TEMP="$TGT/_temp.ldif"

if [ -d "$TGT" ] ; then
    echo "ERROR: target directory already existing!"
    exit 1
fi

mkdir "$TGT" || {
    echo "ERROR creating dir for splitting LDIF file!"
}

cp "$1" "$REST"

while true ; do
    # move away our data, so we don't overwrite it:
    mv "$REST" "$TEMP"
    # get the first entry:
    sed '/^\s*$/,$d' "$TEMP" > "$FIRST"
    # and the remaing ones:
    sed '1,/^\s*$/d' "$TEMP" > "$REST"
    # "dn:: " means a base64 encoded string, while "dn: " is ASCII formatted
    NAME="$(grep '^dn:' "$FIRST" | cut -d ' ' -f 2- | sed 's,[ /],_,g')"
    mv "$FIRST" "$TGT/$NAME" && echo "$NAME"
    if [ "$(wc -l "$REST" | cut -d ' ' -f 1)" -eq "0" ] ; then
        break
    fi
done

rm -f "$FIRST" "$REST" "$TEMP"
