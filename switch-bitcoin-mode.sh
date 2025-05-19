#!/bin/bash

CONF_FILE="./bitcoin-knots/bitcoin.conf"
MODE=$1

if [ -z "$MODE" ]; then
  echo "Usage: $0 [clearnet|tor]"
  exit 1
fi

if [ "$MODE" = "clearnet" ]; then
  echo "Switching to clearnet mode..."
  sed -i 's/^onlynet=.*/#onlynet=onion/' "$CONF_FILE"
  sed -i 's/^proxy=.*/#proxy=tor:9050/' "$CONF_FILE"
elif [ "$MODE" = "tor" ]; then
  echo "Switching to Tor-only mode..."
  sed -i '/^#onlynet=onion/ s/^#//' "$CONF_FILE"
  sed -i '/^#proxy=tor:9050/ s/^#//' "$CONF_FILE"
else
  echo "Unknown mode: $MODE"
  exit 1
fi

echo "Restarting bitcoin-knots container..."
docker compose restart bitcoin-knots
