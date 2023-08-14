#!/bin/bash
export BOOTSTRAP_PATH=$(realpath "$0")
export WORKING_DIRECTORY=$(dirname $BOOTSTRAP_PATH)

# bootstrap backend
# export DO_SPACES_ACCESS_KEY=""
# export DO_SPACES_SECRET_KEY=""
# export DIGITALOCEAN_TOKEN=""
# terraform init --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"
# for wildcard dns record
# export TF_VAR_do_token=""
# in git ignore locally sourced configuration kubeconfig

cd $WORKING_DIRECTORY/.sensitive

if [ -f "ca.crt" ]; then
  echo "ca.crt exists. Skipping step certificate create." 
else
  step certificate create root.linkerd.cluster.local ca.crt ca.key \
  --profile root-ca --no-password --insecure

  step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
  --profile intermediate-ca --not-after 8760h --no-password --insecure \
  --ca ca.crt --ca-key ca.key
fi

# github App integration
# https://github.com/cli/oauth/issues/1#issuecomment-754713746
# it is a-okay to hard code and expose these things
export TF_VAR_oauth_client_id="Iv1.c3e22ab5c0ec2971"
export TF_VAR_oauth_client_secret="f5d0be52b8e8cbb95b230977355f5b7de578faab"

# github app for argocd hooks/oauth
# .sensitive/githubAppPrivateKey
if [ -f "private_key.pem" ]; then
  echo "private_key.pem exists. Skipping openssl genpkey."
else
  openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
  openssl rsa -pubout -in private_key.pem -out public_key.pem
fi

# keycloak vars
export TF_VAR_keycloak_user="keycloak"
#export TF_VAR_keycloak_password=""
export TF_VAR_users_realm="fugue-state"
export TF_VAR_users_realm_public_key="$(openssl enc -A -base64 -in public_key.pem)"
export TF_VAR_users_realm_private_key="$(openssl enc -A -base64 -in private_key.pem)"
export TF_VAR_users_realm_baseurl="keycloak.fugue-state.io"
export TF_VAR_users_realm_username="keycloak"
#export TF_VAR_users_realm_user_password=""

export KUBECONFIG="$WORKING_DIRECTORY/.sensitive/kubeconfig"
cd $WORKING_DIRECTORY
terraform -chdir=root apply -auto-approve