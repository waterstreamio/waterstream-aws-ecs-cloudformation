#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`
. $SCRIPT_DIR/../config.sh

WATERSTREAM_STACK_NAME=${STACK_PREFIX}-waterstream
WATERSTREAM_TESTBOX=`aws cloudformation describe-stacks --profile $AWS_PROFILE --stack-name ${WATERSTREAM_STACK_NAME} | jq -r '.Stacks[0].Outputs[] | select(.ExportName=="WaterstreamTestboxHostname").OutputValue'`

cd $SCRIPT_DIR

scp -i $IDENTITY_FILE ec2-user@$WATERSTREAM_TESTBOX:/home/ec2-user/tls/root/waterstream_adhoc_ca.pem tls
