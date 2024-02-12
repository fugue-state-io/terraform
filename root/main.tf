# provider
terraform {
  required_version = ">=1.2.4"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.28.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
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
  host  = digitalocean_kubernetes_cluster.fugue-state-cluster.endpoint
  token = digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].token
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
  token             = var.do_token
  spaces_access_id  = var.do_spaces_access_id
  spaces_secret_key = var.do_spaces_secret_key
}

# variables
variable "do_token" {
  sensitive = true
}
variable "oauth_client_id" {
  sensitive = true
}
variable "argo_workflows_client_id" {
  sensitive = true
}
variable "argo_workflows_client_secret" {
  sensitive = true
}
variable "argocd_webhook_secret" {
  sensitive = true
}
variable "oauth_client_secret" {
  sensitive = true
}
variable "github_webhook_secret" {
  sensitive = true
}
variable "do_spaces_access_id" {
  sensitive = true
}
variable "do_spaces_secret_key" {
  sensitive = true
}
variable "do_cdn_spaces_access_id" {
  sensitive = true
}
variable "do_cdn_spaces_secret_key" {
  sensitive = true
}
variable "fugue_state_api_url" {
  sensitive = true
}
variable "github_app_id" {
  sensitive = true
}
variable "github_app_installation_id" {
  sensitive = true
}
variable "github_repo_url" {
  sensitive = true
}
variable "github_app_client_id" {
  sensitive = true
}
variable "github_app_client_secret" {
  sensitive = true
}
variable "keycloak_password" {
  sensitive = true
}
variable "nextauth_secret" {
  sensitive = true
}
variable "nextauth_url" {
  sensitive = true
}
variable "keycloak_secret" {
  sensitive = true
}
variable "keycloak_issuer" {
  sensitive = true
}
variable "keycloak_id" {
  sensitive = true
}
variable "fugue_state_bucket" {
  sensitive = true
}
resource "digitalocean_project" "fugue-state-io" {
  description = "fugue-state-io"
  environment = "Production"
  name        = "fugue-state-io"
  purpose     = "Web Application"
  is_default  = false
}
