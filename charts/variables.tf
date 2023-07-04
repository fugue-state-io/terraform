variable "cluster_name" {

}

variable "postgres" {
  
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