#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

cd $SCRIPT_DIR
if [ ! -f "config.sh" ]; then
  cp config.sh.example config.sh
fi

. ./config.sh

aws --profile ${AWS_PROFILE} cloudformation delete-stack \
--stack-name ${STACK_PREFIX}-kafka

date