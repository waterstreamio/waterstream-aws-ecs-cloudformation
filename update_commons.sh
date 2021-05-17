#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

cd $SCRIPT_DIR
if [ ! -f "config.sh" ]; then
  cp config.sh.example config.sh
fi

. ./config.sh

aws --profile ${AWS_PROFILE} cloudformation update-stack \
--capabilities CAPABILITY_NAMED_IAM \
--stack-name ${STACK_PREFIX}-commons \
--template-body file://$SCRIPT_DIR/templates/commons_template.yml