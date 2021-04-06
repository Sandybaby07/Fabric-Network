CHANNEL=$1
CHAINCODE=$2
VERSION=$3

source ./chaincodes.env/${CHAINCODE}.env

# import utils
source scripts/utils/verifyRes.sh

# instantiate chaincode
if [ -z "$INIT_METHOD" ]; then
  peer chaincode instantiate -o $ORDERER_NAME:$ORDERER_PORT \
    -n $CHAINCODE -v $VERSION -C $CHANNEL -c '{"Args":[]}' \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/orderers/orderer-tls-cert.pem \
    -P "$POLICY"
else
  peer chaincode instantiate -o $ORDERER_NAME:$ORDERER_PORT \
    -n $CHAINCODE -v $VERSION -C $CHANNEL -c '{"Args":["'$INIT_METHOD'"]}' \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/orderers/orderer-tls-cert.pem \
    -P "$POLICY"
fi
res=$?
verifyResult $res "Failed to instantiate chaincode"

  
echo
echo "========= All GOOD, Successfully instantiate chaincode =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo