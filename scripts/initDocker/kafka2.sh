#!/bin/bash

source .env

DOCKER_PATH=docker/kafka2.${ORG__NAME}.com

# create folder for zookeeper container
if [ ! -d "${DOCKER_PATH}" ]; then
  mkdir ${DOCKER_PATH}
fi
if [ ! -d "${DOCKER_PATH}/volume" ]; then
  mkdir ${DOCKER_PATH}/volume
fi

# copy zookeeper files
cp templates/docker/kafka2.yaml ${DOCKER_PATH}/docker-compose.yaml

sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/docker-compose.yaml

# scripts for starting container
echo '#!/bin/bash
docker-compose up -d' > ${DOCKER_PATH}/start.sh
chmod +x ${DOCKER_PATH}/start.sh