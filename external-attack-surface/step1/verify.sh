#!/bin/bash
set -euo pipefail

answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/hostname 2>/dev/null | xargs || true)"

if [ "$answer" = "target.securewithme.local" ]; then
  echo "Correct: the authorised target is target.securewithme.local."
  exit 0
fi

echo "Not yet. Read /root/engagement/scope.txt and submit the approved hostname."
exit 1
