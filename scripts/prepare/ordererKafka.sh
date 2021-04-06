#!/bin/bash

source .env
source scripts/prepare/utils/checkBinaries.sh
source scripts/prepare/utils/checkAdmin.sh

ORDERER__NAME=$1
SECRET=$2

# check required binaries
checkBinaries

# check if admin folder exists
checkAdmin

# orderer
./scripts/initDocker/ordererKafka.sh $ORDERER__NAME
./scripts/initEnrollment/orderer.sh $ORDERER__NAME $SECRET
pushd docker/$ORDERER__NAME.$ORG__NAME.com
./enroll.sh
popd

# cli.orderer
./scripts/initDocker/cliOrderer.sh $ORDERER__NAME
