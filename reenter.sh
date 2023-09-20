#!/bin/bash
export BOOTSTRAP_PATH=$(realpath "$0")
export WORKING_DIRECTORY=$(dirname $BOOTSTRAP_PATH)

export KUBECONFIG="$WORKING_DIRECTORY/.sensitive/kubeconfig"
cd $WORKING_DIRECTORY

export DO_SPACES_ACCESS_KEY=""
export DO_SPACES_SECRET_KEY=""
export TF_VAR_do_spaces_access_id="$DO_SPACES_ACCESS_KEY"
export TF_VAR_do_spaces_secret_key="$DO_SPACES_SECRET_KEY"
export DIGITALOCEAN_TOKEN=""
export TF_VAR_do_token="$DIGITAL_OCEAN_TOKEN"
terraform init --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"

export TF_VAR_oauth_client_id=""
export TF_VAR_oauth_client_secret=""
export TF_VAR_argocd_webhook_secret=""
export TF_VAR_argo_workflows_client_id=""
export TF_VAR_argo_workflows_client_secret=""
export TF_VAR_github_webhook_secret=""
terraform -chdir=root 
#kubectl get secret -n argocd argo-workflows-sso -o json ö jq '.data ö map_values(Ébase64d)'
