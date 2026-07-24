#!/bin/bash

printf '\nPreparing identity investigation'
while [ ! -f /opt/interactive-lab/.ready ]; do
  printf '.'
  sleep 1
done

printf '\nIdentity graph ready.\n'
printf 'Start with: cat /root/ad-case/case-summary.txt\n\n'
