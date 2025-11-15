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


resource "kubernetes_stateful_set" "application_controller" {
  metadata {
    name      = "${local.app_name}-application-controller"
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas = var.application_controller_replicas

    selector {
      match_labels = local.application_controller_labels
    }

    template {
      metadata {
        labels = local.application_controller_labels

        annotations = {
          "checksum/cm"         = "957cbd1078974876f8f1193b5a6a64406be646f0a6b0dc40ff3ea50ac725227e"
          "checksum/cmd-params" = "673d2166eac30d0adb254fe1becc81d1caa2839ac8659ffe13a7a8c727c3e0c2"
        }
      }

      spec {
        volume {
          name = "argocd-home"
        }

        volume {
          name = "argocd-application-controller-tmp"
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

        volume {
          name = "argocd-cmd-params-cm"

          config_map {
            name = "argocd-cmd-params-cm"

            items {
              key  = "controller.profile.enabled"
              path = "profiler.enabled"
            }

            optional = true
          }
        }

        container {
          name        = "application-controller"
          image       = "${var.argocd_image}:${var.argocd_version}"
          args        = ["/usr/local/bin/argocd-application-controller", "--metrics-port=8082"]
          working_dir = "/home/argocd"

          port {
            name           = "metrics"
            container_port = 8082
            protocol       = "TCP"
          }

          env {
            name  = "ARGOCD_CONTROLLER_REPLICAS"
            value = tostring(var.application_controller_replicas)
          }

          env {
            name  = "ARGOCD_APPLICATION_CONTROLLER_NAME"
            value = "${local.app_name}-application-controller"
          }

          env {
            name = "ARGOCD_RECONCILIATION_TIMEOUT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cm"
                key      = "timeout.reconciliation"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_HARD_RECONCILIATION_TIMEOUT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cm"
                key      = "timeout.hard.reconciliation"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_RECONCILIATION_JITTER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cm"
                key      = "timeout.reconciliation.jitter"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_ERROR_GRACE_PERIOD_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.repo.error.grace.period.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "repo.server"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_TIMEOUT_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.repo.server.timeout.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_STATUS_PROCESSORS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.status.processors"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_OPERATION_PROCESSORS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.operation.processors"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_LOGFORMAT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.log.format"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_LOGLEVEL"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.log.level"
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
            name = "ARGOCD_APPLICATION_CONTROLLER_METRICS_CACHE_EXPIRATION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.metrics.cache.expiration"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_TIMEOUT_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.self.heal.timeout.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_TIMEOUT_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.self.heal.backoff.timeout.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_FACTOR"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.self.heal.backoff.factor"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_CAP_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.self.heal.backoff.cap.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_COOLDOWN_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.self.heal.backoff.cooldown.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_SYNC_TIMEOUT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.sync.timeout.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_PLAINTEXT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.repo.server.plaintext"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_STRICT_TLS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.repo.server.strict.tls"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_PERSIST_RESOURCE_HEALTH"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.resource.health.persist"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APP_STATE_CACHE_EXPIRATION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.app.state.cache.expiration"
                optional = true
              }
            }
          }

          env {
            name = "REDIS_SERVER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "redis.server"
                optional = true
              }
            }
          }

          env {
            name = "REDIS_COMPRESSION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "redis.compression"
                optional = true
              }
            }
          }

          env {
            name = "REDISDB"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "redis.db"
                optional = true
              }
            }
          }

          env {
            name = "REDIS_USERNAME"

            value_from {
              secret_key_ref {
                name = "argocd-redis-secret"
                key  = "redis-username"
              }
            }
          }

          env {
            name = "REDIS_PASSWORD"

            value_from {
              secret_key_ref {
                name = "argocd-redis-secret"
                key  = "redis-password"
              }
            }
          }

          env {
            name = "REDIS_SENTINEL_USERNAME"

            value_from {
              secret_key_ref {
                name     = "argocd-redis-secret"
                key      = "redis-sentinel-username"
                optional = true
              }
            }
          }

          env {
            name = "REDIS_SENTINEL_PASSWORD"

            value_from {
              secret_key_ref {
                name     = "argocd-redis-secret"
                key      = "redis-sentinel-password"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_DEFAULT_CACHE_EXPIRATION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.default.cache.expiration"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_OTLP_ADDRESS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.address"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_OTLP_INSECURE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.insecure"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_OTLP_HEADERS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.headers"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_OTLP_ATTRS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.attrs"
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
            name = "ARGOCD_CONTROLLER_SHARDING_ALGORITHM"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.sharding.algorithm"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_KUBECTL_PARALLELISM_LIMIT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.kubectl.parallelism.limit"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_K8SCLIENT_RETRY_MAX"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.k8sclient.retry.max"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_K8SCLIENT_RETRY_BASE_BACKOFF"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.k8sclient.retry.base.backoff"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_SERVER_SIDE_DIFF"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.diff.server.side"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_IGNORE_NORMALIZER_JQ_TIMEOUT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.ignore.normalizer.jq.timeout"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_HYDRATOR_ENABLED"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "hydrator.enabled"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_CLUSTER_CACHE_BATCH_EVENTS_PROCESSING"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.cluster.cache.batch.events.processing"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_CLUSTER_CACHE_EVENTS_PROCESSING_INTERVAL"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "controller.cluster.cache.events.processing.interval"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APPLICATION_CONTROLLER_COMMIT_SERVER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "commit.server"
                optional = true
              }
            }
          }

          env {
            name  = "KUBECACHEDIR"
            value = "/tmp/kubecache"
          }

          volume_mount {
            name       = "argocd-repo-server-tls"
            mount_path = "/app/config/controller/tls"
          }

          volume_mount {
            name       = "argocd-home"
            mount_path = "/home/argocd"
          }

          volume_mount {
            name       = "argocd-cmd-params-cm"
            mount_path = "/home/argocd/params"
          }

          volume_mount {
            name       = "argocd-application-controller-tmp"
            mount_path = "/tmp"
          }

          readiness_probe {
            http_get {
              path = "/healthz"
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

        service_account_name            = "argocd-application-controller"
        automount_service_account_token = true

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/name" = "${local.app_name}-application-controller"
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
            match_labels = local.application_controller_selector_labels
          }
        }
      }
    }

    service_name           = "${local.app_name}-application-controller"
    revision_history_limit = 5
  }
}

