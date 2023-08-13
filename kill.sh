#!/bin/bash
export BOOTSTRAP_PATH=$(realpath "$0")
export WORKING_DIRECTORY=$(dirname $BOOTSTRAP_PATH)
# terraform delete is not smart this is better
echo 'terraform -chdir=root state list | grep helm_release | xargs terraform -chdir=root state rm'
terraform -chdir=root state list | grep helm_release | xargs terraform -chdir=root state rm

echo 'terraform -chdir=root state list | grep kubernetes_namespace | xargs terraform -chdir=root state rm'
terraform -chdir=root state list | grep kubernetes_namespace | xargs terraform -chdir=root state rm

echo "doctl compute load-balancer list -o json | jq '.[] | select(.name=="fugue-state-cluster-nginx-ingress") | .id' --raw-output | xargs doctl compute load-balancer delete -f"
doctl compute load-balancer list -o json | jq '.[] | select(.name=="fugue-state-cluster-nginx-ingress") | .id' --raw-output | xargs doctl compute load-balancer delete -f

echo 'terraform -chdir=root destroy -auto-approve'
terraform -chdir=root destroy -auto-approve

