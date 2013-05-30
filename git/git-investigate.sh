
git-mk-packlist() {
    # make sure all objects are in a packfile:
    git gc
    # show details on packfile:
    git verify-pack -v .git/objects/pack/pack-*.idx | sort -k 3 -n > packlist.txt
}

# get list of ALL commit objects
git-mk-revlist() {
    git rev-list --objects --all > revlist.txt
}

git-object-history() {
    if [ -z "$1" ] ; then
        echo "error: no filename given!"
        return
    fi
    FNAME=$(grep $1 revlist.txt | cut -d ' ' -f 2)
    git log --all --pretty=oneline -- "$FNAME"
}

git-history-biggest-blobs() {
    NUM=20
    if [ -n "$1" ] ; then
        NUM=$1
    fi
    for SHA in $(tail -n $NUM packlist.txt | cut -d ' ' -f 1) ; do
        echo -------------------- $SHA ----------------
        git-object-history $SHA
    done
}

git-size-name-biggest-blobs() {
    NUM=20
    if [ -n "$1" ] ; then
        NUM=$1
    fi
    for PACKSET in $(tail -n $NUM packlist.txt | sed 's,  *,|,g') ; do
        SHA=$(echo $PACKSET | cut -d '|' -f 1)
        SIZE=$(echo $PACKSET | cut -d '|' -f 3)
        SIZE=$(echo "scale=1; $SIZE / (1024*1024)" | bc -l)
        TYPE=$(echo $PACKSET | cut -d '|' -f 2)
        echo -n "$SIZE ($TYPE) "
        grep $SHA revlist.txt
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    echo "This file is not meant to be executed directly, as it contains"
    echo "only function definitions. Add them to your environment by using"
    echo "the 'source' command instead."
else
    echo "New functions available:"
    echo " - git-mk-packlist (creates file 'packlist.txt')"
    echo " - git-mk-revlist (creates file 'revlist.txt')"
    echo " - git-object-history"
    echo " - git-history-biggest-blobs"
    echo " - git-size-name-biggest-blobs"
fi
