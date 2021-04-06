#!/bin/bash

NAME=$1
SECRET=$2

fabric-ca-client register --id.name $NAME.${ORG_NAME}.com --id.secret $SECRET --id.type orderer -u https://$FABRIC_CA_SERVER_CA_NAME:$CA_PORT