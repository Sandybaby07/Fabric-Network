#!/bin/bash

source .env
source scripts/prepare/utils/checkBinaries.sh

# check required binaries
checkBinaries

# admin
./scripts/initEnrollment/admin.sh $ADMIN__NAME $ADMIN__SECRET
pushd docker/Admin@${ORG__NAME}.com
./enroll.sh
popd