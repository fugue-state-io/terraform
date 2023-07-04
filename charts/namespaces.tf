resource "kubernetes_namespace" "reloader" {
  metadata {
    name = "reloader"
  }
}

resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = "linkerd"
  }
}

resource "kubernetes_namespace" "cert-manager" {
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