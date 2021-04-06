#!/bin/bash

CHANNEL=$1

# import utils
source scripts/utils/verifyRes.sh
source scripts/utils/checkChannelFolder.sh

checkChannelFolder $CHANNEL
CHANNEL_PATH=channel-artifacts/$CHANNEL

# fetch channel block
peer channel fetch 0 $CHANNEL_PATH/$CHANNEL.block \
  -o $ORDERER_NAME:$ORDERER_PORT \
  -c $CHANNEL \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/orderers/orderer-tls-cert.pem
res=$?
verifyResult $res "Failed to fetch channel block"

# join the channel
peer channel join \
  -b $CHANNEL_PATH/$CHANNEL.block
res=$?
verifyResult $res "Failed to join the channel"

echo
echo "========= All GOOD, Successfully join the channel =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo