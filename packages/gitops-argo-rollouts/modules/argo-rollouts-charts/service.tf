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


resource "kubernetes_service" "release_name_argo_rollouts_metrics" {
  metadata {
    name      = "release-name-argo-rollouts-metrics"
    namespace = "argo-rollouts"

    labels = {
      "app.kubernetes.io/component"  = "rollouts-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-rollouts"
      "app.kubernetes.io/part-of"    = "argo-rollouts"
      "app.kubernetes.io/version"    = "v1.8.3"
      "helm.sh/chart"                = "argo-rollouts-2.40.5"
    }
  }

  spec {
    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 8090
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/component" = "rollouts-controller"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "argo-rollouts"
    }
  }
}

resource "kubernetes_service" "release_name_argo_rollouts_dashboard" {
  metadata {
    name      = "release-name-argo-rollouts-dashboard"
    namespace = "argo-rollouts"

    labels = {
      "app.kubernetes.io/component"  = "rollouts-dashboard"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-rollouts"
      "app.kubernetes.io/part-of"    = "argo-rollouts"
      "app.kubernetes.io/version"    = "v1.8.3"
      "helm.sh/chart"                = "argo-rollouts-2.40.5"
    }
  }

  spec {
    port {
      name        = "dashboard"
      protocol    = "TCP"
      port        = 3100
      target_port = "dashboard"
    }

    selector = {
      "app.kubernetes.io/component" = "rollouts-dashboard"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "argo-rollouts"
    }

    type = "ClusterIP"
  }
}

