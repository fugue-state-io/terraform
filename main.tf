# provider
terraform {
  required_version = ">=1.2.4"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.28.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.8.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "nyc3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "fugue-state-backend"
    key                         = "terraform.tfstate"
  }
}

provider "kubernetes" {
  host             = digitalocean_kubernetes_cluster.fugue-state-cluster.endpoint
  token            = digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.fugue-state-cluster.endpoint
    token = digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].cluster_ca_certificate
    )
  }
}

provider "kubectl" {
  host  = digitalocean_kubernetes_cluster.fugue-state-cluster.endpoint
  token = digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].cluster_ca_certificate
  )
  load_config_file = true
}

provider "digitalocean" {
}

# variables
variable "do_token" {
  sensitive = true
}

variable "helm_repo_token" {
  sensitive = true
}

variable "gh_txt_record" {
  sensitive = true
  default = "_github-challenge-fugue-state-io-org"
}

variable "gh_text_record_value" {
  sensitive = true
  default ="d6c274a1ac"
}

variable "oauth_client_id" {
  sensitive = true
}

variable "oauth_client_secret" {
  sensitive = true
}

variable "keycloak_user" {
  sensitive = true
}

variable "keycloak_password" {
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

resource "digitalocean_project" "fugue-state-io" {
  description  = "fugue-state-io"
  environment  = "Production"
  name         = "fugue-state-io"
  purpose      = "Web Application"
  is_default   = false
}
