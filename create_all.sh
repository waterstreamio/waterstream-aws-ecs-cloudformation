#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

echo Deploying commons..
$SCRIPT_DIR/create_commons.sh
$SCRIPT_DIR/waitStackCompletion.sh waterstream-commons

echo Deploying Kafka..
$SCRIPT_DIR/create_kafka.sh
$SCRIPT_DIR/waitStackCompletion.sh waterstream-kafka

echo Deploying Waterstream..
$SCRIPT_DIR/create_waterstream.sh
$SCRIPT_DIR/waitStackCompletion.sh waterstream-waterstream

echo Deploy complete
