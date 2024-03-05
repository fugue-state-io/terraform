# Create a new container registry
resource "digitalocean_container_registry" "fugue-state-registry" {
  name                   = "fugue-state-registry"
  subscription_tier_slug = "professional"
  region = "nyc3"
}

resource "digitalocean_container_registry_docker_credentials" "fugue-state-registry-credentials-rw" {
  registry_name = digitalocean_container_registry.fugue-state-registry.name
}

resource "local_file" "docker_credentials" {
  lifecycle {
    ignore_changes = all
  }
  content    = digitalocean_container_registry_docker_credentials.fugue-state-registry-credentials-rw.docker_credentials
  filename   = "${path.root}/../.sensitive/docker_credentials"
}

resource "digitalocean_container_registry_docker_credentials" "fugue-state-registry-credentials" {
  registry_name = digitalocean_container_registry.fugue-state-registry.name
  write = true
}