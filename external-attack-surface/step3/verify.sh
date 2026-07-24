#!/bin/bash
set -euo pipefail

answer="$(
  tr '[:upper:]' '[:lower:]' < /root/answers/web-version 2>/dev/null \
    | tr -d '[:space:]' || true
)"

case "$answer" in
  apache/2.4.49|apache2.4.49)
    echo "Correct: the port 80 banner exposes Apache/2.4.49."
    exit 0
    ;;
esac

echo "Not yet. Inspect the HTTP Server header with curl -I."
exit 1
