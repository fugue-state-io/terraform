resource "helm_release" "reloader" {
  depends_on = [ kubernetes_namespace.reloader ]
  name       = "reloader"
  namespace  = kubernetes_namespace.reloader.metadata.0.name
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "1.0.29"
}

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
    value = file("${path.root}/.sensitive/ca.crt")
  }

  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = file("${path.root}/.sensitive/issuer.crt")
  }

  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = file("${path.root}/.sensitive/issuer.key")
  }
}

resource "helm_release" "cert-manager" {
  depends_on = [ helm_release.linkerd-control-plane ]
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart             = "cert-manager"
  cleanup_on_fail  = true
  force_update     = true
  namespace        = kubernetes_namespace.cert-manager.metadata[0].name
  create_namespace = true

  set {
    name = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "fugue-state-cert-issuer" {
  depends_on = [ helm_release.cert-manager ]
  name             = "fugue-state-cert-issuer"
  chart            = "${path.module}/fugue-state-cert-issuer/"
  cleanup_on_fail  = true
  force_update     = true
  namespace        = kubernetes_namespace.cert-manager.metadata[0].name

  set_sensitive {
    name = "base64token"
    value = base64encode(var.do_token)
  }
}

resource "helm_release" "nginx-ingress" {
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
    value = format("%s-nginx-ingress", var.cluster_name)
  }
}