variable "cluster_name" {
  sensitive = true
}

variable "postgres" {
  sensitive = true
}

variable "keycloak-db" {
  sensitive = true
}

variable "keycloak-db-user" {
  sensitive = true
}

variable "keycloak_user" {
  sensitive = true
}

variable "keycloak_password" {
  sensitive = true
}

variable "helm_repo_token" {
  sensitive = true
}

variable "do_token" {
  sensitive = true
}

variable "users_realm" {
  sensitive = true
}

variable "users_realm_public_key" {
  sensitive = true
}

variable "users_realm_private_key" {
  sensitive = true
}

variable "users_realm_baseurl" {
  sensitive = true
}

variable "users_realm_username" {
  sensitive = true
}

variable "users_realm_user_password" {
  sensitive = true
}

variable "oauth_client_id" {
  sensitive = true
}

variable "oauth_client_secret" {
  sensitive = true
}

variable "argo-workflows-sso-client-id" {
  sensitive = true
}
variable "argo-workflows-sso-client-secret" {
  sensitive = true
}
variable "registry_creds" {
  sensitive = true
}