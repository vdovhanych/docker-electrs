#!/bin/bash

echo -e "\nStarting bitcoin node.\n"
/usr/bin/bitcoind -regtest -server -daemon --rpccookiefile=/root/.cookie -fallbackfee=0.0002 -rpcallowip=0.0.0.0/0 -rpcbind=0.0.0.0 -rpcport=18021 -blockfilterindex=1 -peerblockfilters=1

BITCOIN_CLI="/usr/bin/bitcoin-cli -regtest -datadir=/root/.bitcoin --rpccookiefile=/root/.cookie -rpcport=18021"

echo -e "\nWaiting for bitcoin node.\n"
until $BITCOIN_CLI getblockchaininfo; do
    sleep 1
done
echo -e "\nCreate tenv-test wallet.\n"
$BITCOIN_CLI createwallet tenv-test

echo -e "\nGenerating 150 bitcoin blocks.\n"
ADDR=$($BITCOIN_CLI -rpcwallet=tenv-test getnewaddress)
$BITCOIN_CLI generatetoaddress 150 $ADDR

# echo -e "\nStarting electrs node.\n"
/usr/bin/electrs --log-filters INFO --db-dir /tmp/electrs-db --electrum-rpc-addr="0.0.0.0:50001" --daemon-rpc-addr="0.0.0.0:18021" --network=regtest --cookie-file=/root/.cookie
