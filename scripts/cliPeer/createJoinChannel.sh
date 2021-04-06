#!/bin/bash

CHANNEL=$1

# import utils
source scripts/utils/verifyRes.sh
source scripts/utils/checkChannelFolder.sh

checkChannelFolder $CHANNEL
CHANNEL_PATH=channel-artifacts/$CHANNEL

# cr-channel: create channel tx
configtxgen -configPath configs/$ORG_NAME -profile DefaultChannel -outputCreateChannelTx $CHANNEL_PATH/$CHANNEL.tx -channelID $CHANNEL
res=$?
verifyResult $res "Failed to create channel tx"

configtxgen -configPath configs/$ORG_NAME -profile DefaultChannel -outputAnchorPeersUpdate $CHANNEL_PATH/${ORG_NAME}Anchor.tx -channelID $CHANNEL -asOrg $PEER_MSP_NAME
res=$?
verifyResult $res "Failed to create anchor peer tx"

# create channel
peer channel create \
  --outputBlock $CHANNEL_PATH/$CHANNEL.block \
  -o $ORDERER_NAME:$ORDERER_PORT \
  -c $CHANNEL \
  -f $CHANNEL_PATH/$CHANNEL.tx \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/orderers/orderer-tls-cert.pem
res=$?
verifyResult $res "Failed to create the channel"

# join
peer channel join \
  -b $CHANNEL_PATH/$CHANNEL.block
res=$?
verifyResult $res "Failed to exec cli.peer to create the channel"

# anchor peer
peer channel update \
  -o $ORDERER_NAME:$ORDERER_PORT \
  -c $CHANNEL \
  -f $CHANNEL_PATH/${ORG_NAME}Anchor.tx \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/orderers/orderer-tls-cert.pem
res=$?
verifyResult $res "Failed to exec cli.peer to join the channel"

echo
echo "========= All GOOD, Successfully create and join the channel =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo