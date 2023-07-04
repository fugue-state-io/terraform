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
  sensitive = false
  default = "_github-challenge-fugue-state-io-org"
}

variable "gh_text_record_value" {
  sensitive = false
  default ="d6c274a1ac"
}

variable "oauth_client_id" {
  sensitive = true
}

variable "oauth_client_secret" {
  sensitive = true
}
# resources
module "kubernetes-config" {
  source = "./kubernetes-config"
  vpc = module.networking.vpc
  postgres = module.db.postgres
  registry_creds = module.registry.registry_creds
  write_kubeconfig = true
  do_token = var.do_token
  helm_repo_token = var.helm_repo_token
  oauth_client_id = var.oauth_client_id
  oauth_client_secret = var.oauth_client_secret
  providers = {
    digitalocean = digitalocean
  }
}

module "networking" {
  source = "./networking"
  load_balancer_ip = module.kubernetes-config.load_balancer_ip
  gh_txt_record = var.gh_txt_record
  gh_text_record_value = var.gh_text_record_value
  providers = {
    digitalocean = digitalocean
  }
}

module "db" {
  source = "./db"
  vpc = module.networking.vpc
  doks = module.kubernetes-config.doks
  providers = {
    digitalocean = digitalocean
  }
}

module "registry" {
  source = "./registry"
  providers = {
    digitalocean = digitalocean
  }
}

resource "digitalocean_project" "fugue-state-io" {
  description  = "fugue-state-io"
  environment  = "Production"
  name         = "fugue-state-io"
  purpose      = "Web Application"
  resources    = concat(module.networking.resources, module.kubernetes-config.resources, module.db.resources)
}