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
while [ "$STATUS" != "CREATE_COMPLETE" ]
do
  STATUS=`aws --profile $AWS_PROFILE cloudformation describe-stacks \
              --stack-name $STACK_NAME | jq -r '.Stacks[0].StackStatus' `
  if [ "$STATUS" = "CREATE_COMPLETE" ]; then
    echo "Stack $STACK_NAME status: $STATUS - done"
    exit 0
  elif [ "$STATUS" = "CREATE_IN_PROGRESS" ]; then
    echo "Stack $STACK_NAME status: $STATUS - still waiting"
    sleep 10
  else
    echo "Stack $STACK_NAME status: $STATUS - unexpected, exiting with error"
    exit 1
  fi
done


