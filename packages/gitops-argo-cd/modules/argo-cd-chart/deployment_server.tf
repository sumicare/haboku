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


resource "kubernetes_deployment" "server" {
  metadata {
    name      = "${local.app_name}-server"
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas = var.server_replicas

    selector {
      match_labels = local.server_labels
    }

    template {
      metadata {
        labels = local.server_labels

        annotations = {
          "checksum/cm"         = "957cbd1078974876f8f1193b5a6a64406be646f0a6b0dc40ff3ea50ac725227e"
          "checksum/cmd-params" = "673d2166eac30d0adb254fe1becc81d1caa2839ac8659ffe13a7a8c727c3e0c2"
        }
      }

      spec {
        volume {
          name = "plugins-home"
        }

        volume {
          name = "tmp"
        }

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
          name = "styles"

          config_map {
            name     = "argocd-styles-cm"
            optional = true
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

        volume {
          name = "argocd-dex-server-tls"

          secret {
            secret_name = "argocd-dex-server-tls"

            items {
              key  = "tls.crt"
              path = "tls.crt"
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
              key  = "server.profile.enabled"
              path = "profiler.enabled"
            }

            optional = true
          }
        }

        container {
          name  = "server"
          image = "${var.argocd_image}:${var.argocd_version}"
          args  = ["/usr/local/bin/argocd-server", "--port=8080", "--metrics-port=8083"]

          port {
            name           = "server"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "metrics"
            container_port = 8083
            protocol       = "TCP"
          }

          env {
            name  = "ARGOCD_SERVER_NAME"
            value = "release-name-argocd-server"
          }

          env {
            name = "ARGOCD_SERVER_INSECURE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.insecure"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_BASEHREF"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.basehref"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_ROOTPATH"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.rootpath"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_LOGFORMAT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.log.format"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_LOG_LEVEL"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.log.level"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_REPO_SERVER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "repo.server"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_DEX_SERVER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.dex.server"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_DISABLE_AUTH"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.disable.auth"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_ENABLE_GZIP"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.enable.gzip"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_REPO_SERVER_TIMEOUT_SECONDS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.repo.server.timeout.seconds"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_X_FRAME_OPTIONS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.x.frame.options"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_CONTENT_SECURITY_POLICY"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.content.security.policy"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_REPO_SERVER_PLAINTEXT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.repo.server.plaintext"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_REPO_SERVER_STRICT_TLS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.repo.server.strict.tls"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_DEX_SERVER_PLAINTEXT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.dex.server.plaintext"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_DEX_SERVER_STRICT_TLS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.dex.server.strict.tls"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_TLS_MIN_VERSION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.tls.minversion"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_TLS_MAX_VERSION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.tls.maxversion"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_TLS_CIPHERS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.tls.ciphers"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_CONNECTION_STATUS_CACHE_EXPIRATION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.connection.status.cache.expiration"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_OIDC_CACHE_EXPIRATION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.oidc.cache.expiration"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_STATIC_ASSETS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.staticassets"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_APP_STATE_CACHE_EXPIRATION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.app.state.cache.expiration"
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
                key      = "server.default.cache.expiration"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_MAX_COOKIE_NUMBER"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.http.cookie.maxnumber"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_LISTEN_ADDRESS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.listen.address"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_METRICS_LISTEN_ADDRESS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.metrics.listen.address"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_OTLP_ADDRESS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.address"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_OTLP_INSECURE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.insecure"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_OTLP_HEADERS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.headers"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_OTLP_ATTRS"

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
            name = "ARGOCD_SERVER_ENABLE_PROXY_EXTENSION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.enable.proxy.extension"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_K8SCLIENT_RETRY_MAX"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.k8sclient.retry.max"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_K8SCLIENT_RETRY_BASE_BACKOFF"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.k8sclient.retry.base.backoff"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_API_CONTENT_TYPES"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.api.content.types"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_SERVER_WEBHOOK_PARALLELISM_LIMIT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.webhook.parallelism.limit"
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
            name = "ARGOCD_SYNC_WITH_REPLACE_ALLOWED"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "server.sync.replace.allowed"
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
            name       = "argocd-repo-server-tls"
            mount_path = "/app/config/server/tls"
          }

          volume_mount {
            name       = "argocd-dex-server-tls"
            mount_path = "/app/config/dex/tls"
          }

          volume_mount {
            name       = "plugins-home"
            mount_path = "/home/argocd"
          }

          volume_mount {
            name       = "styles"
            mount_path = "/shared/app/custom"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "argocd-cmd-params-cm"
            mount_path = "/home/argocd/params"
          }

          liveness_probe {
            http_get {
              path = "/healthz?full=true"
              port = "server"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "server"
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

        service_account_name            = "argocd-server"
        automount_service_account_token = true

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/name" = "argocd-server"
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
              "app.kubernetes.io/name"     = "argocd-server"
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
