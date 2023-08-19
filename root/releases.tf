resource "helm_release" "linkerd" {
  depends_on = [ kubernetes_namespace.linkerd ]
  name             = "linkerd"
  repository       = "https://helm.linkerd.io/stable"
  chart             = "linkerd-crds"
  cleanup_on_fail  = true
  force_update     = true
  namespace        = kubernetes_namespace.linkerd.metadata[0].name
  create_namespace = true
}

resource "helm_release" "linkerd-control-plane" {
  depends_on = [ helm_release.linkerd ]
  name             = "linkerd-control-plane"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-control-plane"

  namespace        = kubernetes_namespace.linkerd.metadata[0].name
  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = file("${path.root}/../.sensitive/ca.crt")
  }

  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = file("${path.root}/../.sensitive/issuer.crt")
  }

  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = file("${path.root}/../.sensitive/issuer.key")
  }
}

resource "helm_release" "nginx-ingress" {
  depends_on = [ digitalocean_kubernetes_cluster.fugue-state-cluster ]
  name       = "nginx-ingress-controller"
  namespace  = kubernetes_namespace.nginx-ingress.metadata.0.name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/do-loadbalancer-name"
    value = format("%s-nginx-ingress", digitalocean_kubernetes_cluster.fugue-state-cluster.name)
  }
}