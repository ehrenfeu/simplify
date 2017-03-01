#!/bin/bash
#


_file_exists() {
    test -f "$1"
}

_file_readable() {
    test -r "$1"
}

_file_executable() {
    test -x "$1"
}

_file_executable_or_exit() {
    if [ ! -x "$1" ] ; then
        echo "$0 error: cant find $1, exiting."
        exit 1
    fi
}


_check_hostname() {
    # 'bash' sets HOSTNAME by default, but it doesn't seem
    # to be required by POSIX and 'dash' does not...
    if [ -z "${HOSTNAME}" ] ; then
        HOSTNAME=$(hostname)
    fi
    if [ -z "${HOSTNAME}" ] ; then
        echo "$0, $FUNCNAME error: unable to determine hostname, exiting."
    fi
}


_check_target_path() {
    # check if a given path exists, and set the TGT_PATH variable if so
    if [ -z "$1" ] ; then
        echo "$0, $FUNCNAME error: no target path specified, exiting."
        # print usage message if defined
        _usage
        exit 1
    fi
    if [ ! -d "$1" ] ; then
        echo "$0, $FUNCNAME error: target path '$1' doesn't exist, exiting."
        # print usage message if defined
        _usage
        exit 1
    else
        TGT_PATH="$1"
    fi
}


_check_target_file() {
    # check if a given file already exists, and exit if so
    if _file_exists "$1" ; then
        echo "Error: target file $1 exists, aborting!"
        exit 1
    fi
}