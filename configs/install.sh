#!/bin/bash

if [ $(pwd) != "$HOME" ] ; then
    echo "Plese run this from your home dir!"
    exit 1
fi

BASE=$(dirname $0)
TSTAMP=$(date +%FT%H%M%S)

install_link() {
    if [ -s ".$1" ] ; then
        mv .$1 .${1}.pre-$TSTAMP
    fi
    ln -sv "$BASE"/$1 .$1
}

CONFIGS="bashrc \
bash_logout \
bash_functions \
profile"

for file in $CONFIGS ; do
    install_link $file
done

if [ -n "$WITHINCLUDES" ] ; then
    for file in "$BASE"/*.inc.sh ; do
        install_link $(basename $file)
    done
fi
