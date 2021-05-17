#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

CLIENT_NAME=$1

echo "********** Generating Client $CLIENT_NAME Key & CSR **********"

CLIENT_KEY=$SCRIPT_DIR/tls/client_${CLIENT_NAME}.key
CLIENT_PKCS8_KEY=$SCRIPT_DIR/tls/client_${CLIENT_NAME}.pkcs8.key
CLIENT_CSR=$SCRIPT_DIR/tls/client_${CLIENT_NAME}.csr

## generate key
openssl genrsa -out $CLIENT_KEY 2048
## convert the key to PKCS#8
openssl pkcs8 -topk8 -inform PEM -outform PEM -in $CLIENT_KEY -out $CLIENT_PKCS8_KEY -nocrypt
## generate Certificate Signing Request
openssl req -new -key $CLIENT_KEY -out $CLIENT_CSR -subj "/C=IT/O=SimpleMatter/OU=WaterstreamTest/CN=${CLIENT_NAME}"

