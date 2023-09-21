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

resource "kubernetes_secret" "docker-cfg" {
  depends_on = [ kubernetes_namespace.ui ]
  metadata {
    name = "docker-cfg"
    namespace = "ui"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.fugue-state-registry-credentials.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}