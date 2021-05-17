#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

cd $SCRIPT_DIR
if [ ! -f "config.sh" ]; then
  cp config.sh.example config.sh
fi

. ./config.sh

aws --profile ${AWS_PROFILE} cloudformation describe-stacks \
--stack-name ${STACK_PREFIX}-waterstream | jq -r '.Stacks[0].Outputs'
