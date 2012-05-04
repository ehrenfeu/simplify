# ~/.profile_inc.xuv-devel: sourced by ~/.profile to set environment
# variables required for the LMBSOFT devel-environment (see
# http://www.xuvtools.org/ for details)

# set the paths required by xuvtools-buildscripts:
BUILDENV="${HOME}/.lmbsoft"
export LMBSOFTSRC=${BUILDENV}/src
export LMBSOFTDEST=${BUILDENV}/dst
export LMBSOFTTEMP=${BUILDENV}/tmp

# set vars for a local Qt installation:
use_local_qt() {
	# VERSION="${VERSION:-4.5.3}"
	# export QTDIR="${BUILDENV}/external/lin_gcc$(gcc -dumpversion)/Qt-${VERSION}"
	export QTDIR="${LMBSOFTDEST}/thirdparty/Qt"
	export PATH="${QTDIR}/bin:$PATH"
	QTCONFIGUREFLAGS="-debug-and-release -opensource -optimized-qmake -static \
			-no-qt3support -nomake examples -nomake demos -nomake docs"
	QTMORECONFIGUREFLAGS="-no-svg -no-webkit -no-scripttools -no-gif -no-libtiff \
			-no-libmng -no-cups -no-dbus -no-nas-sound"
}

if test -r /etc/debian_chroot ; then
	echo "Detected chroot-environment, setting Qt-variables."
	use_local_qt
fi
