#!/bin/bash

if [[ -z "$DO_SPACES_ACCESS_KEY" || -z "$DO_SPACES_SECRET_KEY" ]]; then
  echo "DO_SPACES_ACCESS_KEY or DO_SPACES_SECRET_KEY environment variables are not set."
  read -p "Enter DO_SPACES_ACCESS_KEY: " DO_SPACES_ACCESS_KEY
  read -p "Enter DO_SPACES_SECRET_KEY: " DO_SPACES_SECRET_KEY
  if [[ -z "$DO_SPACES_ACCESS_KEY" || -z "$DO_SPACES_SECRET_KEY" ]]; then
    echo "Both DO_SPACES_ACCESS_KEY and DO_SPACES_SECRET_KEY must be provided."
    exit 1
  fi
fi

if [[ "$1" == "--reconfigure" ]]; then
  terraform -chdir=root init --reconfigure --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"
elif [[ "$1" == "--migrate-state" ]]; then
  terraform -chdir=root init --migrate-state --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"
else
  terraform -chdir=root init --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"
fi

terraform -chdir=root apply -var-file="prod.tfvars"