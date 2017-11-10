# TODO: use `tput` for generating the escape codes below (see
# https://askubuntu.com/questions/24358 for details)
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

# set the default color for the username:
usrclr=$grn

# set a prefix if we're inside a screen since old screen-versions (or
# non-ubuntu ones) can't be easily distinguished from a regular session
[ "$TERM" == "screen" ] && scn="$bylw[S]$blw"

if [ -s ~/.bash_prompt_colors.inc.sh ] ; then
    source ~/.bash_prompt_colors.inc.sh
elif [ -n "$SSH_TTY" ] ; then
    # red hostname if we're on SSH (doesn't work for dropbear):
    host=$blw$red'@\h'
else
    host=$blw$bgrn'@\h'
fi

# set the number of trailing directory components to retain when expanding the
# \w and \W prompt string escapes:
export PROMPT_DIRTRIM=3

# blue directory name
wdir=$blw':'$bblu'\w'$blw'\$ '
