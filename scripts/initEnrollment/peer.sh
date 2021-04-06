#!/bin/bash

source .env

if [ "$#" -ne 2 ]; then
  echo "please input peer name & secret"
  exit 1
fi

CSR__OU=peer

PEER__NAME=$1
SECRET=$2
DOCKER_PATH=docker/${PEER__NAME}.${ORG__NAME}.com

# ca cert
curl ${CERT_PROVIDER_URL}/cert/ca > ${DOCKER_PATH}/ca-cert.pem

# peer msp needs admin cert
if [ ! -d "${DOCKER_PATH}/msp/admincerts" ]; then
  mkdir -p ${DOCKER_PATH}/msp/admincerts
fi
cp docker/Admin@${ORG__NAME}.com/msp/admincerts/* ${DOCKER_PATH}/msp/admincerts

# generate fabric-ca-client-config
cp templates/ca/fabric-ca-client-config.yaml ${DOCKER_PATH}
sed -i "s/CA__URL/${CA__URL}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/MSP__NAME/${PEER__NAME}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/CSR__C/${CSR__C}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/CSR__ST/${CSR__ST}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/CSR__OU/${CSR__OU}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml

# script for enrolling msp / tls
cp templates/enroll/peerOrderer.sh ${DOCKER_PATH}/enroll.sh
sed -i "s/MSP__NAME/${PEER__NAME}/g" ${DOCKER_PATH}/enroll.sh
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/enroll.sh
sed -i "s/SECRET/${SECRET}/g" ${DOCKER_PATH}/enroll.sh
sed -i "s/CA__URL/${CA__URL}/g" ${DOCKER_PATH}/enroll.sh