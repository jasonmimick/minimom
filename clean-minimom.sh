#!/bin/bash

kubectl delete -f https://raw.githubusercontent.com/jasonmimick/minimom/master/minimom.yaml 

kubectl delete -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml
kubectl delete -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml
kubectl delete ns mongodb


