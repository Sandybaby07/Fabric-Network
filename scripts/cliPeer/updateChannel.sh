CHANNEL=$1
BLOCK_PATH=$2

# import utils
source scripts/utils/verifyRes.sh

# channel update
peer channel update \
  -f $BLOCK_PATH \
  -c $CHANNEL \
  -o $ORDERER_NAME:$ORDERER_PORT \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/orderers/orderer-tls-cert.pem
res=$?
verifyResult $res "Failed to update channel"

echo
echo "========= All GOOD, Successfully update the channel =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo