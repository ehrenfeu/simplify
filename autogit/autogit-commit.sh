#!/bin/bash
#

# set -x

_exit_usage() {
    echo "USAGE: $0 /full/path/to/git/workingdir/  [ /path/to/git/dir ]"
    echo
    exit 100
}

quote() {
    sed 's:^ *:> :'
}

quote2() {
    sed 's:^ *:>> :'
}

if [ -z "$1" ] ; then
    _exit_usage
fi

set -e
cd "$1"
set +e

AUTOGIT_DIR=".autogit_dir"
if [ -r $AUTOGIT_DIR ] ; then
    export GIT_DIR="$(cat $AUTOGIT_DIR)"
fi

# override if a git-dir is given explicitly as parameter:
if [ -n "$2" ] ; then
    export GIT_DIR="$2"
fi

if ! [ -d ".git" ] && [ -z "$GIT_DIR" ] ; then
    echo "ERROR: '$1' is not a git working directory!"
    echo
    _exit_usage
fi

# some package-manager-foo: if a given file in the subdir "_admin" exists, we
# update the list of installed packages in this file, before doing the git
# stuff (this way we make sure that we always commit an updated package list on
# a system along with the changes in the monitored repository):
DPKG_SELECTIONS="_admin/dpkg__get-selections"
if [ -f "$DPKG_SELECTIONS" ] ; then
    dpkg --get-selections > $DPKG_SELECTIONS
fi
RPM_SELECTIONS="_admin/rpm__query_all"
if [ -f "$RPM_SELECTIONS" ] ; then
    rpm --query --all > $RPM_SELECTIONS
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
    {
        FMT='%s%n%n> stats >>>%n'
        git log -1 --pretty=format:"$FMT" HEAD
        git diff-tree --abbrev -C -M --shortstat --no-commit-id HEAD | quote
        git diff-tree --abbrev -C -M --numstat --no-commit-id HEAD | quote2
        echo '---------------'
    } | tee /tmp/autogit_commit_summary
    # determine if we have a remote repository to push to:
    if git remote -v | grep -qs push ; then
        echo '>  push >>>'
        # "pipefail" is required to capture the return value of "git push":
        set -o pipefail
        git push 2>&1 | quote || {
            # the push failed, try to write a marker file:
            MARKER="/tmp/autogit_push_failed"
            echo "Pushing '$1' failed!" >> $MARKER
        }
        echo '---------------'
    else
        echo '>> WARNING - no remote repository defined, NOT PUSHING! <<'
        echo '---------------'
    fi
    echo
    echo "${DIFF}"
fi
