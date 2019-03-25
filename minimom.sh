#!/bin/bash

set -x
function __is_pod_ready() {
  [[ "$(kubectl get po "$1" -o 'jsonpath={.status.conditions[?(@.type=="Ready")].status}')" == 'True' ]]
}

NS="mongodb"

echo "Welcome to minimom! 🤩" 
kubectl -n "${NS}" create ns mongodb

kubectl -n "${NS}" create -f minimom.yaml 
#kubectl -n "${NS}" create -f https://raw.githubusercontent.com/jasonmimick/minimom/master/minimom.yaml 

kubectl -n "${NS}" create -f ./.crds.yaml
kubectl -n "${NS}" create -f ./.mongodb-enterprise.yaml 
#kubectl -n "${NS}" create -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml
#kubectl -n "${NS}" create -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml

echo "Checking pod/minimom-0 Ready."
kubectl -n "${NS}" wait --for=condition=Ready --timeout=-1s pod/minimom-0 
echo "Pod ready."

tlog=$(mktemp)
kubectl -n "${NS}" logs minimom-0 > ${tlog}
logdata=$(grep 'minimom> READY' ${tlog})
echo "logdata=${logdata}"
while [ -z ${logdata}];
do
  sleep 1
  echo "."
  kubectl -n "${NS}" logs minimom-0 > ${tlog}
  logdata=$(grep "minimom> READY" ${tlog})
  echo "logdata=${logdata}"
done
echo "minimom is almost ready!"

#fetch configmap and secret yaml already built
echo "Installing ConfigMap and Secret for operator-to-ops-manager connection..."
kubectl -n "${NS}" exec minimom-0 -- cat /etc/mongodb/mms/env/minimom.yaml | kubectl create -f -
echo "Complete."

kubectl -n "${NS}" get cm,secrets
kubectl -n "${NS}" get all

echo "minimom is ready! start building cloud data services today!"
