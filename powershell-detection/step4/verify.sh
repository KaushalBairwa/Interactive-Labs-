#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/user 2>/dev/null | xargs || true)"
if [ "$answer" = 'northstar\jsingh' ]; then echo "Correct: the affected user is NORTHSTAR\jsingh."; exit 0; fi
echo "Not yet. Correlate the domain and username fields."
exit 1
