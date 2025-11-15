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


resource "kubernetes_deployment" "ome_controller_manager" {
  metadata {
    name      = "ome-controller-manager"
    namespace = "ome"

    labels = {
      control-plane             = "ome-controller-manager"
      "controller-tools.k8s.io" = "1.0"
    }

    annotations = {
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        control-plane             = "ome-controller-manager"
        "controller-tools.k8s.io" = "1.0"
      }
    }

    template {
      metadata {
        labels = {
          control-plane             = "ome-controller-manager"
          "controller-tools.k8s.io" = "1.0"
          logging-forward           = "enabled"
        }

        annotations = {
          "kubectl.kubernetes.io/default-container" = "manager"
          "prometheus.io/path"                      = "/metrics"
          "prometheus.io/port"                      = "8080"
          "prometheus.io/scrape"                    = "true"
        }
      }

      spec {
        volume {
          name = "cert"

          secret {
            secret_name  = "ome-webhook-server-cert"
            default_mode = "0644"
          }
        }

        container {
          name    = "manager"
          image   = "ghcr.io/moirai-internal/ome-manager:v0.1.2"
          command = ["/manager"]
          args    = ["--metrics-bind-address=:8080", "--leader-elect", "--webhook", "--zap-encoder=console"]

          port {
            name           = "webhook-server"
            container_port = 9443
            protocol       = "TCP"
          }

          port {
            name           = "metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "SECRET_NAME"
            value = "ome-webhook-server-cert"
          }

          resources {
            limits = {
              cpu    = "2"
              memory = "4Gi"
            }

            requests = {
              cpu    = "2"
              memory = "4Gi"
            }
          }

          volume_mount {
            name       = "cert"
            read_only  = true
            mount_path = "/tmp/k8s-webhook-server/serving-certs"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8081"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = "/readyz"
              port = "8081"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
            period_seconds        = 5
            failure_threshold     = 10
          }

          image_pull_policy = "IfNotPresent"
        }

        termination_grace_period_seconds = 10
        service_account_name             = "ome-controller-manager"
      }
    }
  }
}

