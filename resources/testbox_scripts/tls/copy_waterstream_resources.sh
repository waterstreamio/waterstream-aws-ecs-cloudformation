#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

. $SCRIPT_DIR/tls_config.sh

RESOURCES_TLS_DIR=/var/waterstream_resources/tls


#echo var dir:
#ls /var
#echo Resources dir:
#ls /var/waterstream_resources

cp $ROOT_CA_CERT $RESOURCES_TLS_DIR/root
cp $ROOT_CA_KEY $RESOURCES_TLS_DIR/root

cp $ROOT_CA_CERT $RESOURCES_TLS_DIR/mqtt_broker
cp $MQTT_BROKER_KEY $RESOURCES_TLS_DIR/mqtt_broker
cp $MQTT_BROKER_CERT $RESOURCES_TLS_DIR/mqtt_broker
