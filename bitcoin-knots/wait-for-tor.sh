#!/bin/bash
set -e

echo "Waiting for Tor to be available on tor:9050..."
for i in {1..60}; do
  if nc -z tor 9050; then
    echo "Tor is up!"
    break
  fi
  sleep 0.5
done

# Ensure the /bitcoin/.bitcoin directory is owned and writable
echo "Fixing permissions on /bitcoin/.bitcoin..."
mkdir -p /bitcoin/.bitcoin
chown -R "$(id -u)":"$(id -g)" /bitcoin/.bitcoin
chmod -R u+rwX /bitcoin/.bitcoin

exec bitcoind -conf=/home/bitcoin/.bitcoin/bitcoin.conf -datadir=/bitcoin/.bitcoin
