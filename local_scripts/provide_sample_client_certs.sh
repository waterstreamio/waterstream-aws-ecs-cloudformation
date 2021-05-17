#!/bin/sh

set -e
SCRIPT_DIR=`realpath $(dirname "$0")`

$SCRIPT_DIR/download_ca_cert.sh
$SCRIPT_DIR/generate_client_csr.sh cl1
$SCRIPT_DIR/sign_client_cert.sh cl1
$SCRIPT_DIR/generate_client_csr.sh cl2
$SCRIPT_DIR/sign_client_cert.sh cl2
