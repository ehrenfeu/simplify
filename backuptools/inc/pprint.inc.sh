#!/bin/bash
#


# defines a number of pretty-printing functions, wrapping the text in ASCII
# boxes, therefore all functions having a "_pb" (print boxed) prefix

# (re)set default values:
unset _BOX_HEADER_PRINTED

# check if the box width is set, or use a default value otherwise:
if [ -z "${PP_BOX_WIDTH}" ] ; then
    PP_BOX_WIDTH=72
fi

# define prettyprint filling variables (L=line, S=spaces):
PP_FILL_L='____________________________________________________________________'
PP_FILL_S='                                                                    '


_pb_header() {
    # print a box header line (without text)
    EFF_LEN="${PP_BOX_WIDTH}"
    echo "${PP_FILL_L}${PP_FILL_L}${PP_FILL_L}" | \
            cut -c -${EFF_LEN}
}

_pb_title() {
    # print a box header line with some text in the center
    TITLE="$(basename $0)"
    if [ -n "$1" ] ; then
        TITLE="$1"
    fi
    EFF_LEN="${PP_BOX_WIDTH}"
    TIT_LEN=$(echo -n "$TITLE" | wc -c)
    PRE_LEN=$(( (EFF_LEN - TIT_LEN - 2) / 2 ))
    PREFIX=$(for i in $(seq $PRE_LEN) ; do echo -n "_" ; done)
    echo "${PREFIX}($TITLE)${PP_FILL_L}${PP_FILL_L}" | \
            cut -c -${EFF_LEN}
}

_pb_footer() {
    EFF_LEN="${PP_BOX_WIDTH}"
    : $(( EFF_LEN-- ))
    echo "|${PP_FILL_L}${PP_FILL_L}${PP_FILL_L}" | \
            cut -c -${EFF_LEN} | tr -d '\n'
    echo '|'
}

_pb() {
    echo "$1" | _pb_stdin
}

_pb_stdin() {
    EFF_LEN="$(( ${PP_BOX_WIDTH} - 1))"
    LINE_WIDTH=$(( EFF_LEN - 4 ))
    sed 's/.\{'${LINE_WIDTH}'\}/& +\n/g' | \
        _pb_borderhelper ${EFF_LEN}
}

_pb_borderhelper() {
    # ensure every line has enough characters and add the surrounding '|' signs
    sed -e 's,^,| ,' -e "s,$,${PP_FILL_S}${PP_FILL_S}${PP_FILL_S}," | \
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
    if [ -n "${_BOX_HEADER_PRINTED}" ] ; then
        _pb_footer
        echo
    fi
}


_pb_file_with_size() {
    # convenience function to print a message with a filename and its size
    _pb "   $(basename $1: $(ls -hs "$1"  | cut -d ' ' -f 1)"
}
