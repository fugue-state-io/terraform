#!/bin/bash
terraform -chdir=root init --backend-config="access_key=$DO_SPACES_ACCESS_KEY" --backend-config="secret_key=$DO_SPACES_SECRET_KEY"
terraform -chdir=root apply