# provider
terraform {
  required_version = ">=1.2.4"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.28.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
# Create a new container registry
resource "digitalocean_container_registry" "fugue-state-registry" {
  name                   = "fugue-state-registry"
  subscription_tier_slug = "basic"
  region = "nyc3"
}

resource "digitalocean_container_registry_docker_credentials" "fugue-state-registry-credentials" {
  registry_name = digitalocean_container_registry.fugue-state-registry.name
}

provider "docker" {
  host = "unix://var/run/docker.sock"

  registry_auth {
    address             = digitalocean_container_registry.fugue-state-registry.server_url
    config_file_content = digitalocean_container_registry_docker_credentials.fugue-state-registry-credentials.docker_credentials
  }
}

# output
output "registry_creds" {
  value = digitalocean_container_registry_docker_credentials.fugue-state-registry-credentials
}