# resources
resource "digitalocean_kubernetes_cluster" "fugue-state-cluster" {
  name    = "fugue-state-cluster"
  region  = "nyc3"
  version = "1.26.5-do.0"
  vpc_uuid = digitalocean_vpc.fugue-state-vpc.id
  node_pool {
    name       = "worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 3
  }
}

resource "digitalocean_kubernetes_node_pool" "autoscale-pool-01" {
  cluster_id = digitalocean_kubernetes_cluster.fugue-state-cluster.id
  name       = "autoscale-pool-01"
  size       = "s-1vcpu-2gb"
  auto_scale = true
  min_nodes  = 2
  max_nodes  = 7
}

resource "local_file" "kubeconfig" {
  lifecycle {
    ignore_changes = all
  }
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  content    = digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].raw_config
  filename   = "${path.root}/.sensitive/kubeconfig"
}

module "charts" {
  source = "./charts"
  keycloak_user = var.keycloak_user
  keycloak_password = var.keycloak_password
  do_token = var.do_token
  users_realm = var.users_realm
  users_realm_baseurl = var.users_realm_baseurl
  users_realm_private_key = var.users_realm_private_key
  users_realm_public_key = var.users_realm_public_key
  users_realm_username = var.users_realm_username
  users_realm_user_password = var.users_realm_username
  helm_repo_token = var.helm_repo_token
  oauth_client_id = var.oauth_client_id
  oauth_client_secret = var.oauth_client_secret
  cluster_name = digitalocean_kubernetes_cluster.fugue-state-cluster.name
  postgres = digitalocean_database_cluster.postgres
  keycloak-db-user = digitalocean_database_user.keycloak-db-user
  keycloak-db = digitalocean_database_db.keycloak-db
  registry_creds = digitalocean_container_registry_docker_credentials.fugue-state-registry-credentials
  providers = {
    helm = helm
    kubectl = kubectl
  }
}

data "digitalocean_loadbalancer" "fugue-state-cluster-loadbalancer" {
  depends_on = [ module.charts.load_balancer ]
  name = format("%s-nginx-ingress", digitalocean_kubernetes_cluster.fugue-state-cluster.name)
}