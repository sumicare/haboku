/*
   Copyright 2025 Sumicare

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/


resource "kubernetes_service" "release_name_argocd_application_controller_metrics" {
  metadata {
    name      = "release-name-argocd-application-controller-metrics"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "application-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-metrics"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8082
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-application-controller"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_argocd_applicationset_controller_metrics" {
  metadata {
    name      = "release-name-argocd-applicationset-controller-metrics"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "applicationset-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-metrics"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-applicationset-controller"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_argocd_applicationset_controller" {
  metadata {
    name      = "release-name-argocd-applicationset-controller"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "applicationset-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-applicationset-controller"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http-webhook"
      port        = 7000
      target_port = "webhook"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-applicationset-controller"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_argocd_notifications_controller_metrics" {
  metadata {
    name      = "release-name-argocd-notifications-controller-metrics"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "notifications-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-metrics"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 9001
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-notifications-controller"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_argocd_repo_server_metrics" {
  metadata {
    name      = "release-name-argocd-repo-server-metrics"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "repo-server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-repo-server-metrics"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8084
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-repo-server"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_argocd_repo_server" {
  metadata {
    name      = "release-name-argocd-repo-server"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "repo-server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-repo-server"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "tcp-repo-server"
      protocol    = "TCP"
      port        = 8081
      target_port = "repo-server"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-repo-server"
    }
  }
}

resource "kubernetes_service" "release_name_argocd_server_metrics" {
  metadata {
    name      = "release-name-argocd-server-metrics"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-server-metrics"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8083
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-server"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_argocd_server" {
  metadata {
    name      = "release-name-argocd-server"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-server"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "8080"
    }

    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = "8080"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
  }
}

resource "kubernetes_service" "release_name_argocd_dex_server" {
  metadata {
    name      = "release-name-argocd-dex-server"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "dex-server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-dex-server"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 5556
      target_port = "http"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 5557
      target_port = "grpc"
    }

    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 5558
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argocd-dex-server"
    }
  }
}

