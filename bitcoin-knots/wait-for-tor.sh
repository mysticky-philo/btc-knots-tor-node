#!/bin/bash
set -e

# Wait for Tor to become available on tor:9050
HOST="tor"
PORT=9050
MAX_ATTEMPTS=60
SLEEP_INTERVAL=0.5
ATTEMPT=1

echo "Waiting for Tor to be available on ${HOST}:${PORT}..."

while ! nc -z "$HOST" "$PORT"; do
  if [ "$ATTEMPT" -ge "$MAX_ATTEMPTS" ]; then
    echo "Tor not available after $MAX_ATTEMPTS attempts, exiting."
    exit 1
  fi
  echo "Attempt ${ATTEMPT}/${MAX_ATTEMPTS}: Tor not ready, waiting ${SLEEP_INTERVAL}s..."
  ATTEMPT=$((ATTEMPT+1))
  sleep "$SLEEP_INTERVAL"
done

echo "Tor is up!"

# Prepare cookie dir
echo "Ensuring /cookie is present and writable..."
mkdir -p /cookie
touch /cookie/.cookie
chmod 600 /cookie/.cookie
chown bitcoin:bitcoin /cookie/.cookie

# Start Bitcoin Knots
exec bitcoind -conf=/home/bitcoin/.bitcoin/bitcoin.conf -datadir=/bitcoin/.bitcoin
