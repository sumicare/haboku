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


resource "kubernetes_daemonset" "ome_model_agent_daemonset" {
  metadata {
    name      = "ome-model-agent-daemonset"
    namespace = "ome"
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ome-model-agent-daemonset"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ome-model-agent-daemonset"
          logging-forward               = "enabled"
        }

        annotations = {
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/port"   = "8080"
          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        volume {
          name = "host-models"

          host_path {
            path = "/mnt/data/models"
            type = "DirectoryOrCreate"
          }
        }

        container {
          name  = "model-agent"
          image = "ghcr.io/moirai-internal/model-agent:v0.1.2"
          args  = ["--models-root-dir", "/mnt/data/models", "--num-download-worker", "2"]

          port {
            name           = "metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          env {
            name = "NODE_NAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          resources {
            limits = {
              cpu    = "10"
              memory = "100Gi"
            }

            requests = {
              cpu    = "10"
              memory = "100Gi"
            }
          }

          volume_mount {
            name       = "host-models"
            mount_path = "/mnt/data/models"
          }

          liveness_probe {
            http_get {
              path = "/livez"
              port = "8080"
            }

            period_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }

            period_seconds = 10
          }

          startup_probe {
            http_get {
              path = "/livez"
              port = "8080"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 5
          }

          image_pull_policy = "Always"
        }

        service_account_name = "ome-model-agent"

        toleration {
          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        priority_class_name = "system-node-critical"
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }
}

