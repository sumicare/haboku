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


resource "kubernetes_deployment" "repo_server" {
  metadata {
    name      = "${local.app_name}-repo-server"
    namespace = var.namespace
    labels    = local.repo_server_labels
  }

  spec {
    replicas = var.repo_server_replicas

    selector {
      match_labels = local.repo_server_selector_labels
    }

    template {
      metadata {
        labels = local.repo_server_labels

        annotations = {
          "checksum/cm"              = "957cbd1078974876f8f1193b5a6a64406be646f0a6b0dc40ff3ea50ac725227e"
          "checksum/cmd-params"      = "673d2166eac30d0adb254fe1becc81d1caa2839ac8659ffe13a7a8c727c3e0c2"
          "checksum/cmp-cm"          = "0e7d9072f303e616e4b2b4c786f88b8d7545fd2e62e74419c5a200ed36f2bb64"
          "checksum/repo-server-tls" = "2f8b9dc4cfb3dd64fe281501fbaaddc7d3d10b8dfd10d7971a9e6f6964211c82"
        }
      }

      spec {
        volume {
          name      = "helm-working-dir"
          empty_dir = {}
        }

        volume {
          name      = "plugins"
          empty_dir = {}
        }

        volume {
          name      = "var-files"
          empty_dir = {}
        }

        volume {
          name      = "tmp"
          empty_dir = {}
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
          name = "gpg-keys"

          config_map {
            name = "argocd-gpg-keys-cm"
          }
        }

        volume {
          name      = "gpg-keyring"
          empty_dir = {}
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

        init_container {
          name    = "copyutil"
          image   = "${var.argocd_image}:${var.argocd_version}"
          command = ["/bin/cp", "-n", "/usr/local/bin/argocd", "/var/run/argocd/argocd-cmp-server"]

          volume_mount {
            name       = "var-files"
            mount_path = "/var/run/argocd"
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
          name  = "repo-server"
          image = "${var.argocd_image}:${var.argocd_version}"
          args  = ["/usr/local/bin/argocd-repo-server", "--port=8081", "--metrics-port=8084"]

          port {
            name           = "repo-server"
            container_port = 8081
            protocol       = "TCP"
          }

          port {
            name           = "metrics"
            container_port = 8084
            protocol       = "TCP"
          }

          env {
            name  = "ARGOCD_REPO_SERVER_NAME"
            value = "release-name-argocd-repo-server"
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
            name = "ARGOCD_REPO_SERVER_LOGFORMAT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.log.format"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_LOGLEVEL"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.log.level"
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
            name = "ARGOCD_REPO_SERVER_PARALLELISM_LIMIT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.parallelism.limit"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_LISTEN_ADDRESS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.listen.address"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_LISTEN_METRICS_ADDRESS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.metrics.listen.address"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_DISABLE_TLS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.disable.tls"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_TLS_MIN_VERSION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.tls.minversion"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_TLS_MAX_VERSION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.tls.maxversion"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_TLS_CIPHERS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.tls.ciphers"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_CACHE_EXPIRATION"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.repo.cache.expiration"
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
                key      = "reposerver.default.cache.expiration"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_OTLP_ADDRESS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.address"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_OTLP_INSECURE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.insecure"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_OTLP_HEADERS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.headers"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_OTLP_ATTRS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "otlp.attrs"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_MAX_COMBINED_DIRECTORY_MANIFESTS_SIZE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.max.combined.directory.manifests.size"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_PLUGIN_TAR_EXCLUSIONS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.plugin.tar.exclusions"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_PLUGIN_USE_MANIFEST_GENERATE_PATHS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.plugin.use.manifest.generate.paths"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_ALLOW_OUT_OF_BOUNDS_SYMLINKS"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.allow.oob.symlinks"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_STREAMED_MANIFEST_MAX_TAR_SIZE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.streamed.manifest.max.tar.size"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_STREAMED_MANIFEST_MAX_EXTRACTED_SIZE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.streamed.manifest.max.extracted.size"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_HELM_MANIFEST_MAX_EXTRACTED_SIZE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.helm.manifest.max.extracted.size"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_DISABLE_HELM_MANIFEST_MAX_EXTRACTED_SIZE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.disable.helm.manifest.max.extracted.size"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_GIT_MODULES_ENABLED"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.enable.git.submodule"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_GIT_LS_REMOTE_PARALLELISM_LIMIT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.git.lsremote.parallelism.limit"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_GIT_REQUEST_TIMEOUT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.git.request.timeout"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_OCI_MANIFEST_MAX_EXTRACTED_SIZE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.oci.manifest.max.extracted.size"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_DISABLE_OCI_MANIFEST_MAX_EXTRACTED_SIZE"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.disable.oci.manifest.max.extracted.size"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_OCI_LAYER_MEDIA_TYPES"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.oci.layer.media.types"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REVISION_CACHE_LOCK_TIMEOUT"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.revision.cache.lock.timeout"
                optional = true
              }
            }
          }

          env {
            name = "ARGOCD_REPO_SERVER_INCLUDE_HIDDEN_DIRECTORIES"

            value_from {
              config_map_key_ref {
                name     = "argocd-cmd-params-cm"
                key      = "reposerver.include.hidden.directories"
                optional = true
              }
            }
          }

          env {
            name  = "HELM_CACHE_HOME"
            value = "/helm-working-dir"
          }

          env {
            name  = "HELM_CONFIG_HOME"
            value = "/helm-working-dir"
          }

          env {
            name  = "HELM_DATA_HOME"
            value = "/helm-working-dir"
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
            name       = "helm-working-dir"
            mount_path = "/helm-working-dir"
          }

          volume_mount {
            name       = "plugins"
            mount_path = "/home/argocd/cmp-server/plugins"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          liveness_probe {
            http_get {
              path = "/healthz?full=true"
              port = "metrics"
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

        service_account_name            = "release-name-argocd-repo-server"
        automount_service_account_token = true

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/name" = "argocd-repo-server"
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
              "app.kubernetes.io/name"     = "argocd-repo-server"
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
