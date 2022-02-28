#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`
HOME_DIR=$SCRIPT_DIR/..
. $HOME_DIR/config.sh

WATERSTREAM_LB_HOSTNAME=`aws cloudformation describe-stacks --region $AWS_REGION --stack-name ${WATERSTREAM_STACK_NAME} | jq -r '.Stacks[0].Outputs[] | select(.ExportName=="'${WATERSTREAM_STACK_NAME}':WaterstreamLbHostname").OutputValue'`

mosquitto_sub -h $WATERSTREAM_LB_HOSTNAME -p 1883 -t "#" -i mosquitto_p1 -q 0 -v \
          --cafile /home/ec2-user/tls/root/waterstream_adhoc_ca.pem \
          --cert /home/ec2-user/tls/clients/client_client1.crt --key /home/ec2-user/tls/clients/client_client1.pkcs8.key