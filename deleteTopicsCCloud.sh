#!/bin/sh

set -e

CLUSTER_ID=${1}

if [ -z "$CLUSTER_ID" ]
then
  echo Confluent Cloud Cluster ID not specified
  exit 1
fi

DELETE_TOPIC="confluent kafka topic delete"

DEFAULT_MESSAGES_TOPIC=mqtt_messages
SESSION_TOPIC=mqtt_sessions
RETAINED_MESSAGES_TOPIC=mqtt_retained_messages
CONNECTION_TOPIC=mqtt_connections
HEARTBEAT_TOPIC=__waterstream_heartbeat

$DELETE_TOPIC $DEFAULT_MESSAGES_TOPIC --cluster ${CLUSTER_ID} || true
$DELETE_TOPIC $SESSION_TOPIC --cluster ${CLUSTER_ID} || true
$DELETE_TOPIC $RETAINED_MESSAGES_TOPIC --cluster ${CLUSTER_ID} || true
$DELETE_TOPIC $CONNECTION_TOPIC --cluster ${CLUSTER_ID} || true
$DELETE_TOPIC $HEARTBEAT_TOPIC --cluster ${CLUSTER_ID} || true
$DELETE_TOPIC waterstream-kafka-table-${SESSION_TOPIC}-changelog --cluster ${CLUSTER_ID} || true


confluent kafka topic list --cluster ${CLUSTER_ID}
