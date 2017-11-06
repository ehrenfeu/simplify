# color shorthands:
blw="$(tput setaf 15)"    # black-white (actually bold-white)

red="$(tput setaf 1)"     # red
grn="$(tput setaf 2)"     # green
ylw="$(tput setaf 3)"     # yellow
blu="$(tput setaf 4)"     # blue
mag="$(tput setaf 5)"     # magenta
vio="$mag"                # violet
cyn="$(tput setaf 6)"     # cyan

bred="$(tput setaf 9)"    # bold red
bgrn="$(tput setaf 10)"   # bold green
bylw="$(tput setaf 11)"   # bold yellow
bblu="$(tput setaf 12)"   # bold blue
bmag="$(tput setaf 13)"   # bold magenta
bvio="$bmag"              # bold violet
bcyn="$(tput setaf 14)"   # bold cyan

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
