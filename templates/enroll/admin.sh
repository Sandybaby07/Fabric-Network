#!/bin/bash
# clear keystore folder
if [ -d 'msp/keystore' ]; then
  rm -i msp/keystore/*
fi

# enroll msp
export FABRIC_CA_CLIENT_HOME=.
export FABRIC_CA_CLIENT_TLS_CERTFILES=ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://ADMIN__NAME.ORG__NAME.com:SECRET@CA__URL

mkdir msp/admincerts
cp msp/signcerts/*.pem msp/admincerts