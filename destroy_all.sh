#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

cd $SCRIPT_DIR
. ./config.sh

$SCRIPT_DIR/destroy_waterstream.sh
$SCRIPT_DIR/destroy_kafka.sh
$SCRIPT_DIR/waitStackDeletion.sh ${STACK_PREFIX}-waterstream
$SCRIPT_DIR/waitStackDeletion.sh ${STACK_PREFIX}-kafka
$SCRIPT_DIR/destroy_commons.sh
$SCRIPT_DIR/waitStackDeletion.sh ${STACK_PREFIX}-commons
