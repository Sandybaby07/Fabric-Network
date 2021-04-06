checkAdmin() {
  source .env
  source scripts/prepare/utils/checkBinaries.sh

  # check required binaries
  checkBinaries

  # check if admin is already enrolled
  if [ ! -d "docker/Admin@${ORG__NAME}.com" ]; then
    echo "!!!!!!!!!!!!!!! no admin folder !!!!!!!!!!!!!!!!"
    echo "run commands below to create admin folder :-)"
    echo "====================================="
    echo "./scripts/prepare/admin.sh"
    echo "====================================="

    exit 1
  fi
}