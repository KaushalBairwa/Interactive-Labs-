#!/bin/bash
set -euo pipefail

if [ ! -f /root/answers/ports ]; then
  echo "No ports answer found. Use: lab-submit ports PORT1,PORT2,PORT3"
  exit 1
fi

normalised="$(
  tr ',; ' '\n' < /root/answers/ports \
    | grep -E '^[0-9]+$' \
    | sort -n -u \
    | paste -sd, -
)"

if [ "$normalised" = "80,2121,8080" ]; then
  echo "Correct: TCP ports 80, 2121 and 8080 are exposed."
  exit 0
fi

echo "Not yet. Run a full TCP port scan against the authorised target."
exit 1
