#!/bin/bash

# import utils

ORDERER_URL=$1

source scripts/utils/verifyRes.sh

peer channel fetch 0 channel-artifacts/genesis.block \
  -o ${ORDERER_URL} \
  -c ${SYS_CHANNEL_NAME} \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/orderer/orderer-tls/tlscacerts/tlsca-cert.pem
res=$?
verifyResult $res "Failed to fetch genesis block"

echo
echo "========= All GOOD, Successfully fetch genesis block =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo