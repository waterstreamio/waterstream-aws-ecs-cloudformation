#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

cd $SCRIPT_DIR
if [ ! -f "config.sh" ]; then
  cp config.sh.example config.sh
fi

. ./config.sh

MSK_ARN=`aws --profile waterstream-demo cloudformation describe-stacks --stack-name ${STACK_PREFIX}-kafka | jq -r '.Stacks[0].Outputs[] | select(.ExportName=="MSKForWaterstreamId").OutputValue'`
KAFKA_BOOTSTRAP_SERVERS=`aws --profile ${AWS_PROFILE} kafka get-bootstrap-brokers --cluster-arn $MSK_ARN | jq -r '.BootstrapBrokerString'`

echo Kafka cluster $MSK_ARN bootstrap servers: $KAFKA_BOOTSTRAP_SERVERS

aws --profile ${AWS_PROFILE} cloudformation create-stack \
  --capabilities CAPABILITY_NAMED_IAM \
  --stack-name ${STACK_PREFIX}-waterstream \
  --template-body file://$SCRIPT_DIR/templates/waterstream_template.yml \
  --parameters ParameterKey=WaterstreamTestboxKeypair,ParameterValue=${TESTBOX_KEYPAIR_NAME} \
               ParameterKey=KafkaBootstrapServers,ParameterValue=\"${KAFKA_BOOTSTRAP_SERVERS}\" \
               ParameterKey=DockerhubCredentials,ParameterValue=\"${DOCKERHUB_CREDENTIALS_ARN}\" \
               ParameterKey=WaterstreamImageName,ParameterValue="870438658538.dkr.ecr.eu-central-1.amazonaws.com/waterstream-kafka" \
               ParameterKey=WaterstreamEnableSsl,ParameterValue=${WATERSTREAM_ENABLE_SSL} \
               ParameterKey=WaterstreamRequireAuthentication,ParameterValue=${WATERSTREAM_REQUIRE_AUTHENTICATION}

date