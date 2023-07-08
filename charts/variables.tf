variable "cluster_name" {
  sensitive = true
}

variable "postgres" {
  sensitive = true
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

variable "c2_license_key" {
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