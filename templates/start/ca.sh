#!/bin/bash

source .env

if [ ! -f "server-home/ca-cert.pem" ]; then
  echo "no server-home/ca-cert.pem"
  exit 1
fi
if [ ! -f "server-home/ca-key.pem" ]; then
  echo "no server-home/ca-key.pem"
  exit 1
fi

docker-compose up -d