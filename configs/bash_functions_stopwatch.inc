stopwatch() {
    START=$(date +%s)
    echo $START
    read input
    STOP=$(date +%s)
    echo "scale=2 ; (9385 * 3.6 /($STOP - $START))" | bc -l
}
