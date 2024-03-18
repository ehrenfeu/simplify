#!/bin/bash

# create a temp file
COOKIE=$(mktemp)

# old portal URI:
# PORTAL_URI='http://wifionice.de/en/'
PORTAL_URI='https://login.wifionice.de/en/'

# get the CSRF token required for login
TOKEN=$(curl \
  --silent \
  --cookie "$COOKIE" \
  --cookie-jar "$COOKIE" \
  "$PORTAL_URI" |
    grep CSRFToken |
    cut -d '"' -f 12
)

# perform WIFIonICE login
curl -vvv \
  --cookie "$COOKIE" \
  --cookie-jar "$COOKIE" \
  --data "login=true&CSRFToken=$TOKEN&connect=" \
  "$PORTAL_URI"

# remove cookie file
rm "$COOKIE"
