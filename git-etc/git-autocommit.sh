#!/bin/bash
#

# set -x

_exit_usage() {
    echo "USAGE: $0 /full/path/to/git/repo/"
    echo
    exit 100
}

quote() {
    sed 's:^:> :'
}

if [ -z "$1" ] ; then
    _exit_usage
fi

set -e
cd "$1"
set +e

if ! [ -d ".git" ] ; then
    echo "ERROR: '$1' is not a git repository!"
    echo
    _exit_usage
fi

# 'add' is required to track new files
git add .

# only call 'commit' on real changes, otherwise git exits
# with status '1' and cron will complain...
if ! git status | grep -qs '^nothing to commit (working directory clean)$' ; then
    # '-a' is required to delete files in the repository that
    # have been deleted locally
    git commit -q -a -m "[autogit] changes in $1"
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
