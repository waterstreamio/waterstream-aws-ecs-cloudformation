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


if [ "$WATERSTREAM_BYOL_ENABLED" = true ]; then
  echo BYOL enable, AWS Marketplace billing won\'t be used
  WATERSTREAM_LICENSE_DATA=`sed -e '/^$/,$d' < waterstream.license`
  if [ -z "$WATERSTREAM_LICENSE_DATA"]; then
    echo Could not load license data from file, BYOL requested but can\'t be enabled
    exit 1
  fi
else
  echo BYOL disabled, relying on AWS Marketplace billing
  WATERSTREAM_LICENSE_DATA=""
fi

#jq -Rs '[{"ParameterKey": "WaterstreamByolLicense", "ParameterValue": .}]' < waterstream.license > additional_params.json
#  --parameters file://$SCRIPT_DIR/additional_params.json

TESTBOX_INGRESS_CIDR="0.0.0.0/0"

aws --profile ${AWS_PROFILE} cloudformation create-stack \
  --capabilities CAPABILITY_NAMED_IAM \
  --stack-name ${STACK_PREFIX}-waterstream \
  --template-body file://$SCRIPT_DIR/templates/waterstream_template.yml \
  --parameters ParameterKey=WaterstreamTestboxKeypair,ParameterValue=${TESTBOX_KEYPAIR_NAME} \
               ParameterKey=TestboxIngressCidr,ParameterValue=${TESTBOX_INGRESS_CIDR} \
               ParameterKey=KafkaBootstrapServers,ParameterValue=\"${KAFKA_BOOTSTRAP_SERVERS}\" \
               ParameterKey=DockerhubCredentials,ParameterValue=\"${DOCKERHUB_CREDENTIALS_ARN}\" \
               ParameterKey=WaterstreamImageName,ParameterValue=$WATERSTREAM_IMAGE_NAME \
               ParameterKey=WaterstreamImageVersion,ParameterValue=$WATERSTREAM_IMAGE_VERSION \
               ParameterKey=WaterstreamEnableSsl,ParameterValue=${WATERSTREAM_ENABLE_SSL} \
               ParameterKey=WaterstreamByolLicense,ParameterValue="${WATERSTREAM_LICENSE_DATA}" \
               ParameterKey=WaterstreamRequireAuthentication,ParameterValue=${WATERSTREAM_REQUIRE_AUTHENTICATION} \
               ParameterKey=WaterstreamMqttTopicToKafkaKeyMapping,ParameterValue="${WATERSTREAM_MQTT_TOPIC_TO_KAFKA_MESSAGE_KEY}"

date