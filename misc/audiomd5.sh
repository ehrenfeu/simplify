#!/bin/sh
#

_exit_usage() {
    echo
    echo "usage: $0 filename.mp3"
    echo
    exit 100
}

test -z "$1" && _exit_usage

if ! [ -r "$1" ] ; then
    echo "ERROR: can't read file '$1'"
    _exit_usage
fi

MD5=$(mp3cat - - < "$1" | md5sum | cut -d ' ' -f 1)
eyeD3 --set-user-text-frame=audiomd5:$MD5 "$1" > /dev/null 2>&1
