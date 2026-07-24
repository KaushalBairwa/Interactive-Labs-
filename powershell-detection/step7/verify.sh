#!/bin/bash
set -euo pipefail
answer="$(cat /root/answers/sigma-count 2>/dev/null | xargs || true)"
if [ "$answer" = "1" ]; then echo "Correct: the rule produced one match."; exit 0; fi
echo "Not yet. Run sigma-check and submit the match count."
exit 1
