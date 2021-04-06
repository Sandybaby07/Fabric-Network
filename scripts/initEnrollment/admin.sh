#!/bin/bash

source .env

if [ "$#" -ne 2 ]; then
  echo "please input admin name & secret"
  exit 1
fi

CSR__OU=admin

ADMIN__NAME=$1
SECRET=$2
DOCKER_PATH=docker/${ADMIN__NAME}@${ORG__NAME}.com

# check if admin folder needs to be created
if [ ! -d "${DOCKER_PATH}" ]; then
  mkdir ${DOCKER_PATH}
fi

# ca cert
curl ${CERT_PROVIDER_URL}/cert/ca > ${DOCKER_PATH}/ca-cert.pem

# generate fabric-ca-client-config
cp templates/ca/fabric-ca-client-config.yaml ${DOCKER_PATH}
sed -i "s/CA__URL/${CA__URL}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/MSP__NAME/${ADMIN__NAME}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/CSR__C/${CSR__C}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/CSR__ST/${CSR__ST}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml
sed -i "s/CSR__OU/${CSR__OU}/g" ${DOCKER_PATH}/fabric-ca-client-config.yaml

# script for enrolling msp
cp templates/enroll/admin.sh ${DOCKER_PATH}/enroll.sh
sed -i "s/ADMIN__NAME/${ADMIN__NAME}/g" ${DOCKER_PATH}/enroll.sh
sed -i "s/ORG__NAME/${ORG__NAME}/g" ${DOCKER_PATH}/enroll.sh
sed -i "s/SECRET/${SECRET}/g" ${DOCKER_PATH}/enroll.sh
sed -i "s/CA__URL/${CA__URL}/g" ${DOCKER_PATH}/enroll.sh