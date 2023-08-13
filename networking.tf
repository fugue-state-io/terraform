resource "digitalocean_vpc" "fugue-state-vpc" {
  name       = "fugue-state-vpc"
  region     = "nyc3"
  timeouts {}
}

resource "digitalocean_domain" "fugue-state" {
  name = "fugue-state.io"
}

resource "digitalocean_domain" "fuguestate" {
  name = "fuguestate.io"
}

resource "digitalocean_record" "github-challenge" {
  domain = digitalocean_domain.fugue-state.id
  type   = "TXT"
  name   = var.gh_txt_record
  value  = var.gh_text_record_value
}

resource "digitalocean_record" "a-fugue-state" {
  domain = digitalocean_domain.fugue-state.id
  type   = "A"
  name   = "*"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "a-fuguestate" {
  domain = digitalocean_domain.fuguestate.id
  type   = "A"
  name   = "*"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "at-fugue-state" {
  domain = digitalocean_domain.fugue-state.id
  type   = "A"
  name   = "@"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

resource "digitalocean_record" "at-fuguestate" {
  domain = digitalocean_domain.fuguestate.id
  type   = "A"
  name   = "@"
  value  = data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.ip
}

# Domains
resource "digitalocean_project_resources" "networking_resources" {
  project = digitalocean_project.fugue-state-io.id
  resources = [
    digitalocean_vpc.fugue-state.urn,
    digitalocean_vpc.fuguestate.urn
  ]
}