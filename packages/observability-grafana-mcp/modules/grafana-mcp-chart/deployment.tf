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


resource "kubernetes_deployment" "release_name_grafana_mcp" {
  metadata {
    name      = "release-name-grafana-mcp"
    namespace = "grafana-mcp"

    labels = {
      "app.kubernetes.io/component" = "mcp-server"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "grafana-mcp"
      "app.kubernetes.io/version"   = "0.7.8"
      "helm.sh/chart"               = "grafana-mcp-0.2.1"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "mcp-server"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "grafana-mcp"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "mcp-server"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "grafana-mcp"
        }
      }

      spec {
        container {
          name  = "mcp-grafana"
          image = "docker.io/grafana/mcp-grafana:0.7.8"

          port {
            name           = "mcp-http"
            container_port = 8000
            protocol       = "TCP"
          }

          env {
            name  = "GRAFANA_URL"
            value = "http://grafana:3000"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        service_account_name            = "release-name-grafana-mcp"
        automount_service_account_token = true

        security_context {
          run_as_user     = 1000
          run_as_group    = 1000
          run_as_non_root = true
          fs_group        = 1000
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "25%"
        max_surge       = "75%"
      }
    }

    revision_history_limit = 10
  }
}

