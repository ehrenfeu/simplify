# make sure all objects are in a packfile:
git gc

# show details on packfile:
git verify-pack -v .git/objects/pack/pack-*.idx | sort -k 3 -n > packlist.txt

# get list of ALL commit objects
git rev-list --objects --all > revlist.txt

git-object-history() {
    FNAME=$(grep $1 revlist.txt | cut -d ' ' -f 2)
    git log --all --pretty=oneline -- "$FNAME"
}

for SHA in $(tail -n 30 packlist.txt | cut -d ' ' -f 1) ; do
    echo -------------------- $SHA ----------------
    git-object-history $SHA
done

for PACKSET in $(tail -n 30 packlist.txt | sed 's,  *,|,g') ; do
    SHA=$(echo $PACKSET | cut -d '|' -f 1)
    SIZE=$(echo $PACKSET | cut -d '|' -f 3)
    SIZE=$(echo "scale=1; $SIZE / (1024*1024)" | bc -l)
    TYPE=$(echo $PACKSET | cut -d '|' -f 2)
    echo -n "$SIZE ($TYPE) "
    grep $SHA revlist.txt
done
