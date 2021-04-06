#!/bin/bash
# clear keystore folder
if [ -d 'msp/keystore' ]; then
  rm -i msp/keystore/*
fi
if [ -d 'tls/keystore' ]; then
  rm -i tls/keystore/*
fi

# enroll msp
export FABRIC_CA_CLIENT_HOME=.
export FABRIC_CA_CLIENT_TLS_CERTFILES=ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://MSP__NAME.ORG__NAME.com:SECRET@CA__URL

# enroll tls
export FABRIC_CA_CLIENT_MSPDIR=tls
fabric-ca-client enroll -d -u https://MSP__NAME.ORG__NAME.com:SECRET@CA__URL --enrollment.profile tls --csr.hosts MSP__NAME.ORG__NAME.com
mv tls/keystore/*_sk tls/keystore/key.pem
mv tls/tlscacerts/tls-* tls/tlscacerts/tlsca-cert.pem