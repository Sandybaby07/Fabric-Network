# import utils
source scripts/utils/verifyRes.sh

CHAINCODE=$1
VERSION=$2

# install chaincode
peer chaincode install channel-artifacts/${CHAINCODE}_${VERSION}.out
res=$?
verifyResult $res "Failed to install chaincode using chaincode package"

echo
echo "========= All GOOD, Successfully install chaincode =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo