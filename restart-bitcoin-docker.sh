#!/bin/bash

# Resolve the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR" || exit 1

echo "$(date '+%Y-%m-%d %H:%M:%S') Restarting bitcoin-knots and tor containers..." >> restart.log
docker compose restart bitcoin-knots tor
