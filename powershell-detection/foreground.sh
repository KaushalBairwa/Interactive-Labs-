#!/bin/bash
printf '\nPreparing investigation files'
while [ ! -f /opt/interactive-lab/.ready ]; do
  printf '.'
  sleep 1
done
printf '\nInvestigation ready.\n'
printf 'Start with: ls -R /root/investigation\n\n'
