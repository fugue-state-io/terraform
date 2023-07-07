variable "cluster_name" {

}

variable "postgres" {
  
}

variable "keycloak-db" {
  sensitive = true
}

variable "keycloak-user" {
  sensitive = true
}

variable "helm_repo_token" {
  sensitive = true
}

variable "do_token" {
  sensitive = true
}

variable "oauth_client_id" {
  sensitive = true
}

variable "oauth_client_secret" {
  sensitive = true
}

variable "registry_creds" {
  sensitive = true
}