resource "kubernetes_namespace" "reloader" {
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  metadata {
    name = "reloader"
  }
}

resource "kubernetes_namespace" "linkerd" {
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  metadata {
    name = "linkerd"
  }
}
resource "kubernetes_namespace" "jump" {
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "jump"
  }
}
resource "kubernetes_namespace" "cert-manager" {
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "cert-manager"
  }
}
resource "kubernetes_namespace" "redis" {
  depends_on = [digitalocean_kubernetes_cluster.fugue-state-cluster]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "redis"
  }
}
resource "kubernetes_namespace" "nginx-ingress" {
  depends_on = [helm_release.linkerd-control-plane]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "nginx-ingress"
  }
}

resource "kubernetes_namespace" "ui" {
  depends_on = [helm_release.nginx-ingress]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "ui"
  }
}


resource "kubernetes_namespace" "tf-backup" {
  metadata {
    name = "tf-backup"
  }
}
resource "kubernetes_namespace" "api" {
  depends_on = [helm_release.nginx-ingress]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "api"
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [helm_release.nginx-ingress]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "argocd"
  }
}
resource "kubernetes_namespace" "argo-events" {
  depends_on = [helm_release.nginx-ingress]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "argo-events"
  }
}
resource "kubernetes_namespace" "argo-workflows" {
  depends_on = [helm_release.nginx-ingress]
  metadata {
    annotations = {
      name  = "linkerd.io/inject"
      value = "enabled"
    }
    name = "argo-workflows"
  }
}
