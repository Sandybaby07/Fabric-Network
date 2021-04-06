#!/bin/bash

source .env
source scripts/prepare/utils/checkBinaries.sh
source scripts/prepare/utils/checkAdmin.sh

PEER__NAME=$1
SECRET=$2

# check required binaries
checkBinaries

# check if admin folder exists
checkAdmin

# peer
./scripts/initDocker/peer.sh $PEER__NAME
./scripts/initEnrollment/peer.sh $PEER__NAME $SECRET
pushd docker/$PEER__NAME.$ORG__NAME.com
./enroll.sh
popd

# cli.peer
./scripts/initDocker/cliPeer.sh $PEER__NAME
