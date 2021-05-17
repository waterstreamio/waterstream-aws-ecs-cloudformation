#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

. $SCRIPT_DIR/tls_config.sh

if [ -f "$ROOT_CA_KEY" -a -f "$ROOT_CA_CERT" ]; then
  echo CA files $ROOT_CA_KEY and $ROOT_CA_CERT exist, skip generation
  exit 0
else
  echo "CA files $ROOT_CA_KEY and $ROOT_CA_CERT don't exist yet, going to generate"
fi

echo "********* Generating Root CA **********"
openssl genrsa -out $ROOT_CA_KEY 2048
## create (-new) a self-signed (-x509) certificate with that key. -nodes - don't encrypt the private key
openssl req -config $ROOT_CA_CNF -x509 -new -nodes  -key $ROOT_CA_KEY -days 1024 -out $ROOT_CA_CERT
