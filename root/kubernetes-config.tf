# resources
resource "digitalocean_kubernetes_cluster" "fugue-state-cluster" {
  name    = "fugue-state-cluster"
  region  = "nyc3"
  version = "1.28.2-do.0"
  vpc_uuid = digitalocean_vpc.fugue-state-vpc.id
  node_pool {
    name       = "worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 3
  }
}

resource "digitalocean_kubernetes_node_pool" "autoscale-pool-01" {
  depends_on = [ digitalocean_kubernetes_cluster.fugue-state-cluster ]
  cluster_id = digitalocean_kubernetes_cluster.fugue-state-cluster.id
  name       = "autoscale-pool-01"
  size       = "s-1vcpu-2gb"
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 7
}


resource "local_file" "kubeconfig" {
  lifecycle {
    ignore_changes = all
  }
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  content    = digitalocean_kubernetes_cluster.fugue-state-cluster.kube_config[0].raw_config
  filename   = "${path.root}/../.sensitive/kubeconfig"
}

data "digitalocean_loadbalancer" "fugue-state-cluster-loadbalancer" {
  depends_on = [ helm_release.nginx-ingress ]
  name = format("%s-nginx-ingress", digitalocean_kubernetes_cluster.fugue-state-cluster.name)
}

# Kubernetes Cluster
# Load Balancers
resource "digitalocean_project_resources" "kubernetes_resources" {
  depends_on = [ digitalocean_kubernetes_cluster.fugue-state-cluster ]
  project = digitalocean_project.fugue-state-io.id
  resources = [
    data.digitalocean_loadbalancer.fugue-state-cluster-loadbalancer.urn,
    digitalocean_kubernetes_cluster.fugue-state-cluster.urn
  ]
}