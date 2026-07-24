#!/bin/bash
set -euo pipefail

answer="$(
  tr '[:upper:]' '[:lower:]' < /root/answers/service 2>/dev/null \
    | tr -d '[:space:]-_' || true
)"

case "$answer" in
  ftp|legacyftp|filetransferprotocol)
    echo "Correct: the exposed plaintext service is FTP."
    exit 0
    ;;
esac

echo "Not yet. Inspect the TCP/2121 greeting and identify the protocol."
exit 1
