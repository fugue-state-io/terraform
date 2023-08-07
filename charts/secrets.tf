
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
  depends_on = [ kubernetes_namespace.ui ]
  metadata {
    name = "docker-cfg"
    namespace = "ui"
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
    "keycloak-user" = var.keycloak_user
    "keycloak-password" = var.keycloak_password
    "external-db" = var.keycloak-db.name
    "external-db-host" = var.postgres.private_host
    "external-db-port" = var.postgres.port
    "external-db-user" = var.keycloak-db-user.name
    "external-db-password" = var.keycloak-db-user.password
  }
}

resource "kubernetes_secret" "keycloak-realm-secret" {
  depends_on = [ kubernetes_namespace.keycloak ]
  metadata {
    name = "keycloak-realm-secret"
    namespace = "keycloak"
  }
  data = {
    "USERS_REALM" = var.users_realm
    "USERS_REALM_PUBLIC_KEY" = var.users_realm_public_key
    "USERS_REALM_PRIVATE_KEY" = var.users_realm_private_key
    "USERS_REALM_BASEURL" = var.users_realm_baseurl
    "USERS_REALM_USERNAME" = var.users_realm_username
    "USERS_REALM_USER_PASSWORD" = var.users_realm_user_password
  }
}