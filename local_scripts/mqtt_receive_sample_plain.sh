#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`
. $SCRIPT_DIR/../config.sh

WATERSTREAM_STACK_NAME=${STACK_PREFIX}-waterstream
WATERSTREAM_LB_HOSTNAME=`aws cloudformation describe-stacks --profile $AWS_PROFILE --stack-name ${WATERSTREAM_STACK_NAME} | jq -r '.Stacks[0].Outputs[] | select(.ExportName=="WaterstreamLbHostname").OutputValue'`

cd $SCRIPT_DIR

mosquitto_sub -h $WATERSTREAM_LB_HOSTNAME -p 1883 -t "#" -i mosquitto_l_p1 -q 0 -v
