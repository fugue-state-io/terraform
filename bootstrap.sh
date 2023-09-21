#!/bin/bash
export BOOTSTRAP_PATH=$(realpath "$0")
export WORKING_DIRECTORY=$(dirname $BOOTSTRAP_PATH)

# bootstrap backend

# for wildcard dns record
# export TF_VAR_do_token=""
# in git ignore locally sourced configuration kubeconfig
mkdir $WORKING_DIRECTORY/.sensitive
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

# github app for argocd hooks/oauth
# .sensitive/githubAppPrivateKey
if [ -f "private_key.pem" ]; then
  echo "private_key.pem exists. Skipping openssl genpkey."
else
  openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
  openssl rsa -pubout -in private_key.pem -out public_key.pem
fi