#!/bin/bash

CHANNEL=$1
NEW_ADMIN_MSP_PATH=$2

# import utils
source scripts/utils/verifyRes.sh
source scripts/utils/checkChannelFolder.sh

checkChannelFolder $CHANNEL
CHANNEL_PATH=channel-artifacts/$CHANNEL

# fetch config block
peer channel fetch config $CHANNEL_PATH/config_block.pb \
  -o $ORDERER_NAME:$ORDERER_PORT \
  -c $CHANNEL \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/orderers/orderer-tls-cert.pem
res=$?
verifyResult $res "Failed to fetch config block"

# decode config block to json
configtxlator proto_decode --input $CHANNEL_PATH/config_block.pb --type common.Block | jq .data.data[0].payload.data.config > $CHANNEL_PATH/config.json
res=$?
verifyResult $res "Failed to decode original config block to json"

# base64 encode new admin cert
NEW_ADMIN_CERT_BASE64=$(cat $NEW_ADMIN_MSP_PATH/msp/signcerts/cert.pem | base64 | tr -d '\n')
jq '.channel_group.groups.Application.groups.'$PEER_MSP_NAME'.values.MSP.value.config.admins[.channel_group.groups.Application.groups.'$PEER_MSP_NAME'.values.MSP.value.config.admins| length] |= . + "'$NEW_ADMIN_CERT_BASE64'"' $CHANNEL_PATH/config.json > $CHANNEL_PATH/modified_config.json

# orginal config json => protobuf
configtxlator proto_encode --input $CHANNEL_PATH/config.json --type common.Config > $CHANNEL_PATH/original_config.pb
res=$?
verifyResult $res "Failed to encode original config json to protobuf"

# modified config json => protobuf
configtxlator proto_encode --input $CHANNEL_PATH/modified_config.json --type common.Config > $CHANNEL_PATH/modified_config.pb
res=$?
verifyResult $res "Failed to encode modified config json to protobuf"

# delta(original pb & modified pb) => delta pb
configtxlator compute_update --channel_id "$CHANNEL" --original $CHANNEL_PATH/original_config.pb --updated $CHANNEL_PATH/modified_config.pb > $CHANNEL_PATH/config_update.pb
res=$?
verifyResult $res "Failed to compute delta protobuf"

# delta pb => json
configtxlator proto_decode --input $CHANNEL_PATH/config_update.pb --type common.ConfigUpdate > $CHANNEL_PATH/config_update.json
res=$?
verifyResult $res "Failed to decode delta json to protobuf"

# header + delta json => envelope json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat $CHANNEL_PATH/config_update.json)'}}}' | jq . > $CHANNEL_PATH/config_update_in_envelope.json

# envelope json => envelope pb
configtxlator proto_encode --input $CHANNEL_PATH/config_update_in_envelope.json --type common.Envelope > $CHANNEL_PATH/config_update_in_envelope.pb
res=$?
verifyResult $res "Failed to decode original config block to json"

echo
echo "========= All GOOD, Successfully create new org tx =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo