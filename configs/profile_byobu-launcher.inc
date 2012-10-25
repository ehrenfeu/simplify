# ~/.profile_inc.byobu-launcher: sourced by ~/.profile to automatically
# call "byobu-launcher" if desired

case "$-" in *i*) byobu-launcher && exit 0; esac;
