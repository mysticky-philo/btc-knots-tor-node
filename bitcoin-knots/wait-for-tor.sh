#!/bin/bash
set -e

echo "Waiting for Tor to be available on tor:9050..."
until nc -z tor 9050; do
    sleep 1
done

echo "Tor is up!"
exec bitcoind -conf=/home/bitcoin/.bitcoin/bitcoin.conf -datadir=/bitcoin/.bitcoin
