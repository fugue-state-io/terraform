resource "kubernetes_namespace" "reloader" {
  depends_on = [ digitalocean_kubernetes_cluster.fugue-state-cluster ]
  metadata {
    name = "reloader"
  }
}

resource "kubernetes_namespace" "linkerd" {
  depends_on = [ digitalocean_kubernetes_cluster.fugue-state-cluster ]
  metadata {
    name = "linkerd"
  }
}

resource "kubernetes_namespace" "cert-manager" {
  depends_on = [ digitalocean_kubernetes_cluster.fugue-state-cluster ]
  metadata {
    annotations = {
      name = "linkerd.io/inject"
      value = "enabled"
    }
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "nginx-ingress" {
  depends_on = [ helm_release.fugue-state-cert-issuer, helm_release.linkerd-control-plane ]
  metadata {
    annotations = {
      name = "linkerd.io/inject"
      value = "enabled"
    }
    name = "nginx-ingress"
  }
}

resource "kubernetes_namespace" "keycloak" {
  depends_on = [ helm_release.nginx-ingress ]
  metadata {
    annotations = {
      name = "linkerd.io/inject"
      value = "enabled"
    }
    name = "keycloak"
  }
}

resource "kubernetes_namespace" "ui" {
  depends_on = [ helm_release.nginx-ingress ]
  metadata {
    annotations = {
      name = "linkerd.io/inject"
      value = "enabled"
    }
    name = "ui"
  }
}

resource "kubernetes_namespace" "argo-workflows" {
  depends_on = [ helm_release.nginx-ingress ]
  metadata {
    annotations = {
      name = "linkerd.io/inject"
      value = "enabled"
    }
    name = "argo-workflows"
  }
}

resource "kubernetes_namespace" "workflows" {
  depends_on = [ helm_release.nginx-ingress ]
  metadata {
    annotations = {
      name = "linkerd.io/inject"
      value = "enabled"
    }
    name = "workflows"
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [ helm_release.nginx-ingress ]
  metadata {
    annotations = {
      name = "linkerd.io/inject"
      value = "enabled"
    }
    name = "argocd"
  }
}