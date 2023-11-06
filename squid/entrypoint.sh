#!/bin/bash
set -eux

echo "Check configuration file"
if [ ! -e "/data/squid.conf" ]; then
    cp /squid/etc/squid.conf /data/squid.conf
fi

echo "Setup cache dir"
/squid/sbin/squid -z -f /data/squid.conf --foreground
sleep 30s

echo "Starting SQUID"

exec "$@"