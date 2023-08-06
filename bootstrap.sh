#!/bin/bash
# requires DNS records point to digital ocean DNS

# in git ignore locally sourced configuration kubeconfig
cd ./sensitive

# linkerd mtls certs managed by cert-manager
step certificate create root.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure

step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
--profile intermediate-ca --not-after 8760h --no-password --insecure \
--ca ca.crt --ca-key ca.key

# github App integration
#export TF_VAR_oauth_client_id=""
#export TF_VAR_oauth_secret_id=""

# github app for argocd hooks/oauth
# .sensitive/githubAppPrivateKey

# keycloak vars
# export TF_VAR_users_realm=""
# export TF_VAR_users_realm_public_key=""
# export TF_VAR_users_realm_private_key=""
# export TF_VAR_users_realm_baseurl=""
# export TF_VAR_users_realm_username=""
# export TF_VAR_users_realm_user_password=""

#gpg --armor --export-secret-keys 566BCF1837B27033 key.asc > key.asc
#age-keygen -o key.txt

# bootstrap backend
#export DO_SPACES_ACCESS_KEY=""
#export DO_SPACES_SECRET_KEY=""
#export DIGITALOCEAN_TOKEN=""
#terraform init --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"
# for wildcard dns record
#export TF_VAR_do_token=""