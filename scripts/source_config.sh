#!/bin/bash
doctl kubernetes cluster kubeconfig save fugue-state-cluster
kubectl get secret -n tf-backup tf-secrets -o json | jq -r '.data | map_values(@base64d)'

for key in $(kubectl get secret -n tf-backup tf-secrets -o json | jq -r '.data | keys[]'); do
  value=$(kubectl get secret -n tf-backup tf-secrets -o json | jq -r ".data[\"$key\"]" | base64 --decode)
  export "$key"="$value"
done
