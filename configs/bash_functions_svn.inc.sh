# ~/.bash_functions_inc.svn: sourced by ~/.bash_functions
# to provide additional svn-related functions

svndiff() {
	if [ -z "$1" ] ; then
		echo "No file specified!"
		return
	fi
	if ! [ -r "$1" ] ; then
		echo "Can't read file: $1"
		return
	fi

	__svndiff_tmp="$(mktemp)"
	svn cat "$1" > $__svndiff_tmp
	colordiff -u "$__svndiff_tmp" "$1"
}
