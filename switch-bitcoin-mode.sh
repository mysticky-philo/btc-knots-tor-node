#!/bin/bash

MODE="$1"
CONF_DIR="./bitcoin-knots"
BASE_CONF="${CONF_DIR}/bitcoin.conf.base"
TARGET_CONF="${CONF_DIR}/bitcoin.conf"
CLEARNET="${CONF_DIR}/bitcoin.conf.clearnet"
ONION="${CONF_DIR}/bitcoin.conf.onion"

if [ "$MODE" != "clearnet" ] && [ "$MODE" != "onion" ]; then
    echo "Usage: $0 [clearnet|onion]"
    exit 1
fi

echo "Switching to ${MODE} mode..."

# Rebuild config
cp "$BASE_CONF" "$TARGET_CONF"
if [ "$MODE" == "clearnet" ]; then
    cat "$CLEARNET" >> "$TARGET_CONF"
else
    cat "$ONION" >> "$TARGET_CONF"
fi

# Restart bitcoin-knots container
echo "Restarting bitcoin-knots container..."
docker compose restart bitcoin-knots
