#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

$SCRIPT_DIR/destroy_waterstream.sh
$SCRIPT_DIR/destroy_kafka.sh
$SCRIPT_DIR/waitStackDeletion.sh waterstream-waterstream
$SCRIPT_DIR/waitStackDeletion.sh waterstream-kafka
$SCRIPT_DIR/destroy_commons.sh
$SCRIPT_DIR/waitStackDeletion.sh waterstream-commons
