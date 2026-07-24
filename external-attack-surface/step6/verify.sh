#!/bin/bash
set -euo pipefail

answer="$(cat /root/answers/flag 2>/dev/null | xargs || true)"

if [ "$answer" = "SWM{attack_surface_mapped}" ]; then
  echo "Correct flag. External attack-surface discovery complete."
  exit 0
fi

echo "Not yet. Authenticate to the controlled legacy service and retrieve flag.txt."
exit 1
