#!/bin/bash

source .env

DOCKER_PATH=docker/zookeeper1.${ORG__NAME}.com

# create folder for zookeeper container
if [ ! -d "${DOCKER_PATH}" ]; then
  mkdir ${DOCKER_PATH}
fi
if [ ! -d "${DOCKER_PATH}/volume" ]; then
  mkdir ${DOCKER_PATH}/volume
fi
if [ ! -d "${DOCKER_PATH}/volume/data" ]; then
  mkdir ${DOCKER_PATH}/volume/data
fi
if [ ! -d "${DOCKER_PATH}/volume/log" ]; then
  mkdir ${DOCKER_PATH}/volume/log
fi

# copy zookeeper files
cp templates/docker/zookeeper1.yaml ${DOCKER_PATH}/docker-compose.yaml

sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml

# scripts for starting container
cp templates/start/basic.sh ${DOCKER_PATH}/start.sh