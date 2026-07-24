#!/bin/bash
set -euo pipefail
answer="$(cat /root/answers/encoded 2>/dev/null | xargs || true)"
if [ "$answer" = "VwByAGkAdABlAC0ATwB1AHQAcAB1AHQAIAAnAHQAcgBhAGkAbgBpAG4AZwAnADsAIABJAG4AdgBvAGsAZQAtAFcAZQBiAFIAZQBxAHUAZQBzAHQAIABoAHQAdABwADoALwAvADEAOQA4AC4ANQAxAC4AMQAwADAALgA0ADIALwBwAGEAeQBsAG8AYQBkAC4AcABzADEA" ]; then echo "Correct: the encoded command was identified."; exit 0; fi
echo "Not yet. Copy the complete value after -EncodedCommand."
exit 1
