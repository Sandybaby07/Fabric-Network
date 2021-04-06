#!/bin/bash

source .env

if [ "$#" -ne 1 ]; then
  echo "please input orderer name"
  exit 1
fi
ORDERER__NAME=$1
DOCKER_PATH=docker/cli.${ORDERER__NAME}.${ORG__NAME}.com

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
cp -r docker/${ORDERER__NAME}.${ORG__NAME}.com/msp/admincerts ${DOCKER_PATH}/certs/${ORG__NAME}.com/msp
cp -r docker/${ORDERER__NAME}.${ORG__NAME}.com/msp/cacerts ${DOCKER_PATH}/certs/${ORG__NAME}.com/msp
cp -r docker/${ORDERER__NAME}.${ORG__NAME}.com/tls/tlscacerts ${DOCKER_PATH}/certs/${ORG__NAME}.com/msp

# tls folder used to communicate with related peer
cp -r docker/${ORDERER__NAME}.${ORG__NAME}.com/tls ${DOCKER_PATH}/orderer-tls

# configtx for generating transaction
cp -r configs ${DOCKER_PATH}
# configtx templates
cp templates/configs/* ${DOCKER_PATH}/configs

# scripts for cli container to use: add consortium, ..., etc
cp -r scripts/cliOrderer ${DOCKER_PATH}/scripts

# docker-compose for cli
cp templates/docker/cli_orderer.yaml ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORDERER__MSP__NAME/${ORDERER__MSP%"MSP"}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORDERER__MSP/${ORDERER__MSP}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORDERER__NAME/${ORDERER__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml

# scripts for starting container
cp templates/start/basic.sh ${DOCKER_PATH}/start.sh