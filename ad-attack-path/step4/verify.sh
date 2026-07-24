#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/service-account 2>/dev/null | xargs || true)"
answer="${answer//\\\\/\\}"
if [ "$answer" = 'northstar\svc_backup' ]; then
  echo "Correct: NORTHSTAR\\svc_backup is the controlled service account."
  exit 0
fi
echo "Not yet. Inspect the target of the GenericAll relationship."
exit 1
