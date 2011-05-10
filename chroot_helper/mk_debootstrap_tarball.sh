#!/bin/bash
#

if ! [ -r "debootstrap_inc.sh" ] ; then
	echo "ERROR: can't find 'debootstrap_inc.sh', stopping"
	exit 200
fi

. "debootstrap_inc.sh"

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
