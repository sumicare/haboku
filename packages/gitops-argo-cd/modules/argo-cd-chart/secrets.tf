
resource "kubernetes_secret" "argocd_dex_server_tls" {
  metadata {
    name      = "argocd-dex-server-tls"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "dex-server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-dex-server-tls"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "argocd_notifications_secret" {
  metadata {
    name      = "argocd-notifications-secret"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "notifications-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-notifications-controller"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  type = "Opaque"
}

resource "kubernetes_secret" "argocd_repo_server_tls" {
  metadata {
    name      = "argocd-repo-server-tls"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "repo-server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-repo-server-tls"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "argocd_secret" {
  metadata {
    name      = "argocd-secret"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-secret"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  type = "Opaque"
}

resource "kubernetes_secret" "argocd_repo_private_repo" {
  metadata {
    name      = "argocd-repo-private-repo"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/instance"     = "release-name"
      "app.kubernetes.io/managed-by"   = "Helm"
      "app.kubernetes.io/part-of"      = "argocd"
      "app.kubernetes.io/version"      = "v3.1.8"
      "argocd.argoproj.io/secret-type" = "repository"
      "helm.sh/chart"                  = "argo-cd-8.6.4"
    }
  }

  data = {
    url = "https://github.com/argoproj/private-repo"
  }
}