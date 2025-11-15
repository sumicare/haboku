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


resource "kubernetes_service_account" "release_name_argo_events_controller_manager" {
  metadata {
    name      = "release-name-argo-events-controller-manager"
    namespace = "argo-events"

    labels = {
      "app.kubernetes.io/component"  = "controller-manager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-controller-manager"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_service_account" "release_name_argo_events_events_webhook" {
  metadata {
    name      = "release-name-argo-events-events-webhook"
    namespace = "argo-events"

    labels = {
      "app.kubernetes.io/component"  = "events-webhook"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-events-webhook"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  automount_service_account_token = true
}

