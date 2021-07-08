#!/bin/bash

SSO_NS=$1

ADMIN_USER=$2
OCP_API=$3

oc login -u $ADMIN_USER $OCP_API

oc new-project $SSO_NS
oc apply -f rhsso/keycloak.yaml -n $SSO_NS
oc apply -f rhsso/keycloak-realm.yaml -n $SSO_NS
oc apply -f rhsso/keycloak-client.yaml -n $SSO_NS

# oc expose service keycloak --name=keycloak-http -n sso

