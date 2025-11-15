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


resource "kubernetes_deployment" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "alloy"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "alloy"
        }

        annotations = {
          "kubectl.kubernetes.io/default-container" = "alloy"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-alloy"
          }
        }

        container {
          name  = "alloy"
          image = "docker.io/grafana/alloy:v1.11.3"
          args  = ["run", "/etc/alloy/config.alloy", "--storage.path=/tmp/alloy", "--server.http.listen-addr=0.0.0.0:12345", "--server.http.ui-path-prefix=/", "--cluster.enabled=true", "--cluster.join-addresses=release-name-alloy-cluster", "--stability.level=generally-available"]

          port {
            name           = "http-metrics"
            container_port = 12345
          }

          env {
            name  = "ALLOY_DEPLOY_MODE"
            value = "helm"
          }

          env {
            name = "HOSTNAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }

            requests = {
              cpu    = "10m"
              memory = "50Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/alloy"
          }

          readiness_probe {
            http_get {
              path   = "/-/ready"
              port   = "12345"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "config-reloader"
          image = "quay.io/prometheus-operator/prometheus-config-reloader:v0.81.0"
          args  = ["--watched-dir=/etc/alloy", "--reload-url=http://localhost:12345/-/reload"]

          resources {
            requests = {
              cpu    = "10m"
              memory = "50Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/alloy"
          }
        }

        dns_policy           = "ClusterFirst"
        service_account_name = "release-name-alloy"
      }
    }

    min_ready_seconds = 10
  }
}

