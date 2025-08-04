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
    "AUTH_URL"                              = var.ui_auth_url
    "AUTH_URL_INTERNAL"                     = var.ui_auth_url
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
    "DATABASE_URL"                          = "postgresql://${digitalocean_database_user.fugue-state-user.name}:${digitalocean_database_user.fugue-state-user.password}@${digitalocean_database_cluster.postgres.private_host}:${digitalocean_database_cluster.postgres.port}/${digitalocean_database_db.fugue-state-db.name}?sslmode=require"
    "EMAIL_PROVIDER"                        = var.email_provider
    "EMAIL_FROM"                            = var.email_from
    "EMAIL_FROM_NAME"                       = var.email_from_name
    "SMTP_HOST"                             = var.smtp_host
    "SMTP_PORT"                             = var.smtp_port
    "SMTP_SECURE"                           = var.smtp_secure
    "EMAIL_USER"                            = var.smtp_user
    "EMAIL_PASSWORD"                        = var.smtp_password
    "SENDGRID_API_KEY"                      = var.sendgrid_api_key
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
# resource "kubernetes_secret" "processing-s3-access-secret" {
#   depends_on = [kubernetes_namespace.processing]
#   metadata {
#     name      = "s3-access-secret"
#     namespace = "processing"
#     labels = {
#       "app.kubernetes.io/part-of"    = "processing"
#       "app.kubernetes.io/managed-by" = "Helm"
#     }
#     annotations = {
#       "meta.helm.sh/release-namespace" = "processing"
#       "meta.helm.sh/release-name"      = "processing"
#     }
#   }
#   data = {
#     "accessKey" = var.fugue_state_cdn_access_key
#     "secretKey" = var.fugue_state_cdn_secret_key
#   }
# }
resource "kubernetes_secret" "ssh_public_key" {
  depends_on = [kubernetes_namespace.jump]
  metadata {
    name      = "ssh-public-keys"
    namespace = "jump"
  }
  data = {
    "id_rsa.pub" = filebase64("${path.cwd}/.sensitive/id_rsa.pub")
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
resource "kubernetes_secret" "tf-backup" {
  metadata {
    name      = "tf-secrets"
    namespace = "tf-backup"
  }
  data = {
    "DIGITALOCEAN_TOKEN"                  = var.do_token,
    "DO_SPACES_ACCESS_KEY"                = var.do_spaces_access_id,
    "DO_SPACES_SECRET_KEY"                = var.do_spaces_secret_key,
    "TF_VAR_do_token"                     = var.do_token,
    "TF_VAR_oauth_client_id"              = var.oauth_client_id,
    "TF_VAR_argocd_webhook_secret"        = var.argocd_webhook_secret,
    "TF_VAR_oauth_client_secret"          = var.oauth_client_secret,
    "TF_VAR_do_spaces_access_id"          = var.do_spaces_access_id,
    "TF_VAR_do_spaces_secret_key"         = var.do_spaces_secret_key,
    "TF_VAR_do_cdn_spaces_access_id"      = var.do_cdn_spaces_access_id,
    "TF_VAR_do_cdn_spaces_secret_key"     = var.do_cdn_spaces_secret_key,
    "TF_VAR_github_app_id"                = var.github_app_id,
    "TF_VAR_github_app_installation_id"   = var.github_app_installation_id,
    "TF_VAR_github_repo_url"              = var.github_repo_url,
    "TF_VAR_github_app_client_id"         = var.github_app_client_id,
    "TF_VAR_github_app_client_secret"     = var.github_app_client_secret,
    "TF_VAR_github_webhook_secret"        = var.github_webhook_secret,
    "TF_VAR_fugue_state_bucket"           = var.fugue_state_bucket,
    "TF_VAR_app_password"                 = var.app_password,
    "TF_VAR_app_email"                    = var.app_email,
    "TF_VAR_redis_password"               = var.redis_password,
    "TF_VAR_redis_host"                   = var.redis_host,
    "TF_VAR_redis_port"                   = var.redis_port,
    "TF_VAR_ui_base_url"                  = var.ui_base_url,
    "TF_VAR_ui_feature_project_select"    = var.ui_feature_project_select,
    "TF_VAR_ui_auth_url"                  = var.ui_auth_url,
    "TF_VAR_fugue_state_cdn_access_key"   = var.fugue_state_cdn_access_key,
    "TF_VAR_fugue_state_cdn_secret_key"   = var.fugue_state_cdn_secret_key,
    "TF_VAR_argo_workflows_client_id"     = var.argo_workflows_client_id,
    "TF_VAR_argo_workflows_client_secret" = var.argo_workflows_client_secret
  }
}
