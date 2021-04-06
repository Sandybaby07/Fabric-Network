#!/bin/bash

source .env

if [ ! -f "genesis.block" ]; then
  echo "no genesis.block"
  echo "run orderer client to generate genesis block first"
  exit 1
fi

docker-compose up -d