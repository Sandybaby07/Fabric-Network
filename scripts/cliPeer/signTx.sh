CHANNEL=$1
BLOCK_PATH=$2

# import utils
source scripts/utils/verifyRes.sh

# sign envelope pb
peer channel signconfigtx -f $BLOCK_PATH
res=$?
verifyResult $res "Failed to sign the tx"

echo
echo "========= All GOOD, Successfully sign the tx =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo