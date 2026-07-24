#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/remediation 2>/dev/null | xargs || true)"
case "$answer" in
  "remove genericall"|"remove the genericall permission"|"remove genericall permission"|"remove genericall from helpdesk operators")
    echo "Correct: remove the GenericAll delegation."
    exit 0
    ;;
esac
echo "Not yet. Submit the primary fix from remediation.md."
exit 1
