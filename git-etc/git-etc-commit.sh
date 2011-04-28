#!/bin/bash
#

# set -x

_exit_usage() {
    echo "USAGE: $0 /full/path/to/git/repo/"
    echo
    exit 100
}

if [ -z "$1" ] ; then
    _exit_usage
fi

set -e
cd "$1"
set +e

if ! [ -d ".git" ] ; then
    echo "ERROR: '$1' is no git repository!"
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
    COMMIT=$(git commit -a -m "git-autocommit: changes from $(date +%F_%H-%M)")
    # get the hash-ID of our commit:
    CID=$(git log -1 --pretty=format:%H)
    # check diff size before committing, remember diff if small enough:
    if [ $(git show --format=format:'' $CID | wc -l) -le 100 ] ; then
        GITDIFF="$(git show --format=format:'' $CID)"
    fi
    # print the header and the list of changed files (+modes +hashes):
    git whatchanged -1
    echo '-- SUMMARY -----------------------------------------------------'
    # only print the summary line of the commit:
    echo "$COMMIT" | sed -n 2p
    echo '----------------------------------------------------------------'
    # determine if we have a remote repository to push to:
    if git remote -v | grep -qs push ; then
        git push
    fi
    echo "${GITDIFF}"
fi
