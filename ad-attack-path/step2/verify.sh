#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/group 2>/dev/null | xargs || true)"
if [ "$answer" = "helpdesk operators" ]; then
  echo "Correct: Helpdesk Operators contains the starting user."
  exit 0
fi
echo "Not yet. Inspect group membership and MemberOf relationships."
exit 1
