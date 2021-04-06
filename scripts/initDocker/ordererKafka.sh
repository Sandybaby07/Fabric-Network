#!/bin/bash

source .env

if [ "$#" -ne 1 ]; then
  echo "please input orderer name"
  exit 1
fi
ORDERER__NAME=$1
DOCKER_PATH=docker/${ORDERER__NAME}.${ORG__NAME}.com

# check orderer folder exists
if [ ! -d "${DOCKER_PATH}" ]; then
  mkdir ${DOCKER_PATH}
fi
if [ ! -d "${DOCKER_PATH}/volume" ]; then
  mkdir ${DOCKER_PATH}/volume
fi

# copy orderer file
cp templates/docker/orderer.yaml ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORDERER__MSP/${ORDERER__MSP}/g" ${DOCKER_PATH}/docker-compose.yaml
sed -i "s/ORDERER__NAME/${ORDERER__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml

# scripts for starting container
cp templates/start/orderer.sh ${DOCKER_PATH}/start.sh

# template env for orderer to start
cp templates/env/orderer.env ${DOCKER_PATH}/.env