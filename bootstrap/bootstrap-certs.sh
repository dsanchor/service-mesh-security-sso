#!/bin/bash

MESH_NS=$1
# *.apps.labs.sandbox1409.opentlc.com
ALT_SUBJECT=$2


CERTS_HOME=/tmp
CN=*.appsopentlc
CERTS_PATH="$CERTS_HOME"/"$ALT_SUBJECT"

echo "Generating certs for $ALT_SUBJECT, cn=$CN under $CERTS_HOME"

./certs/generate-certs.sh $ALT_SUBJECT $CN $CERTS_HOME

echo "Creating secret for tls certs"

oc create -n istio-system secret tls apps-credential --key=$CERTS_PATH/cert.key --cert=$CERTS_PATH/cert.cert
