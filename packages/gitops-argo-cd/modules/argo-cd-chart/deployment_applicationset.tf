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


resource "kubernetes_deployment" "applicationset_controller" {
  metadata {
    name      = "${local.app_name}-applicationset-controller"
    namespace = var.namespace
    labels    = local.applicationset_controller_labels
  }

  spec {
    replicas = var.applicationset_controller_replicas

    selector {
      match_labels = local.applicationset_controller_selector_labels
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    template {
      metadata {
        labels = local.applicationset_controller_labels

        annotations = {
          "checksum/cmd-params" = "673d2166eac30d0adb254fe1becc81d1caa2839ac8659ffe13a7a8c727c3e0c2"
        }
      }

      spec {
        volume {
          name = "ssh-known-hosts"

          config_map {
            name = "argocd-ssh-known-hosts-cm"
          }
        }

        volume {
          name = "tls-certs"

          config_map {
            name = "argocd-tls-certs-cm"
          }
        }

        volume {
          name = "gpg-keys"

          config_map {
            name = "argocd-gpg-keys-cm"
          }
        }

        volume {
          name = "gpg-keyring"
          # empty_dir = {}
        }

        volume {
          name = "tmp"
          # empty_dir = {}
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
          name  = "applicationset-controller"
          image = "${var.argocd_image}:${var.argocd_version}"
          args  = ["/usr/local/bin/argocd-applicationset-controller", "--metrics-addr=:8080", "--probe-addr=:8081", "--webhook-addr=:7000"]

          port {
            name           = "metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "probe"
            container_port = 8081
            protocol       = "TCP"
          }

          port {
            name           = "webhook"
            container_port = 7000
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
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_GLOBAL_PRESERVED_ANNOTATIONS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.global.preserved.annotations"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_GLOBAL_PRESERVED_LABELS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.global.preserved.labels"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_LEADER_ELECTION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.leader.election"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "repo.server"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_POLICY"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.policy"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_POLICY_OVERRIDE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.policy.override"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_DEBUG"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.debug"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_LOGFORMAT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.log.format"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_LOGLEVEL"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.log.level"
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
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_DRY_RUN"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.dryrun"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_GIT_MODULES_ENABLED"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.git.submodule"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_PROGRESSIVE_SYNCS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.progressive.syncs"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_TOKENREF_STRICT_MODE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.tokenref.strict.mode"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_NEW_GIT_FILE_GLOBBING"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.new.git.file.globbing"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER_PLAINTEXT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.repo.server.plaintext"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER_STRICT_TLS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.repo.server.strict.tls"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_REPO_SERVER_TIMEOUT_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.repo.server.timeout.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_CONCURRENT_RECONCILIATIONS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.concurrent.reconciliations.max"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_NAMESPACES"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.namespaces"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_SCM_ROOT_CA_PATH"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.scm.root.ca.path"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_ALLOWED_SCM_PROVIDERS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.allowed.scm.providers"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_SCM_PROVIDERS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.scm.providers"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_GITHUB_API_METRICS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.enable.github.api.metrics"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_WEBHOOK_PARALLELISM_LIMIT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.webhook.parallelism.limit"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_REQUEUE_AFTER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.requeue.after"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATIONSET_CONTROLLER_MAX_RESOURCES_STATUS_COUNT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "applicationsetcontroller.status.max.resources.count"
                optional = true
              }
            }
          }

          volume_mount {
            name       = "ssh-known-hosts"
            mount_path = "/app/config/ssh"
          }

          volume_mount {
            name       = "tls-certs"
            mount_path = "/app/config/tls"
          }

          volume_mount {
            name       = "gpg-keys"
            mount_path = "/app/config/gpg/source"
          }

          volume_mount {
            name       = "gpg-keyring"
            mount_path = "/app/config/gpg/keys"
          }

          volume_mount {
            name       = "argocd-repo-server-tls"
            mount_path = "/app/config/reposerver/tls"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          liveness_probe {
            tcp_socket {
              port = "probe"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = "probe"
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

        service_account_name            = "argocd-applicationset-controller"
        automount_service_account_token = true

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/name" = "argocd-applicationset-controller"
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
              "app.kubernetes.io/name"     = "argocd-applicationset-controller"
            }
          }
        }
      }
    }

    revision_history_limit = 3
  }
}
