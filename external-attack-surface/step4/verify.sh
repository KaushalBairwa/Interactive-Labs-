#!/bin/bash
set -euo pipefail

answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/hidden-path 2>/dev/null | xargs || true)"
answer="/${answer#/}"
answer="${answer%/}/"

if [ "$answer" = "/backup-console/" ]; then
  echo "Correct: robots.txt disclosed /backup-console/."
  exit 0
fi

echo "Not yet. Inspect robots.txt and submit the disallowed path."
exit 1
