#!/bin/bash
if [ -f "./.sensitive/ca.crt" ]; then
  echo "ca.crt exists. Skipping step certificate create." 
else
  step certificate create root.linkerd.cluster.local ./.sensitive/ca.crt ./.sensitive/ca.key \
  --profile root-ca --no-password --insecure

  step certificate create identity.linkerd.cluster.local ./.sensitive/issuer.crt ./.sensitive/issuer.key \
  --profile intermediate-ca --not-after 8760h --no-password --insecure \
  --ca ./.sensitive/ca.crt --ca-key ./.sensitive/ca.key
fi

# github app for argocd hooks/oauth
# ..sensitive/githubAppPrivateKey
if [ -f "./.sensitive/private_key.pem" ]; then
  echo "private_key.pem exists. Skipping openssl genpkey."
else
  openssl genpkey -algorithm RSA -out ./.sensitive/private_key.pem -pkeyopt rsa_keygen_bits:2048
  openssl rsa -pubout -in ./.sensitive/private_key.pem -out public_key.pem
fi