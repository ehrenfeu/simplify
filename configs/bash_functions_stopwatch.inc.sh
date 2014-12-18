stopwatch() {
    if [ -z "$1" ] ; then
        DIST='9385'
    else
        DIST="$1"
    fi
    START=$(date +%s)
    # echo $START
    echo 'timer is running, press enter to stop...'
    read input
    STOP=$(date +%s)
    echo "scale=2
    delta=${STOP}-${START}
    delta
    (${DIST} * 3.6 / delta)" | bc -l
}
