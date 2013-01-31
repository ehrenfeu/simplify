#!/bin/bash

REQUEST="$HOME/.myprofile-settings/$(basename "$0" | cut -d '_' -f 2)"
if ! [ -f "$REQUEST" ] ; then
    echo "ERROR: can't find settings file '$REQUEST'."
    exit 1
fi

sh "$REQUEST"
