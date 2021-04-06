checkBinaries() {
  source .env

  CURL_PATH=$(which curl)
  if [ -z "$CURL_PATH" ]; then
    echo "!!!!!!!!!!!!!!! curl is not installed !!!!!!!!!!!!!!!!"
    echo "run commands below to install 'curl' :-)"
    echo "====================================="
    echo "sudo apt update && sudo apt upgrade \\"
    echo "sudo apt install curl"
    echo "curl --version"
    echo "====================================="

    exit 1
  fi

  DOCKER_PATH=$(which docker)
  if [ -z "$DOCKER_PATH" ]; then
    echo "!!!!!!!!!!!!!!! docker is not installed !!!!!!!!!!!!!!!!"
    echo "run commands below to install docker :-)"

    echo "====================================="
    echo "sudo apt update \\"
    echo "apt-transport-https \\"
    echo "ca-certificates \\"
    echo "curl \\"
    echo "gnupg-agent \\"
    echo "software-properties-common "
    echo "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \\"
    echo "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'"
    echo "sudo apt-get update"
    echo "apt-cache madison docker-ce"
    echo "sudo apt-get install docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io"
    echo "docker --version"
    echo "sudo groupadd docker"
    echo "sudo gpasswd -a $USER docker"
    echo "newgrp docker"
    echo 
    echo "====================================="

    exit 1
  fi

  DOCKER_COMPOSE_PATH=$(which docker-compose)
  if [ -z "$DOCKER_COMPOSE_PATH" ]; then
    echo "!!!!!!!!!!!!!!! docker-compose is not installed!!!!!!!!!!!!!!!!"
    echo "run commands below to install docker-compose :-)"

    echo "====================================="
    echo "sudo curl -L 'https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose"
    echo "sudo chmod +x /usr/local/bin/docker-compose"
    echo "docker-compose --version"
    echo 
    echo "====================================="

    exit 1
  fi

  FABRIC_CA_CLIENT_PATH=$(which fabric-ca-client)
  if [ -z "$FABRIC_CA_CLIENT_PATH" ]; then
    echo "!!!!!!!!!!!!!!! fabric-ca-client is not installed!!!!!!!!!!!!!!!!"
    echo "run commands below to install fabric-ca-client :-)"

    echo "====================================="
    echo "curl -sSL https://bit.ly/2ysbOFE | bash -s -- -sd 1.4.0 1.4.0 0.4.15"
    echo "rm -rf config"
    echo "echo 'export PATH=\$PATH:$PWD/bin' >> ~/.bashrc"
    echo "source ~/.bashrc"
    echo
    echo "====================================="

    exit 1
  fi
}