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
# variable
variable "vpc" {
}

variable "doks" {

}
# resources
resource "digitalocean_database_cluster" "postgres" {
  depends_on = [ var.vpc ]
  name       = "fugue-state-postgres-cluster"
  engine     = "pg"
  version    = "14"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
  private_network_uuid = var.vpc.id
}

resource "digitalocean_database_db" "keycloak-db" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "keycloak"
}

resource "digitalocean_database_user" "keycloak-db-user" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "keycloak-user"
}

resource "digitalocean_database_firewall" "postgres-fw" {
  cluster_id = digitalocean_database_cluster.postgres.id

  rule {
    type  = "k8s"
    value = var.doks.id
  }
}
# output
output "postgres" {
  value = digitalocean_database_cluster.postgres
}

output "keycloak-db" {
  value = digitalocean_database_db.keycloak-db
}

output "keycloak-db-user" {
  value = digitalocean_database_user.keycloak-db-user
}

output "resources" {
  value = [digitalocean_database_cluster.postgres.urn]
}