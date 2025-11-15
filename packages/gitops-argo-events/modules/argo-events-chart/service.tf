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


resource "kubernetes_service" "release_name_argo_events_controller_manager_metrics" {
  metadata {
    name      = "release-name-argo-events-controller-manager-metrics"
    namespace = "argo-events"

    labels = {
      "app.kubernetes.io/component"  = "controller-manager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-controller-manager-metrics"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  spec {
    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 8082
      target_port = "metrics"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argo-events-controller-manager"
    }
  }
}

resource "kubernetes_service" "events_webhook" {
  metadata {
    name      = "events-webhook"
    namespace = "argo-events"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-events-webhook"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  spec {
    port {
      port        = 443
      target_port = "webhook"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argo-events-events-webhook"
    }
  }
}

