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


resource "kubernetes_deployment" "release_name_grafana" {
  metadata {
    name      = "release-name-grafana"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "grafana"
          "app.kubernetes.io/version"  = "12.2.1"
          "helm.sh/chart"              = "grafana-10.1.4"
        }

        annotations = {
          "checksum/config"                         = "c5eaae11aac698b0a43a4362bbdc79a8df073893c0274037f872b75568f9fe07"
          "checksum/dashboards-json-config"         = "aea989c253e9bc7a5b90bf31698731ac344483fcaac0fd7a396dcacbd3a43347"
          "checksum/sc-dashboard-provider-config"   = "e70bf6a851099d385178a76de9757bb0bef8299da6d8443602590e44f05fdf24"
          "kubectl.kubernetes.io/default-container" = "grafana"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-grafana"
          }
        }

        volume {
          name = "config-secret"

          secret {
            secret_name = "release-name-grafana-config-secret"
          }
        }

        volume {
          name = "dashboards-default"

          config_map {
            name = "release-name-grafana-dashboards-default"
          }
        }

        volume {
          name = "storage"

          persistent_volume_claim {
            claim_name = "release-name-grafana"
          }
        }

        volume {
          name = "secret-files"

          secret {
            secret_name = "grafana-secret-files"
          }
        }

        init_container {
          name    = "init-chown-data"
          image   = "docker.io/library/busybox:1.31.1"
          command = ["chown", "-R", "472:472", "/var/lib/grafana"]

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/grafana"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["CHOWN"]
              drop = ["ALL"]
            }

            run_as_user = 0

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        init_container {
          name    = "download-dashboards"
          image   = "docker.io/curlimages/curl:8.9.1"
          command = ["/bin/sh"]
          args    = ["-c", "mkdir -p /var/lib/grafana/dashboards/default && /bin/sh -x /etc/grafana/download_dashboards.sh"]

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/download_dashboards.sh"
            sub_path   = "download_dashboards.sh"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "secret-files"
            read_only  = true
            mount_path = "/etc/secrets"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "grafana"
          image = "docker.io/grafana/grafana:12.2.1"

          port {
            name           = "grafana"
            container_port = 3000
            protocol       = "TCP"
          }

          port {
            name           = "gossip-tcp"
            container_port = 9094
            protocol       = "TCP"
          }

          port {
            name           = "gossip-udp"
            container_port = 9094
            protocol       = "UDP"
          }

          port {
            name           = "profiling"
            container_port = 6060
            protocol       = "TCP"
          }

          env {
            name = "POD_IP"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "GF_SECURITY_ADMIN_USER"

            value_from {
              secret_key_ref {
                name = "grafana-admin-secret"
                key  = "admin-user"
              }
            }
          }

          env {
            name = "GF_SECURITY_ADMIN_PASSWORD"

            value_from {
              secret_key_ref {
                name = "grafana-admin-secret"
                key  = "admin-password"
              }
            }
          }

          env {
            name  = "GF_PATHS_DATA"
            value = "/var/lib/grafana/"
          }

          env {
            name  = "GF_PATHS_LOGS"
            value = "/var/log/grafana"
          }

          env {
            name  = "GF_PATHS_PLUGINS"
            value = "/var/lib/grafana/plugins"
          }

          env {
            name  = "GF_PATHS_PROVISIONING"
            value = "/etc/grafana/provisioning"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/grafana.ini"
            sub_path   = "grafana.ini"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "dashboards-default"
            mount_path = "/var/lib/grafana/dashboards/default/some-dashboard.json"
            sub_path   = "some-dashboard.json"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/datasources/datasources.yaml"
            sub_path   = "datasources.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/notifiers/notifiers.yaml"
            sub_path   = "notifiers.yaml"
          }

          volume_mount {
            name       = "config-secret"
            mount_path = "/etc/grafana/provisioning/alerting/contactpoints.yaml"
            sub_path   = "contactpoints.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/mutetimes.yaml"
            sub_path   = "mutetimes.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/policies.yaml"
            sub_path   = "policies.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/rules.yaml"
            sub_path   = "rules.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/templates.yaml"
            sub_path   = "templates.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/dashboards/dashboardproviders.yaml"
            sub_path   = "dashboardproviders.yaml"
          }

          volume_mount {
            name       = "secret-files"
            read_only  = true
            mount_path = "/etc/secrets"
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = "3000"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 30
            failure_threshold     = 10
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = "3000"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        service_account_name            = "release-name-grafana"
        automount_service_account_token = true

        security_context {
          run_as_user     = 472
          run_as_group    = 472
          run_as_non_root = true
          fs_group        = 472
        }

        enable_service_links = true
      }
    }

    strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

