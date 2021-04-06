#!/bin/bash

source .env

if [ "$#" -ne 1 ]; then
  echo "please input peer name"
  exit 1
fi
PEER__NAME=$1
DOCKER_PATH=docker/cli.${PEER__NAME}.${ORG__NAME}.com

# check cli folder exists
if [ ! -d "${DOCKER_PATH}" ]; then
  mkdir ${DOCKER_PATH}
fi
if [ ! -d "${DOCKER_PATH}/channel-artifacts" ]; then
  mkdir ${DOCKER_PATH}/channel-artifacts
fi

# CORE_PEER_MSPCONFIGPATH for cli
if [ ! -d "${DOCKER_PATH}/users" ]; then
  mkdir ${DOCKER_PATH}/users
fi
cp -r docker/Admin@${ORG__NAME}.com ${DOCKER_PATH}/users

# msp folder for this org
mkdir -p ${DOCKER_PATH}/certs/${ORG__NAME}.com/msp
cp -r docker/${PEER__NAME}.${ORG__NAME}.com/msp/admincerts ${DOCKER_PATH}/certs/${ORG__NAME}.com/msp
cp -r docker/${PEER__NAME}.${ORG__NAME}.com/msp/cacerts ${DOCKER_PATH}/certs/${ORG__NAME}.com/msp
cp -r docker/${PEER__NAME}.${ORG__NAME}.com/tls/tlscacerts ${DOCKER_PATH}/certs/${ORG__NAME}.com/msp

# tls folder used to communicate with related peer
cp -r docker/${PEER__NAME}.${ORG__NAME}.com/tls ${DOCKER_PATH}/peer-tls

# orderer tls cert to communicate with related orderer
curl ${ORDERER_CERT_URL}/cert/ca > ${DOCKER_PATH}/orderer-tls-cert.pem

# configtx for generating transaction
cp -r configs ${DOCKER_PATH}
# configtx template for new org
cp templates/configs/configtxNewOrg.yaml ${DOCKER_PATH}/configs
# configtx template for myself
if [ ! -f "${DOCKER_PATH}/configs/${ORG__NAME}/configtx.yaml" ]; then
  mkdir ${DOCKER_PATH}/configs/${ORG__NAME}
  cp templates/configs/configtxBasic.yaml ${DOCKER_PATH}/configs/${ORG__NAME}/configtx.yaml
  sed -i "s/NEW_ORG_LOWER/${ORG__NAME}/g" ${DOCKER_PATH}/configs/${ORG__NAME}/configtx.yaml
  sed -i "s/NEW_ORG/${PEER__MSP%"MSP"}/g" ${DOCKER_PATH}/configs/${ORG__NAME}/configtx.yaml
fi

# scripts for cli container to use: create / update channel, ..., etc
cp -r scripts/cliPeer ${DOCKER_PATH}/scripts

# chaincodes folder
mkdir ${DOCKER_PATH}/chaincodes

# env folder for chaincodes
mkdir ${DOCKER_PATH}/chaincodes.env

# docker-compose for cli
cp templates/docker/cli_peer.yaml ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/PEER__MSP__NAME/${PEER__MSP%"MSP"}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/PEER__MSP/${PEER__MSP}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/PEER__NAME/${PEER__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml

# scripts for starting container
cp templates/start/basic.sh ${DOCKER_PATH}/start.sh

# template env to start cli.peer
cp templates/env/cliPeer.env ${DOCKER_PATH}/.env

echo "====================================="
echo "uncomment extra_hosts block and modified orderer vars in .env if not the same org as orderer's"
echo "====================================="
echo "====================================="
echo "uncomment chaincode volume and add chaincode name, clone chaincode folder into chaincodes folder"
echo "====================================="