#!/bin/bash
doctl kubernetes cluster kubeconfig save fugue-state-cluster
export DO_SPACES_ACCESS_KEY="$(kubectl get secret -n argo-workflows argo-workflows-spaces -o json | jq -r '.data | map_values(@base64d) | ."spaces_access_id"')"
export DO_SPACES_SECRET_KEY="$(kubectl get secret -n argo-workflows argo-workflows-spaces -o json | jq -r '.data | map_values(@base64d) | ."spaces_secret_key"')"
export TF_VAR_do_token="$DIGITALOCEAN_TOKEN"
export TF_VAR_do_spaces_access_id="$DO_SPACES_ACCESS_KEY"
export TF_VAR_do_spaces_secret_key="$DO_SPACES_SECRET_KEY"

kubectl get secret -n ci github-auth -o json | jq -r '.data | map_values(@base64d) | ."github-app.pem"' | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' > .sensitive/github_app.pem
export TF_VAR_oauth_client_id="$(kubectl get secret -n argocd fugue-state-argocd-secret -o json | jq -r '.data | map_values(@base64d) | ."dexId"')"
export TF_VAR_oauth_client_secret="$(kubectl get secret -n argocd fugue-state-argocd-secret -o json | jq -r '.data | map_values(@base64d) | ."dexSecret"')"

export TF_VAR_github_app_client_id="$(kubectl get secret -n ci github-auth -o json | jq -r '.data | map_values(@base64d) | ."github-app-client-id"')"
export TF_VAR_github_app_client_secret="$(kubectl get secret -n ci github-auth -o json | jq -r '.data | map_values(@base64d) | ."github-app-client-secret"')"

export TF_VAR_github_app_id="$(kubectl get secret -n argocd fugue-state-repo -o json | jq -r '.data | map_values(@base64d) | ."githubAppID"')"
export TF_VAR_github_app_installation_id="$(kubectl get secret -n argocd fugue-state-repo -o json | jq -r '.data | map_values(@base64d) | ."githubAppInstallationID"')"
export TF_VAR_github_repo_url="$(kubectl get secret -n argocd fugue-state-repo -o json | jq -r '.data | map_values(@base64d) | ."url"')"

export TF_VAR_argocd_webhook_secret="$(kubectl get secret -n argo-workflows argo-workflows-sso -o json | jq -r '.data | map_values(@base64d) | ."client-id"')"
export TF_VAR_argo_workflows_client_id="$(kubectl get secret -n argo-workflows argo-workflows-sso -o json | jq -r '.data | map_values(@base64d) | ."client-id"')"
export TF_VAR_argo_workflows_client_secret="$(kubectl get secret -n argo-workflows argo-workflows-sso -o json | jq -r '.data | map_values(@base64d) | ."client-secret"')"

export TF_VAR_github_webhook_secret="$(kubectl get secret -n ci ci-secrets -o json | jq -r '.data | map_values(@base64d) | ."github-webhook-secret"')"

# export TF_VAR_do_cdn_spaces_access_id="$(kubectl get secret -n api api-secrets -o json | jq -r '.data | map_values(@base64d) | ."FUGUE_STATE_CDN_ACCESS_ID"')"
# export TF_VAR_do_cdn_spaces_secret_key="$(kubectl get secret -n api api-secrets -o json | jq -r '.data | map_values(@base64d) | ."FUGUE_STATE_CDN_SECRET_KEY"')"

export TF_VAR_keycloak_password="$(kubectl get secret -n keycloak keycloak-secrets -o json | jq -r '.data | map_values(@base64d) | ."KEYCLOAK_ADMIN_PASSWORD"')"

export TF_VAR_do_cdn_spaces_access_id="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_do_cdn_spaces_access_id"')"
export TF_VAR_do_cdn_spaces_secret_key="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_do_cdn_spaces_secret_key"')"
export TF_VAR_nextauth_url="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_nextauth_url"')"
export TF_VAR_nextauth_secret="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_nextauth_secret"')"
export TF_VAR_nextauth_url="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_nextauth_url"')"
export TF_VAR_keycloak_secret="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_keycloak_secret"')"
export TF_VAR_keycloak_issuer="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_keycloak_issuer"')"
export TF_VAR_keycloak_id="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_keycloak_id"')"
export TF_VAR_fugue_state_bucket="$(kubectl get secret -n ui fugue-state-ui-secrets -o json | jq -r '.data | map_values(@base64d) | ."TF_VAR_fugue_state_bucket"')"