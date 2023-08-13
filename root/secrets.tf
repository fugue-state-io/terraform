
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
    name = "fugue-state-argo-workflows-sso-argocd"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/part-of" = "argocd"
    }
  }
  data = {
    "client-secret" = var.argo_workflows_client_secret
    "client-id" = var.argo_workflows_client_id
  }
}

resource "kubernetes_secret" "argo-workflows-sso-argoworkflows" {
  depends_on = [ kubernetes_namespace.argo-workflows ]
  metadata {
    name = "fugue-state-argo-workflows-sso-argoworkflows"
    namespace = "argo-workflows"
    labels = {
      "app.kubernetes.io/part-of" = "argo-workflows"
    }
  }
  data = {
    "client-secret" = var.argo_workflows_client_secret
    "client-id" = var.argo_workflows_client_id
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

resource "kubernetes_secret" "keycloak-secret" {
  depends_on = [ kubernetes_namespace.keycloak ]
  metadata {
    name = "keycloak-secret"
    namespace = "keycloak"
  }
  data = {
    "keycloak-user" = var.keycloak_user
    "keycloak-password" = var.keycloak_password
    "external-db" = digitalocean_kubernetes_cluster.fugue-state-cluster.name
    "external-db-host" = digitalocean_database_cluster.postgres.host
    "external-db-port" = digitalocean_database_cluster.postgres.port
    "external-db-user" = digitalocean_database_user.keycloak-db-user.name
    "external-db-password" = digitalocean_database_user.keycloak-db-user.password
    "USERS_REALM" = var.users_realm
    "USERS_REALM_PUBLIC_KEY" = var.users_realm_public_key
    "USERS_REALM_PRIVATE_KEY" = var.users_realm_private_key
    "USERS_REALM_BASEURL" = var.users_realm_baseurl
    "USERS_REALM_USERNAME" = var.users_realm_username
    "USERS_REALM_USER_PASSWORD" = var.users_realm_user_password
  }
}