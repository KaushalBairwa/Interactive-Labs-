#!/bin/bash
set -euo pipefail
answer="$(tr '[:lower:]' '[:upper:]' < /root/answers/mitre 2>/dev/null | xargs || true)"
if [ "$answer" = "T1059.001" ]; then echo "Correct: T1059.001 maps to PowerShell."; exit 0; fi
echo "Not yet. Review the Wazuh MITRE mapping and Sigma tags."
exit 1
