#!/bin/bash
set -euo pipefail
answer="$(cat /root/answers/flag 2>/dev/null | xargs || true)"
if [ "$answer" = "SWM{genericall_to_domain_controller}" ]; then
  echo "Correct flag. Active Directory attack-path investigation complete."
  exit 0
fi
echo "Not yet. Inspect the validated incident record."
exit 1
