#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`
HOME_DIR=$SCRIPT_DIR/..
. $HOME_DIR/config.sh

WATERSTREAM_LB_HOSTNAME=`aws cloudformation describe-stacks --region $AWS_REGION --stack-name ${WATERSTREAM_STACK_NAME} | jq -r '.Stacks[0].Outputs[] | select(.ExportName=="'${WATERSTREAM_STACK_NAME}':WaterstreamLbHostname").OutputValue'`

mosquitto_pub -h $WATERSTREAM_LB_HOSTNAME -p 1883 -t "sample_topic" -i mosquitto_p2 -q 0 -m "Hello, world!" \
          --cafile /home/ec2-user/tls/root/waterstream_adhoc_ca.pem
