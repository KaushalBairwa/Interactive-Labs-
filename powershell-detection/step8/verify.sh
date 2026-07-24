#!/bin/bash
set -euo pipefail
answer="$(cat /root/answers/flag 2>/dev/null | xargs || true)"
if [ "$answer" = "SWM{powershell_chain_detected}" ]; then echo "Correct flag. PowerShell investigation complete."; exit 0; fi
echo "Not yet. Inspect incident_flag in the Wazuh alert."
exit 1
