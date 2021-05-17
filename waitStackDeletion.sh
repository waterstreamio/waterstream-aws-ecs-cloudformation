#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`
cd $SCRIPT_DIR

. ./config.sh

STACK_NAME=$1

if [ -z "$STACK_NAME" ]
then
  echo Stack name not specified
  exit 1
fi

STATUS=""
while [ "$STATUS" != "DELETE_COMPLETE" ]
do
  STATUS=`aws --profile $AWS_PROFILE cloudformation describe-stacks \
              --stack-name $STACK_NAME | jq -r '.Stacks[0].StackStatus' `
  if [ "$STATUS" = "DELETE_COMPLETE" ]; then
    echo "Stack $STACK_NAME status: $STATUS - deletion done"
    exit 0
  elif [ "$STATUS" = "DELETE_IN_PROGRESS" ]; then
    echo "Stack $STACK_NAME status: $STATUS - still waiting for deletion"
    sleep 10
  elif [ "$STATUS" = "" ]; then
    echo "Stack $STACK_NAME empty status - assuming the stack is gone"
    exit 0
  else
    echo "Stack $STACK_NAME status: $STATUS - unexpected status for deletion, exiting with error"
    exit 1
  fi
done

