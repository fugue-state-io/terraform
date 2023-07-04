
resource "kubernetes_secret" "digitalocean-dns" {
  metadata {
    name = "digitalocean-dns"
    namespace = "cert-manager"
  }
  data = {
    "access-token" = var.do_token
  }
}

resource "kubernetes_secret" "fugue-state-argocd-secret" {
  depends_on = [ kubernetes_namespace.argocd ]
  metadata {
    name = "fugue-state-argocd-secret"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/part-of" = "argocd"
    }
  }
  data = {
    "dexSecret" = var.oauth_client_secret
    "dexId" = var.oauth_client_id
  }
}

resource "kubernetes_secret" "argocd-repo-creds-github" {
  depends_on = [ kubernetes_namespace.argocd ]
  metadata {
    name = "argocd-repo-creds-github"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }
  data = {
    "type" = "helm"
    "url" = "https://github.com/fugue-state-io"
    "githubAppPrivateKey" = file("${path.root}/.sensitive/githubAppPrivateKey")
    "project"  = "fugue-state"
    "githubAppID" = 348886
    "githubAppInstallationID" = 348886
  }
}