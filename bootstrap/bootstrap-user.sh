#!/bin/bash

MESH_NS=$1
USER=$2
USER_NS=$3

echo "Bootstraping user $USER (Istio ns=$MESH_NS)"

echo "Creating namespaces..."
cat ./ocp/namespaces.yaml | USER_NS=$USER_NS envsubst | oc apply -f -

echo "Creating terminal..."
cat ./ocp/terminal/dev-workspace.yaml | USER_NS=$USER_NS envsubst | oc apply -f -

echo "Creating exports"
cat ./ocp/terminal/configmap.yaml | USER_NS=$USER_NS USER=$USER \
 PASSWORD=$USER_NS envsubst | oc apply -f -
cat ./ocp/terminal/oauth-configmap.yaml | USER_NS=$USER_NS envsubst | oc apply -f -


echo "Adding view role to ns=$MESH_NS"
cat ./ocp/rb/mesh-ns-rb.yaml | USER=$USER MESH_NS=$MESH_NS USER_NS=$USER_NS envsubst | oc apply -f -

echo "Adding mesh-user role to ns=$MESH_NS"
cat ./ocp/rb/mesh-user-rb.yaml | USER=$USER USER_NS=$USER_NS  envsubst | oc apply -f - -n $MESH_NS

echo "Adding labs-istio role"
cat ./ocp/rb/labs-istio-rb.yaml | USER=$USER USER_NS=$USER_NS envsubst | oc apply -f - -n $MESH_NS


echo "Adding admin role to its ns"
cat ./ocp/rb/user-admin.yaml | USER=$USER USER_NS=${USER_NS}-1 envsubst | oc apply -f -
cat ./ocp/rb/user-admin.yaml | USER=$USER USER_NS=${USER_NS}-2 envsubst | oc apply -f -
cat ./ocp/rb/user-admin.yaml | USER=$USER USER_NS=${USER_NS}-terminal envsubst | oc apply -f -

echo "Joining mesh $MESH_NS with ns ${USER_NS}-1"
cat ./smcp/smm.yaml | USER_NS=${USER_NS}-1  MESH_NS=$MESH_NS envsubst | oc apply -f -
echo "Joining mesh $MESH_NS with ns ${USER_NS}-2"
cat ./smcp/smm.yaml | USER_NS=${USER_NS}-2  MESH_NS=$MESH_NS envsubst | oc apply -f -

