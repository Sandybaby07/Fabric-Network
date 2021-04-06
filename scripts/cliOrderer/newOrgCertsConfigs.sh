#!/bin/bash

# set params
NEW_ORG=$1
CA_URL=$2
NEW_ORG_LOWER=$(echo $NEW_ORG | awk '{print tolower($0)}')

# generate folder structure
mkdir -p certs/${NEW_ORG_LOWER}.com/msp/admincerts
mkdir -p certs/${NEW_ORG_LOWER}.com/msp/cacerts
mkdir -p certs/${NEW_ORG_LOWER}.com/msp/tlscacerts
mkdir -p configs/${NEW_ORG_LOWER}

# curl ca for certs (admincerts / cacerts / tlscacerts)
curl ${CA_URL}/cert/admin > certs/${NEW_ORG_LOWER}.com/msp/admincerts/cert.pem
curl ${CA_URL}/cert/ca > certs/${NEW_ORG_LOWER}.com/msp/cacerts/cert.pem
curl ${CA_URL}/cert/ca > certs/${NEW_ORG_LOWER}.com/msp/tlscacerts/cert.pem

# configtx.yaml
cp configs/configtxNewOrg.yaml configs/${NEW_ORG_LOWER}/configtx.yaml
sed -i "s/NEW_ORG_LOWER/${NEW_ORG_LOWER}/g" configs/${NEW_ORG_LOWER}/configtx.yaml
sed -i "s/NEW_ORG/${NEW_ORG}/g" configs/${NEW_ORG_LOWER}/configtx.yaml