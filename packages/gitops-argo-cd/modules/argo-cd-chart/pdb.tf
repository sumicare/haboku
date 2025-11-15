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


resource "kubernetes_pod_disruption_budget" "release_name_argocd_application_controller" {
  metadata {
    name      = "release-name-argocd-application-controller"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/component"  = "application-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argocd-application-controller"
      "app.kubernetes.io/part-of"    = "argocd"
      "app.kubernetes.io/version"    = "v3.1.8"
      "helm.sh/chart"                = "argo-cd-8.6.4"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argocd-application-controller"
      }
    }

    max_unavailable = "50%"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_argocd_applicationset_controller" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argocd-applicationset-controller"
      }
    }

    max_unavailable = "50%"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_argocd_notifications_controller" {
  metadata {
    name      = "release-name-argocd-notifications-controller"
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

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argocd-notifications-controller"
      }
    }

    max_unavailable = "50%"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_argocd_repo_server" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argocd-repo-server"
      }
    }

    max_unavailable = "50%"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_argocd_server" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argocd-server"
      }
    }

    max_unavailable = "50%"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_argocd_dex_server" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argocd-dex-server"
      }
    }

    max_unavailable = "50%"
  }
}

