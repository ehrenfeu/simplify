#!/bin/bash
#

# set -x

cd /etc

# 'add' is required to track new files
git add .

# only call 'commit' on real changes, otherwise git exits
# with status '1' and cron will complain...
if ! git status | grep -qs '^nothing to commit (working directory clean)$' ; then
    # have git display the status if we're going to commit:
    git status
    echo '----------------------------------------------------------------'
    # check diff size before committing, remember diff if small enough:
    if [ $(git diff --cached | wc -l) -le 100 ] ; then
        GITDIFF="$(git diff --cached)"
    fi
    # '-a' is required to delete files in the repository that
    # have been deleted locally
    git commit -a -m "git-etc autocommitting changes $(date +%F_%H-%M)"
    # echo $?
    if [ -n "${GITDIFF}" ] ; then
        echo '----------------------------------------------------------------'
        echo "${GITDIFF}"
    fi
    echo '----------------------------------------------------------------'
    # determine if we have a remote repository to push to:
    if git remote -v | grep -qs push ; then
        git push
    fi
fi
