#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`
. $SCRIPT_DIR/../config.sh

if [ -z "$AWS_REGION" ]
then
  REGION_CLAUSE=""
else
  REGION_CLAUSE="--region $AWS_REGION"
fi

export REGION_CLAUSE

WATERSTREAM_STACK_NAME=${STACK_PREFIX}-waterstream
WATERSTREAM_LB_HOSTNAME=`aws cloudformation describe-stacks --profile $AWS_PROFILE $REGION_CLAUSE --stack-name ${WATERSTREAM_STACK_NAME} | jq -r '.Stacks[0].Outputs[] | select(.ExportName=="WaterstreamLbHostname").OutputValue'`
