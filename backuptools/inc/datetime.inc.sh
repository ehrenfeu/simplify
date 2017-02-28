#!/bin/bash
#


### date variables defined at SOURCING time of this script:
# format: 2006-11-21-1648
DATEYmdHM="$(date +%Y-%m-%d-%H%M)"

# format: 06-11-21-1648
DATEymdHM="$(date +%y-%m-%d-%H%M)"

# format: 06-11-21
DATEymd="$(date +%y-%m-%d)"



### date functions returning current values when calling them:
# format: 06-11-21-1648
_DATEymdHM() {
    date '+%y-%m-%d-%H%M'
}

# format 2010-02-03-1354
_DATEYmdHM() {
    date '+%Y-%m-%d-%H%M'
}
