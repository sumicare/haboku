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


resource "kubernetes_service_account" "ballista_scheduler" {
  metadata {
    name      = "ballista-scheduler"
    namespace = "ballista"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }
}

resource "kubernetes_service_account" "ballista_executor" {
  metadata {
    name      = "ballista-executor"
    namespace = "ballista"

    labels = {
      app                            = "server"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-server"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }
}

