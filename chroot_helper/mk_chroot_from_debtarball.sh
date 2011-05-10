#!/bin/bash
#

if ! [ -r "debootstrap_inc.sh" ] ; then
	echo "ERROR: can't find 'debootstrap_inc.sh', stopping"
	exit 200
fi

. "debootstrap_inc.sh"

check_if_really_root

check_required "$TARBL"
check_required $_debootstrap


$_debootstrap \
	--include="$INCL" \
	--unpack-tarball ${TARBL} \
	--verbose \
	--variant=buildd \
	--keep-debootstrap-dir \
	--arch ${ARCH} \
	${SUITE} \
	${DEST} \
	${REPO}


echo "--------------------------"
echo "creating directories:"
for dir in $CREATEDIRS ; do
	mkdir -pv ${DEST}/${dir}
done

echo "--------------------------"
echo "adding to /etc/sudoers:"
echo $ADD_TO_SUDOERS
echo $ADD_TO_SUDOERS > ${DEST}/etc/sudoers


if [ "$ARCH" == "i386" ] ; then
	PERSONALITY="personality=linux32"
fi

cat << EOF
-----------DONE-----------

template for /etc/schroot/schroot.conf:

--
[${SUITE}_${ARCH}]
description=${SUITE}, ${ARCH}
directory=${DEST}
# type is required for setup-scripts to mount /proc etc. correctly
type=directory
priority=3
users=<<FILL_IN_DESIRED_USERS_HERE>>
${PERSONALITY}
--
EOF
