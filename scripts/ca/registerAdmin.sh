#!/bin/bash

NAME=$1
SECRET=$2

fabric-ca-client register --id.name $NAME.${ORG_NAME}.com --id.secret $SECRET --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://$FABRIC_CA_SERVER_CA_NAME:$CA_PORT