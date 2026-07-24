#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/process 2>/dev/null | xargs || true)"
case "$answer" in powershell|powershell.exe) echo "Correct: powershell.exe is the suspicious process."; exit 0 ;; esac
echo "Not yet. Review Sysmon Event ID 1 entries."
exit 1
