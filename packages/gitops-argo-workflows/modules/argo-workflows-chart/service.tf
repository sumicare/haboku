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


resource "kubernetes_service" "release_name_argo_workflows_workflow_controller" {
  metadata {
    name      = "release-name-argo-workflows-workflow-controller"
    namespace = "argo-workflows"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "app.kubernetes.io/version"    = "v3.7.3"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  spec {
    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "9090"
    }

    port {
      name        = "telemetry"
      protocol    = "TCP"
      port        = 8081
      target_port = "8081"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argo-workflows-workflow-controller"
    }

    type             = "ClusterIP"
    session_affinity = "None"
  }
}

resource "kubernetes_service" "release_name_argo_workflows_server" {
  metadata {
    name      = "release-name-argo-workflows-server"
    namespace = "argo-workflows"

    labels = {
      app                            = "server"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-server"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "app.kubernetes.io/version"    = "v3.7.3"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  spec {
    port {
      port        = 2746
      target_port = "2746"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "argo-workflows-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
  }
}

