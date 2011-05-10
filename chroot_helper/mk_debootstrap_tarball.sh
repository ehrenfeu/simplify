#!/bin/bash
#

_INC="debootstrap_inc.sh"
_SOURCE=""

if [ -r "$_INC" ] ; then
    _SOURCE="$_INC"
elif [ -r "chroot_helper/$_INC" ] ; then
    _SOURCE="chroot_helper/$_INC"
fi

if [ -z "$_SOURCE" ] ; then
	echo "ERROR: can't find 'debootstrap_inc.sh', stopping"
	exit 200
fi

. "$_SOURCE"

check_required $_fakeroot
check_required $_debootstrap

assemble_opts

$_fakeroot $_debootstrap $EXTRA \
	--make-tarball debootstrap_${SUITE}_${ARCH}.tar \
	${SUITE} \
	${DEST} \
	${REPO}
