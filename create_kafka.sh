#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

cd $SCRIPT_DIR
if [ ! -f "config.sh" ]; then
  cp config.sh.example config.sh
fi

. ./config.sh

aws --profile ${AWS_PROFILE} cloudformation create-stack \
  --capabilities CAPABILITY_NAMED_IAM \
  --stack-name ${STACK_PREFIX}-kafka \
  --template-body file://$SCRIPT_DIR/templates/kafka_template.yml \
  --parameters ParameterKey=KafkaInstance,ParameterValue=${KAFKA_INSTANCE} \
               ParameterKey=KafkaNodes,ParameterValue=${KAFKA_NODES}

date