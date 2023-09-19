#!/bin/bash
export BOOTSTRAP_PATH=$(realpath "$0")
export WORKING_DIRECTORY=$(dirname $BOOTSTRAP_PATH)

export KUBECONFIG="$WORKING_DIRECTORY/.sensitive/kubeconfig"
cd $WORKING_DIRECTORY
export TF_VAR_do_token=""
export TF_VAR_oauth_client_id=""
export TF_VAR_oauth_client_secret=""
export TF_VAR_=""
export TF_VAR_=""
export TF_VAR_=""
export TF_VAR_=""
export TF_VAR_=""
export TF_VAR_=""
export TF_VAR_=""
terraform -chdir=root 
