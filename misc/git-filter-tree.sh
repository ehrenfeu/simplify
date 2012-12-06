# NOTE: this can be used like this:
# git filter-branch -f --tree-filter '/path/to/git-filter-tree.sh' \
#     --msg-filter 'cat /tmp/git_filtering/COMMIT_MSG_*' \
#     --tag-name-filter cat -- --all

# this echo is required since the "rewrite" message of git does
# not have a trailing newline:
echo

REGEXPS="/home/ehrenfeu/usr/packages/simplify/misc/git-filter.regexps"
WORKDIR="/tmp/git_filtering"
rm $WORKDIR/COMMIT_MSG_*

# remember the existing log message (title + body):
LOG_BODY=$(git log -1 --pretty=format:%s%n%n%b $GIT_COMMIT)
echo "$LOG_BODY" > $WORKDIR/COMMIT_MSG_2
# echo "-- $LOG_BODY --"

LOG_FULL=$(git log -1 --parents --name-status $GIT_COMMIT)

MATCHES=$(git ls-files | egrep --only-matching -f $REGEXPS)
for match in $MATCHES ; do
    # checkout is not required in tree-filter:
    ### git checkout $GIT_COMMIT $match

    # create a placeholder file that goes into the repository
    SHA1=$(sha1sum "$match" | cut -d ' ' -f 1)
    MSG="
    This is a placeholder for a file that was removed during repository
    cleanup. This file changes exactly when the original file was renamed
    or the file itself was changed.
    original filename: '$match'
    original sha1sum: $SHA1"
    echo "$MSG" > "$match.orig-info"

    # record the original log incl parent ids in a separate file
    # NOTE: this file will change with EVERY commit where the original
    # file was present, this is meant as an indicator for this!
    echo "$LOG_FULL" > "$match.orig-log"

    # remove the file from the repository:
    TGT="$WORKDIR/removed/$SHA1"
    mkdir -p $TGT
    mkdir -p $TGT/orig-commitlogs
    mv -v $match $TGT
    cp -v $match.orig-log $TGT/orig-commitlogs/$GIT_COMMIT

    # add a note stating the removal of files to the log (ONE line!)
    MSG_REMOVED="\n(NOTE: files were removed during cleanup)"
    echo "$MSG_REMOVED" > "$WORKDIR"/COMMIT_MSG_3

    # adding the name of the removed file to the commit message really
    # clutters up the log a lot, so we don't do this!
    ### echo "removed file: $match" >> "$WORKDIR"/COMMIT_MSG_4
done
echo '---'
