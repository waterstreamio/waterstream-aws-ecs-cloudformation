#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

. $SCRIPT_DIR/tls_config.sh

echo "********** Generating Client Certificate **********"
CLIENT_NAME=$1

if [ -z "$CLIENT_NAME" ]
then
  echo Client name not specified
  exit 1
fi

CLIENT_KEY=$MQTT_CLIENT_CERTIFICATES_FOLDER/client_${CLIENT_NAME}.key
CLIENT_PKCS8_KEY=$MQTT_CLIENT_CERTIFICATES_FOLDER/client_${CLIENT_NAME}.pkcs8.key
CLIENT_CSR=$MQTT_CLIENT_CERTIFICATES_FOLDER/client_${CLIENT_NAME}.csr
CLIENT_CRT=$MQTT_CLIENT_CERTIFICATES_FOLDER/client_${CLIENT_NAME}.crt

## generate key
openssl genrsa -out $CLIENT_KEY 2048
## generate Certificate Signing Request
openssl req -new -key $CLIENT_KEY -out $CLIENT_CSR -subj "/C=IT/O=SimpleMatter/OU=WaterstreamTest/CN=${CLIENT_NAME}"
## sign CSR with Root CA key
openssl x509 -req -in $CLIENT_CSR -CA $ROOT_CA_CERT -CAkey $ROOT_CA_KEY -CAcreateserial -out $CLIENT_CRT -days 500 -sha256
## convert the key to PKCS#8
openssl pkcs8 -topk8 -inform PEM -outform PEM -in $CLIENT_KEY -out $CLIENT_PKCS8_KEY -nocrypt

rm $CLIENT_CSR

