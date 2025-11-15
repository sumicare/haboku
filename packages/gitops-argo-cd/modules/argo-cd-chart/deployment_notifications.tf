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



resource "kubernetes_deployment" "notifications_controller" {
  metadata {
    name      = "${local.app_name}-notifications-controller"
    namespace = var.namespace
    labels    = local.notifications_controller_labels
  }

  spec {
    replicas = var.notifications_controller_replicas

    selector {
      match_labels = local.notifications_controller_selector_labels
    }

    template {
      metadata {
        labels = local.notifications_controller_labels
      }

      spec {
        volume {
          name = "tls-certs"

          config_map {
            name = "argocd-tls-certs-cm"
          }
        }

        volume {
          name = "argocd-repo-server-tls"

          secret {
            secret_name = "argocd-repo-server-tls"

            items {
              key  = "tls.crt"
              path = "tls.crt"
            }

            items {
              key  = "tls.key"
              path = "tls.key"
            }

            items {
              key  = "ca.crt"
              path = "ca.crt"
            }

            optional = true
          }
        }

        container {
          name        = "notifications-controller"
          image       = "${var.argocd_image}:${var.argocd_version}"
          args        = ["/usr/local/bin/argocd-notifications", "--metrics-port=9001", "--namespace=${var.namespace}", "--argocd-repo-server=${local.app_name}-repo-server:8081", "--secret-name=argocd-notifications-secret"]
          working_dir = "/app"

          port {
            name           = "metrics"
            container_port = 9001
            protocol       = "TCP"
          }

          env {
            name = "ARGOCD_NOTIFICATIONS_CONTROLLER_LOGLEVEL"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "notificationscontroller.log.level"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_NOTIFICATIONS_CONTROLLER_LOGFORMAT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "notificationscontroller.log.format"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_LOG_FORMAT_TIMESTAMP"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "log.format.timestamp"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_NAMESPACES"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "application.namespaces"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_NOTIFICATION_CONTROLLER_SELF_SERVICE_NOTIFICATION_ENABLED"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "notificationscontroller.selfservice.enabled"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_NOTIFICATION_CONTROLLER_REPO_SERVER_PLAINTEXT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "notificationscontroller.repo.server.plaintext"
                optional = true
              }
            }
          }

          volume_mount {
            name       = "tls-certs"
            mount_path = "/app/config/tls"
          }

          volume_mount {
            name       = "argocd-repo-server-tls"
            mount_path = "/app/config/reposerver/tls"
          }

          liveness_probe {
            tcp_socket {
              port = "metrics"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = "metrics"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        termination_grace_period_seconds = 30
        dns_policy                       = "ClusterFirst"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name            = "argocd-notifications-controller"
        automount_service_account_token = true

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/name" = "argocd-notifications-controller"
                  }
                }

                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "DoNotSchedule"

          label_selector {
            match_labels = {
              "app.kubernetes.io/instance" = "release-name"
              "app.kubernetes.io/name"     = "argocd-notifications-controller"
            }
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }

    revision_history_limit = 3
  }
}
