#!/bin/bash
set -euo pipefail
answer="$(tr '[:upper:]' '[:lower:]' < /root/answers/relationship 2>/dev/null | tr -d '[:space:]_-.' || true)"
if [ "$answer" = "genericall" ]; then
  echo "Correct: GenericAll is the dangerous delegated relationship."
  exit 0
fi
echo "Not yet. Review the relationship from Helpdesk Operators to the service account."
exit 1
