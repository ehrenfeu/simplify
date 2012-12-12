# NOTE: this can be used like this:
# git filter-branch -f --tree-filter '/path/to/git-filter-tree.sh' \
#     --msg-filter 'cat /tmp/git_filtering/COMMIT_MSG_*' \
#     --tag-name-filter cat -- --all

# this echo is required since the "rewrite" message of git does
# not have a trailing newline:
echo

# FIXME: use cmdline parameter for this:
REGEXPS="/home/ehrenfeu/usr/packages/simplify/misc/git-filter.regexps"
WORKDIR="/tmp/git_filtering"
rm $WORKDIR/COMMIT_MSG_*

# remember the existing log message (title + body):
LOG_BODY=$(git log -1 --pretty=format:%s%n%n%b $GIT_COMMIT)
echo "$LOG_BODY" > $WORKDIR/COMMIT_MSG_2
# echo "-- $LOG_BODY --"

LOG_FULL=$(git log -1 --parents --name-status $GIT_COMMIT)

# the regular expressions must be defined such that they match files
# including their complete path relative to the repository root!
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

    # prepare the directory tree to store the original data:
    TGT="$WORKDIR/removed/$SHA1"
    if ! [ -d "$TGT" ] ; then
        mkdir -p $TGT/orig-commitlogs
        # prepare the new dir by adding explanation headers etc.
        cat > "$TGT/orig-name" << HERE_EOF
# This file contains a mapping of commit-IDs to original file names.
# The SHA1 value corresponds to the original commit (which can be looked
# up in the "orig-commitlogs" directory), the part after the colon is
# the full path + name of the "data" file during this commit.
HERE_EOF
    fi

    # record the original name:
    echo "${GIT_COMMIT}:${match}" >> $TGT/orig-name

    # use a common name to capture renamings without duplicating files
    mv -v $match $TGT/data
    cp -v $match.orig-log $TGT/orig-commitlogs/$GIT_COMMIT

    # add a note stating the removal of files to the log (ONE line!)
    MSG_REMOVED="\n(NOTE: files were removed during cleanup)"
    echo "$MSG_REMOVED" > "$WORKDIR"/COMMIT_MSG_3

    # DON'T mess up the repository log with the removed filenames!
done
echo '---'
