#!/bin/bash

SSO_NS=$1
USERS_LIST=$2

ADMIN_USER=$3
OCP_API=$4

oc login -u $ADMIN_USER $OCP_API

for line in `cat $USERS_LIST`
do
  IFS='#' read -r -a array <<< "$line"
  echo "Bootstraping user => ${array[0]}  ${array[1]}"
  cat rhsso/user.yaml |USER=${array[0]} USER_NS=${array[1]} envsubst | oc apply -f - -n $SSO_NS
done 