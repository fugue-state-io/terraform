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

resource "kubernetes_secret" "redis-auth" {
  depends_on = [kubernetes_namespace.api]
  metadata {
    name      = "redis-auth"
    namespace = "redis"
  }
  data = {
    "redis-password" = var.redis_password
  }
}

resource "kubernetes_secret" "fugue-state-ui-secrets" {
  depends_on = [kubernetes_namespace.ui]
  metadata {
    name      = "fugue-state-ui-secrets"
    namespace = "ui"
  }
  data = {
    "AUTH_SECRET"                           = var.nextauth_secret
    "AUTH_URL"                              = var.ui_auth_url
    "AUTH_URL_INTERNAL"                     = var.ui_auth_url
    "AUTH_KEYCLOAK_ID"                      = var.keycloak_id
    "AUTH_KEYCLOAK_SECRET"                  = var.keycloak_secret
    "AUTH_KEYCLOAK_ISSUER"                  = var.keycloak_issuer
    "FUGUE_STATE_CDN_ACCESS_ID"             = var.fugue_state_cdn_access_key
    "FUGUE_STATE_CDN_SECRET_KEY"            = var.fugue_state_cdn_secret_key
    "FUGUE_STATE_BUCKET"                    = var.fugue_state_bucket
    "NEXT_PUBLIC_BASE_URL"                  = var.ui_base_url
    "NEXT_PUBLIC_UI_FEATURE_PROJECT_SELECT" = var.ui_feature_project_select
    "NEXT_TELEMETRY_DISABLED"               = 1
    "NODE_ENV"                              = "production"
    "REDIS_PASSWORD"                        = var.redis_password
    "REDIS_HOST"                            = var.redis_host
    "REDIS_PORT"                            = var.redis_port
  }
}
resource "kubernetes_secret" "keycloak-postgresql-auth" {
  depends_on = [kubernetes_namespace.keycloak]
  metadata {
    name      = "keycloak-postgresql-auth"
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
resource "kubernetes_secret" "s3-access-secret" {
  depends_on = [kubernetes_namespace.argocd]
  metadata {
    name      = "s3-access-secret"
    namespace = "argo-events"
    labels = {
      "app.kubernetes.io/part-of"    = "argo-events"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argo-events"
      "meta.helm.sh/release-name"      = "argo-events"
    }
  }
  data = {
    "accessKey" = var.fugue_state_cdn_access_key
    "secretKey" = var.fugue_state_cdn_secret_key
  }
}

resource "kubernetes_secret" "argo-workflows-sso-argoworkflows" {
  depends_on = [kubernetes_namespace.argo-workflows]
  metadata {
    name      = "argo-workflows-sso"
    namespace = "argo-workflows"
    labels = {
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argo-workflows"
      "meta.helm.sh/release-name"      = "argo-workflows"
    }
  }
  data = {
    "client-secret" = var.argo_workflows_client_secret
    "client-id"     = var.argo_workflows_client_id
  }
}
resource "kubernetes_secret" "argo-postgres-config" {
  depends_on = [kubernetes_namespace.argo-workflows]
  metadata {
    name      = "argo-postgres-config"
    namespace = "argo-workflows"
    labels = {
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argo-workflows"
      "meta.helm.sh/release-name"      = "argo-workflows"
    }
  }
  data = {
    "username" = digitalocean_database_user.argo-db-user.name
    "password" = digitalocean_database_user.argo-db-user.password
    "host"     = digitalocean_database_cluster.postgres.private_uri
  }
}
resource "kubernetes_secret" "argo-workflows-sso-argocd" {
  depends_on = [kubernetes_namespace.argocd]
  metadata {
    name      = "argo-workflows-sso"
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
    "client-secret" = var.argo_workflows_client_secret
    "client-id"     = var.argo_workflows_client_id
  }
}

resource "kubernetes_secret" "argo-workflows-spaces" {
  depends_on = [kubernetes_namespace.argo-workflows]
  metadata {
    name      = "argo-workflows-spaces"
    namespace = "argo-workflows"
    labels = {
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-namespace" = "argo-workflows"
      "meta.helm.sh/release-name"      = "argo-workflows"
    }
  }
  data = {
    "spaces_access_id"  = var.do_spaces_access_id
    "spaces_secret_key" = var.do_spaces_secret_key
  }
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

resource "kubernetes_secret" "fluentd-s3-credentials" {
  depends_on = [kubernetes_namespace.fluentd]
  metadata {
    name      = "fluentd-s3-credentials"
    namespace = "fluentd"
  }
  data = {
    "AWS_ACCESS_KEY_ID"     = "${var.do_spaces_access_id}",
    "AWS_SECRET_ACCESS_KEY" = "${var.do_spaces_secret_key}"
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

resource "kubernetes_secret" "realm-secret" {
  metadata {
    name      = "realm-secret"
    namespace = "keycloak"
  }
  data = {
    "AUTH_SECRET" : var.keycloak_secret,
    "APP_PASSWORD" : var.app_password
    "APP_EMAIL" : var.app_email
  }
}


resource "kubernetes_secret" "tf-backup" {
  metadata {
    name      = "tf-secrets"
    namespace = "tf-backup"
  }
  data = {
    "DIGITALOCEAN_TOKEN"                = var.do_token,
    "TF_VAR_do_token"                   = var.do_token,
    "TF_VAR_oauth_client_id"            = var.oauth_client_id,
    "TF_VAR_argocd_webhook_secret"      = var.argocd_webhook_secret,
    "TF_VAR_oauth_client_secret"        = var.oauth_client_secret,
    "TF_VAR_do_spaces_access_id"        = var.do_spaces_access_id,
    "TF_VAR_do_spaces_secret_key"       = var.do_spaces_secret_key,
    "TF_VAR_do_cdn_spaces_access_id"    = var.do_cdn_spaces_access_id,
    "TF_VAR_do_cdn_spaces_secret_key"   = var.do_cdn_spaces_secret_key,
    "TF_VAR_github_app_id"              = var.github_app_id,
    "TF_VAR_github_app_installation_id" = var.github_app_installation_id,
    "TF_VAR_github_repo_url"            = var.github_repo_url,
    "TF_VAR_github_app_client_id"       = var.github_app_client_id,
    "TF_VAR_github_app_client_secret"   = var.github_app_client_secret,
    "TF_VAR_github_webhook_secret"      = var.github_webhook_secret,
    "TF_VAR_keycloak_password"          = var.keycloak_password,
    "TF_VAR_nextauth_secret"            = var.nextauth_secret,
    "TF_VAR_nextauth_url"               = var.nextauth_url,
    "TF_VAR_keycloak_secret"            = var.keycloak_secret,
    "TF_VAR_keycloak_issuer"            = var.keycloak_issuer,
    "TF_VAR_keycloak_id"                = var.keycloak_id,
    "TF_VAR_fugue_state_bucket"         = var.fugue_state_bucket,
    "TF_VAR_velero_snapshot_credential" = var.velero_snapshot_credential,
    "TF_VAR_velero_access_key_id"       = var.velero_access_key_id,
    "TF_VAR_velero_secret_key"          = var.velero_secret_key,
    "TF_VAR_postgres_password"          = var.postgres_password,
    "TF_VAR_replication_password"       = var.replication_password,
    "TF_VAR_keycloak_postgres_password" = var.keycloak_postgres_password,
    "TF_VAR_app_password"               = var.app_password,
    "TF_VAR_app_email"                  = var.app_email,
    "TF_VAR_redis_password"             = var.redis_password,
    "TF_VAR_redis_host"                 = var.redis_host,
    "TF_VAR_redis_port"                 = var.redis_port,
    "TF_VAR_ui_base_url"                = var.ui_base_url,
    "TF_VAR_ui_feature_project_select"  = var.ui_feature_project_select
  }
}
