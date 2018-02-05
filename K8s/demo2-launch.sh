#!/bin/bash

cd ~/k8s/demo2
gcloud container clusters create demo2 --num-nodes=3
kubectl create -f frontend-deployment.yaml
kubectl get pods -l app=demo2
kubectl create -f frontend-service.yaml
echo "Waiting for public IP address...."
while kubectl get service frontend | grep pending > /dev/null
do
 sleep 10
# echo "Waiting for public IP address...."
done
echo "The external IP is: "
kubectl get service frontend | awk '{print $4}' | sed -n '2p'