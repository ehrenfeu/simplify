# define a function '_short_wdir' that takes the value of pwd and returns
# a truncated version (with a prefix to indicate truncation) if the length
# is above a certain limit, otherwise just $HOME is substitued by '~'
_short_wdir() {
    # how many characters of the $PWD should be kept
	local pwdmaxlen=34
    # use '~' instead of full path for homedir
	local shortPWD="${PWD/$HOME/\~}"
    # indicator that there has been directory truncation:
	local trunc_symbol="«"
	if [ ${#shortPWD} -gt $pwdmaxlen ] ; then
		local pwdoffset=$(( ${#shortPWD} - $pwdmaxlen ))
		printf "${trunc_symbol}${shortPWD:$pwdoffset:$pwdmaxlen}"
	else
		printf "${shortPWD}"
	fi
}

# color shorthands
blw='\[\033[00m\]'     # black-white
red='\[\033[0;31m\]'   # red
grn='\[\033[0;32m\]'   # green
ylw='\[\033[0;33m\]'   # yellow
blu='\[\033[0;34m\]'   # blue
vio='\[\033[0;35m\]'   # violet
mag='\[\033[0;36m\]'   # magenta
bred='\[\033[01;31m\]' # bold red
bgrn='\[\033[01;32m\]' # bold green
bylw='\[\033[01;33m\]' # bold yellow
bblu='\[\033[01;34m\]' # bold blue
bvio='\[\033[01;35m\]' # bold violet
bmag='\[\033[01;36m\]' # bold magenta

# set a prefix if we're inside a screen since old screen-versions (or
# non-ubuntu ones) can't be easily distinguished from a regular session
[ "$TERM" == "screen" ] && scn="$bylw[S]$blw"

if [ -s ~/.bash_prompt_hostcolor.inc.sh ] ; then
    source ~/.bash_prompt_hostcolor.inc.sh
elif [ -n "$SSH_TTY" ] ; then
    # red hostname if we're on SSH (doesn't work for dropbear):
	host=$blw$red'@\h'
else
	host=$blw$bgrn'@\h'
fi

# blue directory name
wdir=$blw':'$bblu'$(_short_wdir)'$blw'\$ '
