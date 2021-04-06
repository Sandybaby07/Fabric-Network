# !/bin/bash

NEW_ADMIN_MSP_PATH=$1

# import utils
source scripts/utils/verifyRes.sh

# fetch config block
peer channel fetch config channel-artifacts/${SYS_CHANNEL_NAME}_config_block.pb \
  -o ${CORE_PEER_ADDRESS} \
  -c ${SYS_CHANNEL_NAME} \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/orderer/orderer-tls/tlscacerts/tlsca-cert.pem
res=$?
verifyResult $res "Failed to fetch config block"

# decode config block to json
configtxlator proto_decode --input channel-artifacts/${SYS_CHANNEL_NAME}_config_block.pb --type common.Block | jq .data.data[0].payload.data.config > channel-artifacts/${SYS_CHANNEL_NAME}_config.json
res=$?
verifyResult $res "Failed to decode original config block to json"

# base64 encode new admin cert
NEW_ADMIN_CERT_BASE64=$(cat $NEW_ADMIN_MSP_PATH/msp/signcerts/cert.pem | base64 | tr -d '\n')
jq '.channel_group.groups.Orderer.groups.'$ORDERER_MSP_NAME'.values.MSP.value.config.admins[.channel_group.groups.Orderer.groups.'$ORDERER_MSP_NAME'.values.MSP.value.config.admins| length] |= . + "'$NEW_ADMIN_CERT_BASE64'"' channel-artifacts/${SYS_CHANNEL_NAME}_config.json > channel-artifacts/modified_${SYS_CHANNEL_NAME}_config.json

# orginal config json => protobuf
configtxlator proto_encode --input channel-artifacts/${SYS_CHANNEL_NAME}_config.json --type common.Config > channel-artifacts/${SYS_CHANNEL_NAME}_original_config.pb
res=$?
verifyResult $res "Failed to encode original config json to protobuf"

# modified config json => protobuf
configtxlator proto_encode --input channel-artifacts/modified_${SYS_CHANNEL_NAME}_config.json --type common.Config > channel-artifacts/${SYS_CHANNEL_NAME}_modified_config.pb
res=$?
verifyResult $res "Failed to encode modified config json to protobuf"

# delta(original pb & modified pb) => delta pb
configtxlator compute_update --channel_id ${SYS_CHANNEL_NAME} --original channel-artifacts/${SYS_CHANNEL_NAME}_original_config.pb --updated channel-artifacts/${SYS_CHANNEL_NAME}_modified_config.pb > channel-artifacts/${SYS_CHANNEL_NAME}_config_update.pb
res=$?
verifyResult $res "Failed to compute delta protobuf"

# delta pb => json
configtxlator proto_decode --input channel-artifacts/${SYS_CHANNEL_NAME}_config_update.pb --type common.ConfigUpdate > channel-artifacts/${SYS_CHANNEL_NAME}_config_update.json
res=$?
verifyResult $res "Failed to decode delta json to protobuf"

# header + delta json => envelope json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'${SYS_CHANNEL_NAME}'", "type":2}},"data":{"config_update":'$(cat channel-artifacts/${SYS_CHANNEL_NAME}_config_update.json)'}}}' | jq . > channel-artifacts/${SYS_CHANNEL_NAME}_config_update_in_envelope.json

# envelope json => envelope pb
configtxlator proto_encode --input channel-artifacts/${SYS_CHANNEL_NAME}_config_update_in_envelope.json --type common.Envelope > channel-artifacts/${SYS_CHANNEL_NAME}_${NEW_ORG_LOWER}_update_in_envelope.pb
res=$?
verifyResult $res "Failed to encode envelope json to protobuf"

# channel update
peer channel update \
  -f channel-artifacts/${SYS_CHANNEL_NAME}_${NEW_ORG_LOWER}_update_in_envelope.pb \
  -c ${SYS_CHANNEL_NAME} \
  -o ${CORE_PEER_ADDRESS} \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/orderer/orderer-tls/tlscacerts/tlsca-cert.pem
res=$?
verifyResult $res "Failed to update channel"

echo
echo "========= All GOOD, Successfully add ${NEW_ORG} consortium =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo