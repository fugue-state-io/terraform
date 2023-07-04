terraform {
  required_version = ">=1.2.4"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}