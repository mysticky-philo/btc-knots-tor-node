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

# Ensure the /bitcoin/.bitcoin directory exists
echo "Ensuring /bitcoin/.bitcoin directory exists..."
mkdir -p /bitcoin/.bitcoin

# Fix ownership and permissions on directory, but skip chown if bitcoin.conf is read-only
CONF_FILE="/bitcoin/.bitcoin/bitcoin.conf"
if [ -e "$CONF_FILE" ] && [ ! -w "$CONF_FILE" ]; then
  echo "Config file is read-only, skipping chown on $CONF_FILE"
  chown -R "$(id -u)":"$(id -g)" /bitcoin/.bitcoin || true  # chown remaining writable files
else
  echo "Fixing permissions on /bitcoin/.bitcoin and $CONF_FILE"
  chown -R "$(id -u)":"$(id -g)" /bitcoin/.bitcoin
  chmod -R u+rwX /bitcoin/.bitcoin
fi

exec bitcoind -conf=/bitcoin/.bitcoin/bitcoin.conf -datadir=/bitcoin/.bitcoin