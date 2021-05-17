#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

. $SCRIPT_DIR/tls_config.sh

echo "********** Generating Broker Certificate **********"
MQTT_BROKER_RAW_KEY=mqtt_broker_test.key
#BROKER_PKCS8_KEY=broker_test.pkcs8.key
MQTT_BROKER_CSR=$MQTT_BROKER_CERTIFICATE_FOLDER/mqtt_broker.csr
#BROKER_CRT=broker_test.crt
cd $MQTT_BROKER_CERTIFICATE_FOLDER
## generate key
openssl genrsa -out $MQTT_BROKER_RAW_KEY 2048
## generate Certificate Signing Request
openssl req -config $MQTT_BROKER_CNF -new -key $MQTT_BROKER_RAW_KEY -out $MQTT_BROKER_CSR
## sign CSR with Root CA key
openssl x509 -req -in $MQTT_BROKER_CSR -CA $ROOT_CA_CERT -CAkey $ROOT_CA_KEY -CAcreateserial -out $MQTT_BROKER_CERT -days 500 -sha256
#openssl x509 -req -in $MQTT_BROKER_CSR -CA ./$ROOT_CA_CERT -CAkey ./$ROOT_CA_KEY -CAcreateserial -out $BROKER_CRT -days 500 -sha256 -extfile broker.ext
## convert the key to PKCS#8
openssl pkcs8 -topk8 -inform PEM -outform PEM -in $MQTT_BROKER_RAW_KEY -out $MQTT_BROKER_KEY -nocrypt


