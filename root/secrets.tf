resource "kubernetes_secret" "digitalocean-dns" {
  metadata {
    name      = "digitalocean-dns"
    namespace = "cert-manager"
  }
  data = {
    "access-token" = var.do_token
  }
}

resource "kubernetes_secret" "api-secrets" {
  depends_on = [kubernetes_namespace.api]
  metadata {
    name      = "api-secrets"
    namespace = "api"
  }
  data = {
    "FUGUE_STATE_CDN_ACCESS_ID"  = var.do_cdn_spaces_access_id
    "FUGUE_STATE_CDN_SECRET_KEY" = var.do_cdn_spaces_secret_key
  }
}

resource "kubernetes_secret" "fugue-state-ui-secrets" {
  depends_on = [kubernetes_namespace.ui]
  metadata {
    name      = "fugue-state-ui-secrets"
    namespace = "ui"
  }
  data = {
    "NEXTAUTH_SECRET"          = var.nextauth_secret
    "NEXTAUTH_URL"             = var.nextauth_url
    "NEXTAUTH_URL_INTERNAL"    = var.nextauth_url
    "KEYCLOAK_ID"              = var.keycloak_id
    "KEYCLOAK_SECRET"          = var.keycloak_secret
    "KEYCLOAK_ISSUER"          = var.keycloak_issuer
    "DO_CDN_SPACES_ACCESS_ID"  = var.do_cdn_spaces_access_id
    "DO_CDN_SPACES_SECRET_KEY" = var.do_cdn_spaces_secret_key
    "FUGUE_STATE_BUCKET"       = var.fugue_state_bucket
  }
}
resource "kubernetes_secret" "keycloak-postgresql" {
  depends_on = [kubernetes_namespace.keycloak]
  metadata {
    name      = "keycloak-postgresql"
    namespace = "keycloak"
  }
  data = {
    "postgres-password"    = var.postgres_password,
    "replication-password" = var.replication_password,
    "password"             = var.keycloak_postgres_password
  }
}
resource "kubernetes_secret" "keycloak-secrets-env" {
  depends_on = [kubernetes_namespace.keycloak]
  metadata {
    name      = "keycloak-secrets-env"
    namespace = "keycloak"
  }
  data = {
    "KEYCLOAK_ADMIN_USER" = "keycloak"
    "admin-password"      = var.keycloak_password
  }
}
resource "kubernetes_secret" "fugue-state-argocd-secret" {
  depends_on = [kubernetes_namespace.argocd]
  metadata {
    name      = "fugue-state-argocd-secret"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argocd"
      "meta.helm.sh/release-name"      = "argo-cd"
    }
  }
  data = {
    "dexSecret"             = var.oauth_client_secret
    "dexId"                 = var.oauth_client_id
    "webhook.github.secret" = var.argocd_webhook_secret
  }
}

resource "kubernetes_secret" "github-auth" {
  depends_on = [kubernetes_namespace.ci]
  metadata {
    name      = "github-auth"
    namespace = "ci"
  }

  data = {
    "github-app.pem"           = file("${path.cwd}/.sensitive/github_app.pem")
    "github-app-client-id"     = var.github_app_client_id
    "github-app-client-secret" = var.github_app_client_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "fugue-state-repo" {
  depends_on = [kubernetes_namespace.ci]
  metadata {
    name      = "fugue-state-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "type"                    = "git"
    "githubAppPrivateKey"     = trimspace(file("${path.cwd}/.sensitive/github_app.pem"))
    "githubAppID"             = var.github_app_id
    "githubAppInstallationID" = var.github_app_installation_id
    "url"                     = var.github_repo_url
  }

  type = "Opaque"
}

resource "kubernetes_secret" "velero-credentials" {
  depends_on = [kubernetes_namespace.velero]
  metadata {
    name      = "velero-credentials"
    namespace = "velero"
  }
  data = {
    "snapshot-credentials" = "[default]\naws_access_key_id=${var.velero_access_key_id}\naws_secret_access_key=${var.velero_secret_key}"
  }
  type = "Opaque"
}

resource "kubernetes_secret" "velero-digital-ocean-token" {
  depends_on = [kubernetes_namespace.velero]
  metadata {
    name      = "velero-digital-ocean-token"
    namespace = "velero"
  }
  data = {
    "digitalocean_token" = var.velero_snapshot_credential
  }
  type = "Opaque"
}
