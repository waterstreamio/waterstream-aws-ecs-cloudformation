#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

. $SCRIPT_DIR/commons.sh

cd $SCRIPT_DIR

mosquitto_sub -h $WATERSTREAM_LB_HOSTNAME -p 1883 -t "#" -i mosquitto_l_ta1 -q 0 -v \
      --cafile tls/waterstream_adhoc_ca.pem
