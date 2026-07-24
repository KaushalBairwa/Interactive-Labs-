#!/bin/bash

printf '\nPreparing the controlled target'
while [ ! -f /opt/interactive-lab/.ready ]; do
  printf '.'
  sleep 2
done

printf '\nLab environment ready.\n'
printf 'Start by reading: /root/engagement/scope.txt\n\n'
