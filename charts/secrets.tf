
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

resource "kubernetes_secret" "docker-cfg" {
  depends_on = [ kubernetes_namespace.c2 ]
  metadata {
    name = "docker-cfg"
    namespace = "c2"
  }

  data = {
    ".dockerconfigjson" = var.registry_creds.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "keycloak-secret" {
  depends_on = [ kubernetes_namespace.keycloak ]
  metadata {
    name = "keycloak-secret"
    namespace = "keycloak"
  }
  data = {
    "keycloak-user" = var.keycloak-user.name
    "keycloak-password" = var.keycloak-user.password
    "external-db" = var.keycloak-db.name
    "external-db-host" = var.postgres.private_host
    "external-db-port" = var.postgres.port
    "external-db-user" = var.keycloak-user.name
    "external-db-password" = var.keycloak-user.password
  }
}
# This not working is why repos can't be private but who cares
# resource "kubernetes_secret" "argocd-repo-creds-github" {
#   depends_on = [ kubernetes_namespace.argocd ]
#   metadata {
#     name = "argocd-repo-creds-github"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repo-creds"
#     }
#   }
#   data = {
#     "type" = "helm"
#     "url" = "https://github.com/fugue-state-io"
#     "githubAppPrivateKey" = file("${path.root}/.sensitive/githubAppPrivateKey")
#     "project"  = "fugue-state"
#     "githubAppID" = 348886
#     "githubAppInstallationID" = 348886
#   }
# }