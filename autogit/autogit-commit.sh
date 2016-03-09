#!/bin/bash
#

# set -x

_exit_usage() {
    echo "USAGE: $0 /full/path/to/git/workingdir/  [ /path/to/git/dir ]"
    echo
    exit 100
}

quote() {
    sed 's:^:> :'
}

if [ -z "$1" ] ; then
    _exit_usage
fi

if [ -n "$2" ] ; then
    export GIT_DIR="$2"
fi

set -e
cd "$1"
set +e

if ! [ -d ".git" ] && [ -z "$GIT_DIR" ] ; then
    echo "ERROR: '$1' is not a git working directory!"
    echo
    _exit_usage
fi

DIRTY=$(git status --porcelain)

# only call 'commit' on real changes, otherwise git exits
# with status '1' and cron will complain...
if [ -n "$DIRTY" ] ; then
    # tell git to stage all changes (new, modified, deleted)
    git add --all
    git commit -q -m "[autogit] changes in $1"
    # check diff size and remember if small enough:
    if [ $(git diff-tree -p --no-commit-id HEAD | wc -l) -le 100 ] ; then
        DIFF="$(git diff-tree -p --no-commit-id HEAD)"
    fi
    # print the commit message, list changed files (+stats)
    FMT='%s%n%n> stats >>>%n'
    git log -1 --pretty=format:"$FMT" HEAD
    git diff-tree --abbrev -C -M --numstat --no-commit-id HEAD | quote
    echo -n '>>'
    git diff-tree --abbrev -C -M --shortstat --no-commit-id HEAD
    echo '---------------'
    # determine if we have a remote repository to push to:
    if git remote -v | grep -qs push ; then
        echo '>  push >>>'
        git push 2>&1 | quote
        echo '---------------'
    fi
    echo
    echo "${DIFF}"
fi
