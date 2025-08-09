# provider
terraform {
  required_version = ">=1.6.3"
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
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.14.0"
    }
  }
  backend "s3" {
    # Deactivate a few AWS-specific checks
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"
    endpoints                   = { s3 = "https://nyc3.digitaloceanspaces.com" }
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
  type      = string
  sensitive = true
}
variable "oauth_client_id" {
  type      = string
  sensitive = true
}
variable "ui_base_url" {
  type      = string
  sensitive = true
}
variable "ui_auth_url" {
  type      = string
  sensitive = true
}
variable "argocd_webhook_secret" {
  type      = string
  sensitive = true
}
variable "oauth_client_secret" {
  type      = string
  sensitive = true
}
variable "do_spaces_access_id" {
  type      = string
  sensitive = true
}
variable "do_spaces_secret_key" {
  type      = string
  sensitive = true
}
variable "do_cdn_spaces_access_id" {
  type      = string
  sensitive = true
}
variable "do_cdn_spaces_secret_key" {
  type      = string
  sensitive = true
}
variable "fugue_state_cdn_access_key" {
  type      = string
  sensitive = true
}
variable "fugue_state_cdn_secret_key" {
  type      = string
  sensitive = true
}
variable "github_app_id" {
  type      = string
  sensitive = true
}
variable "github_app_installation_id" {
  type      = string
  sensitive = true
}
variable "github_repo_url" {
  type      = string
  sensitive = true
}
variable "github_app_client_id" {
  type      = string
  sensitive = true
}
variable "github_app_client_secret" {
  type      = string
  sensitive = true
}
variable "github_webhook_secret" {
  type      = string
  sensitive = true
}
variable "fugue_state_bucket" {
  type      = string
  sensitive = true
}
variable "ui_feature_project_select" {
  type      = string
  sensitive = true
}
variable "app_password" {
  type      = string
  sensitive = true
}
variable "app_email" {
  type      = string
  sensitive = true
}
variable "redis_password" {
  type      = string
  sensitive = true
}
variable "redis_host" {
  type      = string
  sensitive = true
}
variable "redis_port" {
  type      = string
  sensitive = true
}
variable "argo_workflows_client_id" {
  type      = string
  sensitive = true
}

variable "argo_workflows_client_secret" {
  type      = string
  sensitive = true
}
variable "smtp_password" {
  type      = string
  sensitive = true
}
variable "smtp_user" {
  type      = string
  sensitive = true
}
variable "email_provider" {
  type      = string
  sensitive = true
}
variable "email_from" {
  type      = string
  sensitive = true
}
variable "email_from_name" {
  type      = string
  sensitive = true
}
variable "smtp_host" {
  type      = string
  sensitive = true
}
variable "smtp_port" {
  type      = string
  sensitive = true
}
variable "smtp_secure" {
  type      = string
  sensitive = true
}
variable "sendgrid_api_key" {
  type      = string
  sensitive = true
}
variable "ui_feature_auth" {
  type      = string
  sensitive = true
}
variable "stripe_secret_key" {
  type      = string
  sensitive = true
}
variable "stripe_publishable_key" {
  type      = string
  sensitive = true
}
variable "stripe_webhook_secret" {
  type      = string
  sensitive = true
}
variable "stripe_price_id" {
  type      = string
  sensitive = true
}
resource "digitalocean_project" "fugue-state-io" {
  description = "fugue-state-io"
  environment = "Production"
  name        = "fugue-state-io"
  purpose     = "Web Application"
  is_default  = false
}
