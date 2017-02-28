#!/bin/bash
#


# defines a number of pretty-printing functions, wrapping the text in ASCII
# boxes, therefore all functions having a "_pb" (print boxed) prefix

# (re)set default values:
unset _BOX_HEADER_PRINTED

# check if the box width is set, or use a default value otherwise:
if [ -z "${_BOX_WIDTH}" ] ; then
    _BOX_WIDTH=72
fi

_pb_header() {
    EFF_LEN="${_BOX_WIDTH}"
    FILL='____________________________________________________________________'
    echo "${FILL}${FILL}${FILL}" | \
            cut -c -${EFF_LEN}
}

_pb_title() {
    EFF_LEN="${_BOX_WIDTH}"
    TIT_LEN=$(echo -n "$1" | wc -c)
    PRE_LEN=$(( (EFF_LEN - TIT_LEN - 2) / 2 ))
    PREFIX=$(for i in $(seq $PRE_LEN) ; do echo -n "_" ; done)
    FILL='____________________________________________________________________'
    echo "${PREFIX}($1)${FILL}${FILL}" | \
            cut -c -${EFF_LEN}
}

_pb_footer() {
    EFF_LEN="${_BOX_WIDTH}"
    : $(( EFF_LEN-- ))
    FILL='____________________________________________________________________'
    echo "|${FILL}${FILL}${FILL}" | \
            cut -c -${EFF_LEN} | tr -d '\n'
    echo '|'
}

_pb() {
    echo "$1" | _pb_stdin
}

_pb_stdin() {
    EFF_LEN="$(( ${_BOX_WIDTH} - 1))"
    LINE_WIDTH=$(( EFF_LEN - 4 ))
    sed 's/.\{'${LINE_WIDTH}'\}/& +\n/g' | \
        _pb_borderhelper ${EFF_LEN}
}

_pb_borderhelper() {
    # ensure every line has enough characters and add the surrounding '|' signs
    FILL='                                                                    '
    sed -e 's,^,| ,' -e "s,$,${FILL}${FILL}${FILL}," | \
        cut -c -$1 | sed 's,$,|,'
}

_pb_header_once() {
    if [ -z "${_BOX_HEADER_PRINTED}" ] ; then
        _BOX_HEADER_PRINTED="yes"
        _pb_header
        if test -n "$1" ; then
            _pb "$1"
        fi
    fi
}

_pb_footer_cond() {
    if ! [ -z "${_BOX_HEADER_PRINTED}" ] ; then
        _pb_footer
        echo
    fi
}
