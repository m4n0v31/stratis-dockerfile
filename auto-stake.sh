#!/bin/bash
set -e

echo "Starting Stratis daemon..."
stratisd -datadir=$STRATIS_DATA_DIR -rescan -detachdb &

echo "Waiting for daemon before unlocking wallet..."
sleep 120

echo "Unlocking wallet for staking..."
stratisd -datadir=$STRATIS_DATA_DIR walletpassphrase $WALLET_PASSPHRASE 9999999 true
echo "Wallet unlocked successfully."

wait
