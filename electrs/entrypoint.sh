#!/bin/bash

echo -e "\nStarting bitcoin node.\n"
/usr/bin/bitcoind -regtest -server -daemon --rpccookiefile=/root/.cookie -fallbackfee=0.0002 -rpcallowip=0.0.0.0/0 -rpcbind=0.0.0.0 -rpcport=18021 -blockfilterindex=1 -peerblockfilters=1

echo -e "\nWaiting for bitcoin node.\n"
until /usr/bin/bitcoin-cli -regtest -datadir=/root/.bitcoin --rpccookiefile=/root/.cookie -rpcport=18021 getblockchaininfo; do
    sleep 1
done
echo -e "\nCreate tenv-test wallet.\n"
/usr/bin/bitcoin-cli -regtest -datadir=/root/.bitcoin --rpccookiefile=/root/.cookie -rpcport=18021 createwallet tenv-test

echo -e "\nGenerating 150 bitcoin blocks.\n"
ADDR=$(/usr/bin/bitcoin-cli -regtest -datadir=/root/.bitcoin --rpccookiefile=/root/.cookie -rpcport=18021 -rpcwallet=tenv-test getnewaddress)
/usr/bin/bitcoin-cli -regtest -datadir=/root/.bitcoin --rpccookiefile=/root/.cookie -rpcport=18021 generatetoaddress 150 $ADDR

# echo -e "\nStarting electrs node.\n"
/usr/bin/electrs --log-filters INFO --db-dir /tmp/electrs-db --electrum-rpc-addr="0.0.0.0:50001" --daemon-rpc-addr="0.0.0.0:18021" --network=regtest --cookie-file=/root/.cookie
