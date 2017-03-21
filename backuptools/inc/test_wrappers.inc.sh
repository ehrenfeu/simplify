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
    local EXEC_FILE=$(which "$1")
    local RET=$?
    # which returns 0 IFF file exists AND is executable
    if [ "$RET" -eq "0" ] ; then
        echo $EXEC_FILE
    else
        echo "$0 error: cant find $1, exiting."
        exit 1
    fi
}

_exit_if_file_exists() {
    # print an error message and exit if the given file already exits to
    # prevent overwriting (e.g. a backup target file)
    if _file_exists "$1" ; then
        echo "Error: target file $1 exists, aborting!"
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
    # set the TGT_PATH variable if a given path exists, exit otherwise
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

_exit_if_file_exists() {
    # an alias for the above function, until it has been replaced properly
    _check_target_file "$1"
}
