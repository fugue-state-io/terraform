resource "kubernetes_secret" "digitalocean-dns" {
  metadata {
    name = "digitalocean-dns"
    namespace = "cert-manager"
  }
  data = {
    "access-token" = var.do_token
  }
}

resource "kubernetes_secret" "argo-workflows-sso-argocd" {
  depends_on = [ kubernetes_namespace.argocd ]
  metadata {
    name = "argo-workflows-sso"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/part-of" = "argocd"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argocd"
      "meta.helm.sh/release-name" = "argo-cd"
    }
  }
  data = {
    "client-secret" = var.argo_workflows_client_secret
    "client-id" = var.argo_workflows_client_id
  }
}

resource "kubernetes_secret" "ci-secrets" {
  depends_on = [ kubernetes_namespace.ci ]
  metadata {
    name = "ci-secrets"
    namespace = "ci"
  }
  data = {
    "github-webhook-secret" = var.github_webhook_secret
    "spaces_access_id" = var.do_spaces_access_id
    "spaces_secret_key" = var.do_spaces_secret_key
  }
}

resource "kubernetes_secret" "api-secrets" {
  depends_on = [ kubernetes_namespace.api ]
  metadata {
    name = "api-secrets"
    namespace = "api"
  }
  data = {
    "FUGUE_STATE_CDN_ACCESS_ID" = var.do_cdn_spaces_access_id
    "FUGUE_STATE_CDN_SECRET_KEY" = var.do_cdn_spaces_secret_key
  }
}
resource "kubernetes_secret" "fugue-state-ui-secrets" {
  depends_on = [ kubernetes_namespace.ui ]
  metadata {
    name = "fugue-state-ui-secrets"
    namespace = "ui"
  }
  data = {
    "TF_VAR_nextauth_secret" = var.nextauth_secret
    "TF_VAR_nextauth_url" = var.nextauth_url
    "TF_VAR_keycloak_id" = var.keycloak_id
    "TF_VAR_keycloak_secret" = var.keycloak_secret
    "TF_VAR_keycloak_issuer" = var.keycloak_issuer
    "TF_VAR_do_cdn_spaces_access_id" = var.do_cdn_spaces_access_id
    "TF_VAR_do_cdn_spaces_secret_key" = var.do_cdn_spaces_secret_key
    "TF_VAR_fugue_state_bucket" = var.fugue_state_bucket
  }
}
resource "kubernetes_secret" "keycloak-secrets" {
  depends_on = [ kubernetes_namespace.keycloak ]
  metadata {
    name = "keycloak-secrets"
    namespace = "keycloak"
  }
  data = {
    "password" = digitalocean_database_user.keycloak-db-user.password
  }
}
resource "kubernetes_secret" "keycloak-secrets-env" {
  depends_on = [ kubernetes_namespace.keycloak ]
  metadata {
    name = "keycloak-secrets-env"
    namespace = "keycloak"
  }
  data = {
    "KEYCLOAK_ADMIN_USER" = "keycloak"
    "KEYCLOAK_ADMIN_PASSWORD" = var.keycloak_password
  }
}
resource "kubernetes_secret" "argo-workflows-sso-argoworkflows" {
  depends_on = [ kubernetes_namespace.argo-workflows ]
  metadata {
    name = "argo-workflows-sso"
    namespace = "argo-workflows"
    labels = {
      "app.kubernetes.io/part-of" = "argo-workflows"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argo-workflows"
      "meta.helm.sh/release-name" = "argo-workflows"
    }
  }
  data = {
    "client-secret" = var.argo_workflows_client_secret
    "client-id" = var.argo_workflows_client_id
  }
}
resource "kubernetes_secret" "argo-workflows-spaces" {
  depends_on = [ kubernetes_namespace.argo-workflows ]
  metadata {
    name = "argo-workflows-spaces"
    namespace = "argo-workflows"
    labels = {
      "app.kubernetes.io/part-of" = "argo-workflows"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argo-workflows"
      "meta.helm.sh/release-name" = "argo-workflows"
    }
  }
  data = {
    "spaces_access_id" = var.do_spaces_access_id
    "spaces_secret_key" = var.do_spaces_secret_key
  }
}
resource "kubernetes_secret" "argo-postgres-config" {
  depends_on = [ kubernetes_namespace.argo-workflows ]
  metadata {
    name = "argo-postgres-config"
    namespace = "argo-workflows"
    labels = {
      "app.kubernetes.io/part-of" = "argo-workflows"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argo-workflows"
      "meta.helm.sh/release-name" = "argo-workflows"
    }
  }
  data = {
    "username" = digitalocean_database_user.argo-db-user.name
    "password" = digitalocean_database_user.argo-db-user.password
  }
}
resource "kubernetes_secret" "fugue-state-argocd-secret" {
  depends_on = [ kubernetes_namespace.argocd ]
  metadata {
    name = "fugue-state-argocd-secret"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/part-of" = "argocd"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argocd"
      "meta.helm.sh/release-name" = "argo-cd"
    }
  }
  data = {
    "dexSecret" = var.oauth_client_secret
    "dexId" = var.oauth_client_id
    "webhook.github.secret" = var.argocd_webhook_secret
  }
}

resource "kubernetes_secret" "docker-config-ci" {
  depends_on = [ kubernetes_namespace.ci ]
  metadata {
    name = "docker-config"
    namespace = "ci"
  }

  data = {
    "config.json" = digitalocean_container_registry_docker_credentials.fugue-state-registry-credentials.docker_credentials
  }

  type = "Opaque"
}

resource "kubernetes_secret" "github-auth" {
  depends_on = [ kubernetes_namespace.ci ]
  metadata {
    name = "github-auth"
    namespace = "ci"
  }

  data = {
    "github-app.pem" = file("${path.cwd}/.sensitive/github_app.pem")
    "github-app-client-id" = var.github_app_client_id
    "github-app-client-secret" = var.github_app_client_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "fugue-state-repo" {
  depends_on = [ kubernetes_namespace.ci ]
  metadata {
    name = "fugue-state-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "type" = "git"
    "githubAppPrivateKey" = trimspace(file("${path.cwd}/.sensitive/github_app.pem"))
    "githubAppID" = var.github_app_id
    "githubAppInstallationID" = var.github_app_installation_id
    "url" = var.github_repo_url
  }

  type = "Opaque"
}