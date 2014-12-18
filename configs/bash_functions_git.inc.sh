# ~/.bash_functions_inc.git: sourced by ~/.bash_functions
# to provide additional git-related functions

# convenience-script for redmine-links
shorten_sha1() {
    SHORT=$(echo "$1" | cut -c 1-7)
    echo "commit:$SHORT   $SHORT"
}
