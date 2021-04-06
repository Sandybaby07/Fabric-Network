#!/bin/bash

source scripts/utils/verifyRes.sh

configtxgen -configPath configs/${ORG_NAME} \
  -profile OrdererGenesis \
  -channelID ${SYS_CHANNEL_NAME} \
  -outputBlock ./channel-artifacts/genesis.block

echo
echo "========= All GOOD, Successfully create genesis block =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo