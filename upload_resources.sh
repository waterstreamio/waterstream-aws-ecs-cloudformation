#!/bin/sh
set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

cd $SCRIPT_DIR
if [ ! -f "config.sh" ]; then
  cp config.sh.example config.sh
fi

. ./config.sh

aws --profile ${AWS_PUBLISH_PROFILE} s3 sync --acl public-read $SCRIPT_DIR/resources ${RESOURCES_S3}/resources
aws --profile ${AWS_PUBLISH_PROFILE} s3 sync --acl public-read $SCRIPT_DIR/templates ${RESOURCES_S3}/templates
