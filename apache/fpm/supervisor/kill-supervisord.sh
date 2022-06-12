#!/bin/bash

printf "READY\n";

while read line; do
  echo "Processing Event: $line" >&2;
#  kill -3 $(cat "/home/debian/supervisor/supervisord.pid")
#  supervisorctl -c /home/debian/supervisor/supervisord.conf shutdown
  kill -SIGQUIT $PPID
done < /dev/stdin