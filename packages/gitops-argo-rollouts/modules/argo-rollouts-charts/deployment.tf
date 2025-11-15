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


resource "kubernetes_deployment" "release_name_argo_rollouts" {
  metadata {
    name      = "release-name-argo-rollouts"
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
    replicas = 2

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "rollouts-controller"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "argo-rollouts"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "rollouts-controller"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "argo-rollouts"
        }

        annotations = {
          "checksum/cm" = "83541084ea7f5d836b79cd81032f27001b3e501e0e4e9271122f708ad7ce229a"
        }
      }

      spec {
        volume {
          name      = "plugin-bin"
          empty_dir = {}
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "argo-rollouts"
          image = "quay.io/argoproj/argo-rollouts:v1.8.3"
          args  = ["--healthzPort=8080", "--metricsport=8090", "--loglevel=info", "--logformat=text", "--kloglevel=0", "--leader-elect"]

          port {
            name           = "metrics"
            container_port = 8090
          }

          port {
            name           = "healthz"
            container_port = 8080
          }

          volume_mount {
            name       = "plugin-bin"
            mount_path = "/home/argo-rollouts/plugin-bin"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 10
            period_seconds        = 20
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/metrics"
              port = "metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 4
            period_seconds        = 5
            success_threshold     = 1
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-argo-rollouts"

        security_context {
          run_as_non_root = true
        }
      }
    }

    strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

