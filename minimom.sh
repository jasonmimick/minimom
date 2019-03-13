#!/bin/bash

NSF="-n mongodb"

echo "Welcome to minimom! 🤩" 
kubectl create ${NFS} ns mongodb

kubectl create ${NFS} -f https://raw.githubusercontent.com/jasonmimick/minimom/master/minimom.yaml 

kubectl create ${NSF} -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml
kubectl create ${NFS} -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml

# wait till pod started and ready
echo "Waiting for minimom to be ready..."
while not grep "minimom> READY" <<< $(kubectl ${NFS} logs minimom-0) > /dev/null:
do
  sleep 1
  echo "."
done
echo "minimom is almost ready!"

#fetch configmap and secret yaml already built
echo "Installing ConfigMap and Secret for operator-to-ops-manager connection..."
kubectl ${NFS} exec minimom-0 -- cat /etc/mongodb/mms/env/minimom.yaml | kubectl create -f -
echo "Complete."

kubectl get ${NFS} cm,secrets
kubectl get ${NFS} all

echo "minimom is ready! start building cloud data services today!"
