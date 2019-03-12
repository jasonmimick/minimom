#!/bin/bash

kubectl create ns mongodb

kubectl create -f https://raw.githubusercontent.com/jasonmimick/minimom/master/minimom.yaml 

kubectl create -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml
kubectl create -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml

kubectl exec -it minimom cat /etc/mongodb/mms/env/minimom.yaml

