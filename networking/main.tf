# provider
terraform {
  required_version = ">=1.2.4"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.28.1"
    }
  }
}
# variables
variable "load_balancer_ip" {
  type = string
  default = "0.0.0.0"
}

variable "gh_txt_record" {
}

variable "gh_text_record_value" {
}
# resources
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
  value  = var.load_balancer_ip
}

resource "digitalocean_record" "a-fuguestate" {
  domain = digitalocean_domain.fuguestate.id
  type   = "A"
  name   = "*"
  value  = var.load_balancer_ip
}

resource "digitalocean_record" "at-fugue-state" {
  domain = digitalocean_domain.fugue-state.id
  type   = "A"
  name   = "@"
  value  = var.load_balancer_ip
}

resource "digitalocean_record" "at-fuguestate" {
  domain = digitalocean_domain.fuguestate.id
  type   = "A"
  name   = "@"
  value  = var.load_balancer_ip
}
# outputs
output "vpc" {
  value = digitalocean_vpc.fugue-state-vpc
}
output "resources" {
  value = [digitalocean_domain.fuguestate.urn, digitalocean_domain.fugue-state.urn]
}