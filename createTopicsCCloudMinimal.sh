#!/bin/sh

set -e

CLUSTER_ID=${1}

if [ -z "$CLUSTER_ID" ]
then
  echo Confluent Cloud Cluster ID not specified
  exit 1
fi

CREATE_TOPIC="confluent kafka topic create"

DEFAULT_MESSAGES_TOPIC=mqtt_messages
SESSION_TOPIC=mqtt_sessions
RETAINED_MESSAGES_TOPIC=mqtt_retained_messages
CONNECTION_TOPIC=mqtt_connections
HEARTBEAT_TOPIC=__waterstream_heartbeat

DAY_MS=86400000
WEEKS_MS=604800000
TWO_WEEKS_MS=1209600000
THREE_WEEKS_MS=1814400000

#Fits into free partitions count
DEFAULT_MESSAGES_TOPIC_PARTITIONS=3
#Better performance
#DEFAULT_MESSAGES_TOPIC_PARTITIONS=10
#DEFAULT_MESSAGES_TOPIC_PARTITIONS=25
#DEFAULT_MESSAGES_TOPIC_PARTITIONS=50

SESSION_TOPIC_PARTITIONS=2
#SESSION_TOPIC_PARTITIONS=5
#SESSION_TOPIC_PARTITIONS=20

$CREATE_TOPIC $DEFAULT_MESSAGES_TOPIC --cluster ${CLUSTER_ID}  --partitions ${DEFAULT_MESSAGES_TOPIC_PARTITIONS} --config cleanup.policy=delete --config retention.ms=$WEEKS_MS || true
$CREATE_TOPIC $SESSION_TOPIC --cluster ${CLUSTER_ID} --partitions ${SESSION_TOPIC_PARTITIONS} --config cleanup.policy=compact --config min.compaction.lag.ms=60000 --config delete.retention.ms=600000 || true
$CREATE_TOPIC $RETAINED_MESSAGES_TOPIC --cluster ${CLUSTER_ID} --partitions 1  --config cleanup.policy=compact --config min.compaction.lag.ms=60000 --config delete.retention.ms=600000 || true
$CREATE_TOPIC $CONNECTION_TOPIC --cluster ${CLUSTER_ID} --partitions 1 --config cleanup.policy=delete --config retention.ms=60000 || true
$CREATE_TOPIC $HEARTBEAT_TOPIC --cluster ${CLUSTER_ID} --partitions 1 --config cleanup.policy=delete --config retention.ms=60000 || true

confluent kafka topic list --cluster ${CLUSTER_ID}
