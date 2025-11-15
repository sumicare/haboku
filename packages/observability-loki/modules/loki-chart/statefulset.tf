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


resource "kubernetes_stateful_set" "loki_backend" {
  metadata {
    name      = "loki-backend"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "backend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "backend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "backend"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config"                         = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
          "kubectl.kubernetes.io/default-container" = "loki"
        }
      }

      spec {
        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        volume {
          name      = "sc-rules-volume"
          empty_dir = {}
        }

        container {
          name  = "loki"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=backend", "-legacy-read-mode=false"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          volume_mount {
            name       = "sc-rules-volume"
            mount_path = "/rules"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        container {
          name  = "loki-sc-rules"
          image = "docker.io/kiwigrid/k8s-sidecar:1.30.10"

          env {
            name  = "METHOD"
            value = "WATCH"
          }

          env {
            name  = "LABEL"
            value = "loki_rule"
          }

          env {
            name  = "FOLDER"
            value = "/rules"
          }

          env {
            name  = "RESOURCE"
            value = "both"
          }

          env {
            name  = "WATCH_SERVER_TIMEOUT"
            value = "60"
          }

          env {
            name  = "WATCH_CLIENT_TIMEOUT"
            value = "60"
          }

          env {
            name  = "LOG_LEVEL"
            value = "INFO"
          }

          volume_mount {
            name       = "sc-rules-volume"
            mount_path = "/rules"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"
        automount_service_account_token  = true

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "backend"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "loki-backend-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10

    persistent_volume_claim_retention_policy {
      when_deleted = "Delete"
      when_scaled  = "Delete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_loki_bloom_gateway" {
  metadata {
    name      = "release-name-loki-bloom-gateway"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "bloom-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "bloom-gateway"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "bloom-gateway"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=bloom-gateway"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "bloom-gateway"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "release-name-loki-bloom-gateway-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_bloom_planner" {
  metadata {
    name      = "release-name-loki-bloom-planner"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-planner"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "bloom-planner"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "bloom-planner"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "bloom-planner"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=bloom-planner"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "bloom-planner"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "release-name-loki-bloom-planner-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_chunks_cache" {
  metadata {
    name      = "release-name-loki-chunks-cache"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "memcached-chunks-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "memcached-chunks-cache"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "memcached-chunks-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "memcached-chunks-cache"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "memcached-chunks-cache"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          name                          = "memcached-chunks-cache"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 8192", "--extended=modern,track_sizes,ext_path=/data/file:9G,ext_wbuf_size=16", "-I 5m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "9830Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "9830Mi"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/data"
          }

          liveness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            failure_threshold     = 6
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        container {
          name  = "exporter"
          image = "prom/memcached-exporter:v0.15.3"
          args  = ["--memcached.address=localhost:11211", "--web.listen-address=0.0.0.0:9150"]

          port {
            name           = "http-metrics"
            container_port = 9150
          }

          liveness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 60
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 11211
          run_as_group    = 11211
          run_as_non_root = true
          fs_group        = 11211
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10G"
          }
        }
      }
    }

    service_name          = "release-name-loki-chunks-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_loki_compactor" {
  metadata {
    name      = "release-name-loki-compactor"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "compactor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "compactor"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "compactor"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=compactor"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "compactor"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "release-name-loki-compactor-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_index_gateway" {
  metadata {
    name      = "release-name-loki-index-gateway"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "index-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "index-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "index-gateway"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "index-gateway"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=index-gateway"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "index-gateway"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name = "release-name-loki-index-gateway-headless"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ingester_zone_a" {
  metadata {
    name      = "release-name-loki-ingester-zone-a"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "ingester-zone-a"
      rollout-group                 = "ingester"
    }

    annotations = {
      rollout-max-unavailable = "1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "ingester-zone-a"
        rollout-group                 = "ingester"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
          name                          = "ingester-zone-a"
          rollout-group                 = "ingester"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-ingester.availability-zone=zone-a", "-ingester.unregister-on-shutdown=false", "-ingester.tokens-file-path=/var/loki/ring-tokens", "-target=ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "rollout-group"
                  operator = "In"
                  values   = ["ingester"]
                }

                match_expressions {
                  key      = "name"
                  operator = "NotIn"
                  values   = ["ingester-zone-a"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "loki"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name          = "release-name-loki-ingester-zone-a-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ingester_zone_b" {
  metadata {
    name      = "release-name-loki-ingester-zone-b"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "ingester-zone-b"
      rollout-group                 = "ingester"
    }

    annotations = {
      rollout-max-unavailable = "1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "ingester-zone-b"
        rollout-group                 = "ingester"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
          name                          = "ingester-zone-b"
          rollout-group                 = "ingester"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-ingester.availability-zone=zone-b", "-ingester.unregister-on-shutdown=false", "-ingester.tokens-file-path=/var/loki/ring-tokens", "-target=ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "rollout-group"
                  operator = "In"
                  values   = ["ingester"]
                }

                match_expressions {
                  key      = "name"
                  operator = "NotIn"
                  values   = ["ingester-zone-b"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "loki"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name          = "release-name-loki-ingester-zone-b-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ingester_zone_c" {
  metadata {
    name      = "release-name-loki-ingester-zone-c"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "ingester-zone-c"
      rollout-group                 = "ingester"
    }

    annotations = {
      rollout-max-unavailable = "1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "ingester-zone-c"
        rollout-group                 = "ingester"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
          name                          = "ingester-zone-c"
          rollout-group                 = "ingester"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-ingester.availability-zone=zone-c", "-ingester.unregister-on-shutdown=false", "-ingester.tokens-file-path=/var/loki/ring-tokens", "-target=ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "rollout-group"
                  operator = "In"
                  values   = ["ingester"]
                }

                match_expressions {
                  key      = "name"
                  operator = "NotIn"
                  values   = ["ingester-zone-c"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "loki"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name          = "release-name-loki-ingester-zone-c-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_pattern_ingester" {
  metadata {
    name      = "release-name-loki-pattern-ingester"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "pattern-ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "pattern-ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "pattern-ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "pattern-ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=pattern-ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "pattern-ingester"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "release-name-loki-pattern-ingester-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_results_cache" {
  metadata {
    name      = "release-name-loki-results-cache"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "memcached-results-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "memcached-results-cache"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "memcached-results-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "memcached-results-cache"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "memcached-results-cache"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          name                          = "memcached-results-cache"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 1024", "--extended=modern,track_sizes,ext_path=/data/file:9G,ext_wbuf_size=16", "-I 5m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "1229Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "1229Mi"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/data"
          }

          liveness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            failure_threshold     = 6
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        container {
          name  = "exporter"
          image = "prom/memcached-exporter:v0.15.3"
          args  = ["--memcached.address=localhost:11211", "--web.listen-address=0.0.0.0:9150"]

          port {
            name           = "http-metrics"
            container_port = 9150
          }

          liveness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 60
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 11211
          run_as_group    = 11211
          run_as_non_root = true
          fs_group        = 11211
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10G"
          }
        }
      }
    }

    service_name          = "release-name-loki-results-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ruler" {
  metadata {
    name      = "release-name-loki-ruler"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ruler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ruler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ruler"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config"                         = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
          "kubectl.kubernetes.io/default-container" = "ruler"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "ruler"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=ruler"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "ruler"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "release-name-loki-ruler"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "loki_write" {
  metadata {
    name      = "loki-write"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "write"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "write"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "write"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "loki"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=write"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"
        automount_service_account_token  = true

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "write"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        enable_service_links = true
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "loki-write-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

