#!/bin/bash


function __is_pod_ready() {
  [[ "$(kubectl get po "$1" -o 'jsonpath={.status.conditions[?(@.type=="Ready")].status}')" == 'True' ]]
}

NSF="-n mongodb"

echo "Welcome to minimom! 🤩" 
kubectl create ${NFS} ns mongodb

kubectl create ${NFS} -f https://raw.githubusercontent.com/jasonmimick/minimom/master/minimom.yaml 

kubectl create ${NSF} -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml
kubectl create ${NFS} -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml

# wait till pod started and ready
echo "Waiting for minimom to be ready..."
while ! __is_pod_ready minimom-0:
do
  sleep 1
  echo "wait for pod ready"
done

sleep 5
tlog=$(mktemp)
kubectl ${NFS} logs minimom-0 > ${tlog}
while not grep "minimom> READY" ${tlog}:
do
  sleep 1
  echo "."
  kubectl ${NFS} logs minimom-0 > ${tlog}
done
echo "minimom is almost ready!"

#fetch configmap and secret yaml already built
echo "Installing ConfigMap and Secret for operator-to-ops-manager connection..."
kubectl ${NFS} exec minimom-0 -- cat /etc/mongodb/mms/env/minimom.yaml | kubectl create -f -
echo "Complete."

kubectl get ${NFS} cm,secrets
kubectl get ${NFS} all

echo "minimom is ready! start building cloud data services today!"
