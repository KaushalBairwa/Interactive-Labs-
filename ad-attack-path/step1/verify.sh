#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/starting-user 2>/dev/null | xargs || true)"
answer="${answer//\\\\/\\}"
if [ "$answer" = 'northstar\helpdesk.a' ]; then
  echo "Correct: NORTHSTAR\\helpdesk.a is the starting user."
  exit 0
fi
echo "Not yet. Review the case summary and users.json."
exit 1
