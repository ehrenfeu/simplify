# functions for debootstrap-utils

if [ -z "$1" ] ; then
	echo "ERROR: please specify a configuration-file!"
	echo
	echo '#-- example --#'
	echo 'SUITE="hardy"'
	echo 'ARCH="i386"'
	echo 'TARBL="`pwd`/debootstrap_${SUITE}_${ARCH}.tar"'
	echo 'DEST="`pwd`/${SUITE}_${ARCH}"'
	echo 'REPO="http://de.archive.ubuntu.com/ubuntu/"'
	echo
	echo '# list of packages to include by default:'
	echo 'INCL="wget,devscripts,gnupg,aptitude,sudo,vim-tiny,bash-completion"'
	echo '#-- example --#'
	echo
	exit 100
fi

if ! [ -r "$1" ] ; then
	echo "ERROR: can't read '$1'"
	exit 101
fi

. "$1"


_fakeroot="/usr/bin/fakeroot"
_debootstrap="/usr/sbin/debootstrap"

check_required() {
	if ! [ -f "$1" ] ; then
		echo "ERROR: '$1' is required, but not found!"
		exit 1
	fi
}

check_if_really_root() {
	if [ "$(id -u)" -gt "0" ] ; then
		echo "ERROR: bootstrapping requires root-privileges!"
		exit 2
	fi
	
	if [ -n "$FAKEROOTKEY" ] ; then
		echo "You seem to be running this script with fakeroot, but"
		echo "debootstrap will refuse to work that way..."
		exit 3
	fi
}
