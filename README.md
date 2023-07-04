# fugue-state-io terraform repository
Declarative configuration as code repository for fugue-state-io

## Pre-requisites
A digital ocean account
- with a default-vpc
  - digital ocean won't let you delete the default vpc
- with an s3 bucket
  - so the terraform provider can manage state

An appropriately configured GitHub App and Organization
- Needs a Personal Access Token
  - Read Access to code and metadata
- Needs Organization groups permission
- Needs a private key for SSH app access
- Needs a client secret and client ID for oauth

## Managed Services
- A Digital Ocean Kubernetes Cluster
  - an nginx-ingress-controller
  - cert-manager with certs from lets-encrypt
  - linkerd service mesh with self signed step certs
  - argocd
- Updated DNS Records pointing to the nginx-ingress-controller

## Administrative Tasks
- rotate argo gh token
## CI
GitHub Actions will create a minikube cluster and test terraform apply in it.

## CD
If the local CI is successful apply changes.
