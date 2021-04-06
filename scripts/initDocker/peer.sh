#!/bin/bash

source .env

if [ "$#" -ne 1 ]; then
  echo "please input peer name"
  exit 1
fi
PEER__NAME=$1
DOCKER_PATH=docker/${PEER__NAME}.${ORG__NAME}.com

# check peer folder exists
if [ ! -d "${DOCKER_PATH}" ]; then
  mkdir ${DOCKER_PATH}
fi
if [ ! -d "${DOCKER_PATH}/volume" ]; then
  mkdir ${DOCKER_PATH}/volume
fi
if [ ! -d "${DOCKER_PATH}/volume/couchdb" ]; then
  mkdir ${DOCKER_PATH}/volume/couchdb
fi
if [ ! -d "${DOCKER_PATH}/volume/peer" ]; then
  mkdir ${DOCKER_PATH}/volume/peer
fi

cp templates/docker/peer.yaml ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/PEER__MSP/${PEER__MSP}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/PEER__NAME/${PEER__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml

# scripts for starting container
cp templates/start/basic.sh ${DOCKER_PATH}/start.sh

# template env to start peer
cp templates/env/peer.env ${DOCKER_PATH}/.env

echo "====================================="
echo "uncomment extra_hosts block and modified orderer vars in .env if not the same org as orderer's"
echo "====================================="