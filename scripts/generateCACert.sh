#!/bin/bash

source .env

# Generate cert for fabric-ca server
CONFIG_FILE=configs/openssl.conf
OUTPUT_DIR=docker/ca.${ORG__NAME}.com/server-home

# check ca cert and key
if [ ! -d "${OUTPUT_DIR}" ]; then
  mkdir -p ${OUTPUT_DIR}
fi
rm -f ${OUTPUT_DIR}/*.pem

openssl ecparam -name prime256v1 -genkey -noout \
-out $OUTPUT_DIR/ca-key.pem

openssl req -new -sha256 \
-key $OUTPUT_DIR/ca-key.pem \
-out $OUTPUT_DIR/ca-csr.pem

openssl req -config $CONFIG_FILE -x509 -sha256 -days 3650 \
-key $OUTPUT_DIR/ca-key.pem \
-in $OUTPUT_DIR/ca-csr.pem \
-out $OUTPUT_DIR/ca-cert.pem

rm $OUTPUT_DIR/ca-csr.pem
