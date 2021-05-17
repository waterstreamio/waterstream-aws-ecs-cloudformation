#!/bin/sh
set -e

TLS_BASE_FOLDER=/home/ec2-user/tls

ROOT_CA_FOLDER=$TLS_BASE_FOLDER/root
ROOT_CA_CNF=$ROOT_CA_FOLDER/waterstream_adhoc_ca.cnf
ROOT_CA_KEY=$ROOT_CA_FOLDER/waterstream_adhoc_ca.key
ROOT_CA_CERT=$ROOT_CA_FOLDER/waterstream_adhoc_ca.pem


MQTT_BROKER_CERTIFICATE_FOLDER=$TLS_BASE_FOLDER/mqtt_broker
MQTT_BROKER_CNF=$MQTT_BROKER_CERTIFICATE_FOLDER/mqtt_broker.cnf
MQTT_BROKER_KEY=$MQTT_BROKER_CERTIFICATE_FOLDER/mqtt_broker.pkcs8.key
MQTT_BROKER_CERT=$MQTT_BROKER_CERTIFICATE_FOLDER/mqtt_broker.crt

MQTT_CLIENT_CERTIFICATES_FOLDER=$TLS_BASE_FOLDER/clients