# resources
resource "digitalocean_database_cluster" "postgres" {
  name       = "fugue-state-postgres-cluster"
  engine     = "pg"
  version    = "14"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
  private_network_uuid = digitalocean_vpc.fugue-state-vpc.id
}

resource "digitalocean_database_db" "keycloak-db" {
  depends_on = [ digitalocean_database_cluster.postgres ]
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "keycloak"
}

resource "digitalocean_database_user" "keycloak-db-user" {
  depends_on = [ digitalocean_database_cluster.postgres ]
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "keycloak-user"
}

resource "digitalocean_database_db" "postgres-db" {
  depends_on = [ digitalocean_database_cluster.postgres ]
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "postgres"
}

resource "digitalocean_database_user" "argo-db-user" {
  depends_on = [ digitalocean_database_cluster.postgres ]
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "argo-user"
}

resource "digitalocean_database_firewall" "postgres-fw" {
  depends_on = [ digitalocean_database_cluster.postgres ]
  cluster_id = digitalocean_database_cluster.postgres.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.fugue-state-cluster.id
  }
}

# Database Clusters
resource "digitalocean_project_resources" "db_resources" {
  depends_on = [ digitalocean_database_cluster.postgres ]
  project = digitalocean_project.fugue-state-io.id
  resources = [
    digitalocean_database_cluster.postgres.urn
  ]
}