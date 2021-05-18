#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

. $SCRIPT_DIR/commons.sh

mosquitto_pub -h $WATERSTREAM_LB_HOSTNAME -p 1883 -t "sample_topic" -i mosquitto_l_p2 -q 0 -m "Hello, world!"
