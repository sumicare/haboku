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


resource "kubernetes_deployment" "release_name_argo_events_controller_manager" {
  metadata {
    name      = "release-name-argo-events-controller-manager"
    namespace = "argo-events"

    labels = {
      "app.kubernetes.io/component"  = "controller-manager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-controller-manager"
      "app.kubernetes.io/part-of"    = "argo-events"
      "app.kubernetes.io/version"    = "v1.9.7"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argo-events-controller-manager"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "controller-manager"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "argo-events-controller-manager"
          "app.kubernetes.io/part-of"    = "argo-events"
          "app.kubernetes.io/version"    = "v1.9.7"
          "helm.sh/chart"                = "argo-events-2.4.16"
        }

        annotations = {
          "checksum/config" = "a6718f932242092d569378a392bfe7b23f4e00036e7177f749926b9c50df3dbb"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-argo-events-controller-manager"
          }
        }

        container {
          name  = "controller-manager"
          image = "quay.io/argoproj/argo-events:v1.9.7"
          args  = ["controller"]

          port {
            name           = "metrics"
            container_port = 7777
            protocol       = "TCP"
          }

          port {
            name           = "probe"
            container_port = 8081
            protocol       = "TCP"
          }

          env {
            name  = "ARGO_EVENTS_IMAGE"
            value = "quay.io/argoproj/argo-events:v1.9.7"
          }

          env {
            name = "NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/argo-events"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "probe"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/readyz"
              port = "probe"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "release-name-argo-events-controller-manager"
      }
    }

    revision_history_limit = 5
  }
}

resource "kubernetes_deployment" "events_webhook" {
  metadata {
    name      = "events-webhook"
    namespace = "argo-events"

    labels = {
      "app.kubernetes.io/component"  = "events-webhook"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-events-webhook"
      "app.kubernetes.io/part-of"    = "argo-events"
      "app.kubernetes.io/version"    = "v1.9.7"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argo-events-events-webhook"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "events-webhook"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "argo-events-events-webhook"
          "app.kubernetes.io/part-of"    = "argo-events"
          "app.kubernetes.io/version"    = "v1.9.7"
          "helm.sh/chart"                = "argo-events-2.4.16"
        }
      }

      spec {
        container {
          name  = "events-webhook"
          image = "quay.io/argoproj/argo-events:v1.9.7"
          args  = ["webhook-service"]

          port {
            name           = "webhook"
            container_port = 443
            protocol       = "TCP"
          }

          env {
            name = "NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "PORT"
            value = "443"
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            tcp_socket {
              port = "webhook"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = "webhook"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "release-name-argo-events-events-webhook"

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "DoNotSchedule"

          label_selector {
            match_labels = {
              "app.kubernetes.io/instance" = "release-name"
              "app.kubernetes.io/name"     = "argo-events-events-webhook"
            }
          }
        }
      }
    }

    revision_history_limit = 5
  }
}

