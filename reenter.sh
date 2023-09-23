#!/bin/bash
export BOOTSTRAP_PATH=$(realpath "$0")
export WORKING_DIRECTORY=$(dirname $BOOTSTRAP_PATH)

export KUBECONFIG="$WORKING_DIRECTORY/.sensitive/kubeconfig"
cd $WORKING_DIRECTORY

export DO_SPACES_ACCESS_KEY="$(kubectl get secret -n argo-workflows argo-workflows-spaces -o json | jq -r '.data | map_values(@base64d) | ."spaces_access_id"')"
export DO_SPACES_SECRET_KEY="$(kubectl get secret -n argo-workflows argo-workflows-spaces -o json | jq -r '.data | map_values(@base64d) | ."spaces_secret_key"')"

export TF_VAR_do_token="$DIGITAL_OCEAN_TOKEN"
export TF_VAR_do_spaces_access_id="$DO_SPACES_ACCESS_KEY"
export TF_VAR_do_spaces_secret_key="$DO_SPACES_SECRET_KEY"
terraform init --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"

export TF_VAR_oauth_client_id="$(kubectl get secret -n argocd fugue-state-argocd-secret -o json | jq -r '.data | map_values(@base64d) | ."dexId"')"
export TF_VAR_oauth_client_secret="$(kubectl get secret -n argocd fugue-state-argocd-secret -o json | jq -r '.data | map_values(@base64d) | ."dexSecret"')"

export TF_VAR_argocd_webhook_secret="$(kubectl get secret -n argo-workflows argo-workflows-sso -o json | jq -r '.data | map_values(@base64d) | ."client-id"')"
export TF_VAR_argo_workflows_client_id="$(kubectl get secret -n argo-workflows argo-workflows-sso -o json | jq -r '.data | map_values(@base64d) | ."client-id"')"
export TF_VAR_argo_workflows_client_secret="$(kubectl get secret -n argo-workflows argo-workflows-sso -o json | jq -r '.data | map_values(@base64d) | ."client-secret"')"

export TF_VAR_github_webhook_secret="$(kubectl get secret -n ci ci-secrets -o json | jq -r '.data | map_values(@base64d) | ."github-webhook-secret"')"

terraform -chdir=root 
