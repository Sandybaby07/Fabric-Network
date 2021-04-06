# import utils
source scripts/utils/verifyRes.sh

CHAINCODE=$1
VERSION=$2

if [ ! -f "./chaincodes.env/$CHAINCODE.env" ]; then
  verifyResult 1 "Must provide ./chaincodes.env/$CHAINCODE.env"
fi

source ./chaincodes.env/$CHAINCODE.env

# pack chaincode
peer chaincode package -n $CHAINCODE -v $VERSION -l $LANGUAGE -p $CHAINCODE_PATH channel-artifacts/${CHAINCODE}_${VERSION}.out
res=$?
verifyResult $res "Failed to create chaincode package"

echo
echo "========= All GOOD, Successfully created chaincode package =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo