#!/bin/bash
#

if ! [ -r "mk_debootstrap.functions" ] ; then
	echo "ERROR: can't find 'mk_debootstrap.functions, stopping"
	exit 200
fi

. "mk_debootstrap.functions"

check_required $_fakeroot
check_required $_debootstrap

# INCLUDE=""
if test -n "${INCL}" ; then
    INCLUDE="--include=${INCL}"
fi

$_fakeroot $_debootstrap $INCLUDE \
	--make-tarball debootstrap_${SUITE}_${ARCH}.tar \
	--verbose \
	--variant=buildd \
	--arch ${ARCH} \
	${SUITE} \
	${DEST} \
	${REPO}
