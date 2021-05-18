#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

. $SCRIPT_DIR/commons.sh

cd $SCRIPT_DIR

mosquitto_pub -h $WATERSTREAM_LB_HOSTNAME -p 1883 -t "sample_topic" -i mosquitto_l_ta2 -q 0 -m "Hello, world!" \
      --cafile tls/waterstream_adhoc_ca.pem
