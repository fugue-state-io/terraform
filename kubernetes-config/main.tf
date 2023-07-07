# providers
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
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.8.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
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
  load_config_file       = false
}

# variables
variable "write_kubeconfig" {
  type        = bool
  default     = false
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

variable "vpc" {
}

variable "postgres" {
}

variable "keycloak-db" {
  sensitive = true
}

variable "keycloak-user" {
  sensitive = true
}

variable "registry_creds" {
  sensitive = true
}

# resources
resource "digitalocean_kubernetes_cluster" "fugue-state-cluster" {
  name    = "fugue-state-cluster"
  region  = "nyc3"
  version = "1.26.5-do.0"
  vpc_uuid = var.vpc.id
  node_pool {
    name       = "worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 3
  }
}

resource "local_file" "kubeconfig" {
  lifecycle {
    ignore_changes = all
  }
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  count      = var.write_kubeconfig ? 1 : 0
  content    = digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].raw_config
  filename   = "${path.root}/.sensitive/kubeconfig"
}

module "charts" {
  source = "../charts"
  cluster_name = digitalocean_kubernetes_cluster.fugue-state-cluster.name
  postgres = var.postgres
  keycloak-user = var.keycloak-user
  keycloak-db = var.keycloak-db
  do_token = var.do_token
  registry_creds = var.registry_creds
  helm_repo_token = var.helm_repo_token
  oauth_client_id = var.oauth_client_id
  oauth_client_secret = var.oauth_client_secret
  providers = {
    helm = helm
    kubectl = kubectl
  }
}

data "digitalocean_loadbalancer" "fugue-state-cluster-loadbalancer" {
  depends_on = [ module.charts.load_balancer ]
  name = format("%s-nginx-ingress", digitalocean_kubernetes_cluster.fugue-state-cluster.name)
}
# outputs
output "doks" {
  value = digitalocean_kubernetes_cluster.fugue-state-cluster
}

output "load_balancer_ip" {
  value = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

output "resources" {
  value = [digitalocean_kubernetes_cluster.fugue-state-cluster.urn]
}