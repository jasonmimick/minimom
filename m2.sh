#!/bin/bash


function __is_pod_ready() {
  [[ "$(kubectl get po "$1" -o 'jsonpath={.status.conditions[?(@.type=="Ready")].status}')" == 'True' ]]
}

NSF="-n mongodb"

echo "Welcome to minimom! 🤩" 

echo "Checking pod/minimom-0 Ready."
kubectl wait --for=condition=Ready pod/minimom-0 --timeout=-1s
echo "Pod ready."

tlog=$(mktemp)
kubectl ${NFS} logs minimom-0 > ${tlog}
logdata=$(grep 'minimom> READY' ${tlog})
echo "logdata=${logdata}"
while [ -z ${logdata}];
do
  sleep 1
  echo "."
  kubectl ${NFS} logs minimom-0 > ${tlog}
  logdata=$(grep "minimom> READY" ${tlog})
  echo "logdata=${logdata}"
done
echo "minimom is almost ready!"

#fetch configmap and secret yaml already built
echo "Installing ConfigMap and Secret for operator-to-ops-manager connection..."
kubectl ${NFS} exec minimom-0 -- cat /etc/mongodb/mms/env/minimom.yaml | kubectl create -f -
echo "Complete."

kubectl get ${NFS} cm,secrets
kubectl get ${NFS} all

echo "minimom is ready! start building cloud data services today!"
