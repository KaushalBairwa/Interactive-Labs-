#!/bin/bash
set -euo pipefail
answer="$(cat /root/answers/ip 2>/dev/null | xargs || true)"
if [ "$answer" = "198.51.100.42" ]; then echo "Correct: PowerShell connected to 198.51.100.42."; exit 0; fi
echo "Not yet. Review Sysmon Event ID 3."
exit 1
