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


resource "kubernetes_deployment" "dex_server" {
  metadata {
    name      = "${local.app_name}-dex-server"
    namespace = var.namespace
    labels    = local.dex_server_labels
  }

  spec {
    replicas = var.dex_server_replicas

    selector {
      match_labels = local.dex_server_selector_labels
    }

    template {
      metadata {
        labels = local.dex_server_labels

        annotations = {
          "checksum/cm"             = "957cbd1078974876f8f1193b5a6a64406be646f0a6b0dc40ff3ea50ac725227e"
          "checksum/cmd-params"     = "673d2166eac30d0adb254fe1becc81d1caa2839ac8659ffe13a7a8c727c3e0c2"
          "checksum/dex-server-tls" = "3c3a985627bb3bc75d155b82f93f39d0e38667271d22637ec01c5eb84719fd24"
        }
      }

      spec {
        volume {
          name = "static-files"
        }

        volume {
          name = "dexconfig"
        }

        volume {
          name = "argocd-dex-server-tls"

          secret {
            secret_name = "argocd-dex-server-tls"

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

        init_container {
          name    = "copyutil"
          image   = "${var.argocd_image}:${var.argocd_version}"
          command = ["/bin/cp", "-n", "/usr/local/bin/argocd", "/shared/argocd-dex"]

          volume_mount {
            name       = "static-files"
            mount_path = "/shared"
          }

          volume_mount {
            name       = "dexconfig"
            mount_path = "/tmp"
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

        container {
          name    = "dex-server"
          image   = "ghcr.io/dexidp/dex:v2.44.0"
          command = ["/shared/argocd-dex"]
          args    = ["rundex"]

          port {
            name           = "http"
            container_port = 5556
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 5557
            protocol       = "TCP"
          }

          port {
            name           = "metrics"
            container_port = 5558
            protocol       = "TCP"
          }

          env {
            name = "ARGOCD_DEX_SERVER_LOGFORMAT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "dexserver.log.format"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_DEX_SERVER_LOGLEVEL"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "dexserver.log.level"
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
            name = "ARGOCD_DEX_SERVER_DISABLE_TLS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "dexserver.disable.tls"
                optional = true
              }
            }
          }

          volume_mount {
            name       = "static-files"
            mount_path = "/shared"
          }

          volume_mount {
            name       = "dexconfig"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "argocd-dex-server-tls"
            mount_path = "/tls"
          }

          liveness_probe {
            http_get {
              path   = "/healthz/live"
              port   = "metrics"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/healthz/ready"
              port   = "metrics"
              scheme = "HTTP"
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

        service_account_name            = "argocd-dex-server"
        automount_service_account_token = true

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/name" = "argocd-dex-server"
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
              "app.kubernetes.io/name"     = "argocd-dex-server"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit = 3
  }
}
