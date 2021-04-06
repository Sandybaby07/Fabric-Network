#!/bin/bash

source .env

DOCKER_PATH=docker/ca.${ORG__NAME}.com

if [ ! -d "${DOCKER_PATH}" ]; then
  mkdir ${DOCKER_PATH}
fi
if [ ! -d "${DOCKER_PATH}/server-home" ]; then
  mkdir ${DOCKER_PATH}/server-home
fi

cp templates/docker/ca.yaml ${DOCKER_PATH}/docker-compose.yaml

sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml

cp -r scripts/ca ${DOCKER_PATH}/scripts

# scripts for starting container
cp templates/start/ca.sh ${DOCKER_PATH}/start.sh

# template env for ca to start
cp templates/env/ca.env ${DOCKER_PATH}/.env