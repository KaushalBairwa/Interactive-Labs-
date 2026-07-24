#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/parent 2>/dev/null | xargs || true)"
case "$answer" in winword|winword.exe) echo "Correct: WINWORD.EXE launched PowerShell."; exit 0 ;; esac
echo "Not yet. Inspect ParentImage for the suspicious process."
exit 1
