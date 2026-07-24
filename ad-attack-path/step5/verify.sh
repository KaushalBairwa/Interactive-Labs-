#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/path 2>/dev/null | xargs || true)"
answer="${answer//\\\\/\\}"
expected='northstar\helpdesk.a -> helpdesk operators -> northstar\svc_backup -> server backup admins -> dc01.northstar.local'
if [ "$answer" = "$expected" ]; then
  echo "Correct: the shortest attack path reaches DC01 in four relationships."
  exit 0
fi
echo "Not yet. Run ad-path and submit every object in order."
exit 1
