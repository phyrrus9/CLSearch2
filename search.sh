#!/bin/bash

################################################
# Email helper script
# Edit the variables below to have your results
# sent to your email rather than to console
################################################

PATH="/path/to/clsearch"
KEYS="/path/to/keywords.txt"
BANNED="/path/to/banned.txt"

HOST="smtp.gmail.com"
PORT="587"
USER="you@email.com"
PASS='your_password'
CURL="/usr/bin/curl"

echo "Subject: CL Report" > /tmp/email.txt
echo "" >> /tmp/email.txt

$PATH -k $KEYS -b $BANNED >> /tmp/email.txt

$CURL smtp://$HOST:$PORT--mail-from "$USER" --mail-rcpt "$USER" --ssl -u $USER:$PASS -k --anyauth -T /tmp/email.txt
