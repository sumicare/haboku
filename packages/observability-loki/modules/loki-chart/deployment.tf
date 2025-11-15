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


resource "kubernetes_deployment" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.29.0"
      "helm.sh/chart"                = "rollout-operator-0.33.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "rollout-operator"
      }
    }

    template {
      metadata {
        namespace = "loki"

        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "rollout-operator"
        }
      }

      spec {
        container {
          name  = "rollout-operator"
          image = "grafana/rollout-operator:v0.29.0"
          args  = ["-kubernetes.namespace=loki", "-server-tls.enabled=true", "-server-tls.self-signed-cert.secret-name=certificate"]

          port {
            name           = "http-metrics"
            container_port = 8001
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = 8443
            protocol       = "TCP"
          }

          resources {
            limits = {
              memory = "200Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        service_account_name = "release-name-rollout-operator"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_bloom_builder" {
  metadata {
    name      = "release-name-loki-bloom-builder"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-builder"
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
        "app.kubernetes.io/component" = "bloom-builder"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "bloom-builder"
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

        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name      = "data"
          empty_dir = {}
        }

        container {
          name  = "bloom-builder"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=bloom-builder"]

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
            name       = "temp"
            mount_path = "/tmp"
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
                  "app.kubernetes.io/component" = "bloom-builder"
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

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_distributor" {
  metadata {
    name      = "release-name-loki-distributor"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "distributor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "distributor"
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
          name  = "distributor"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=distributor", "-distributor.zone-awareness-enabled=true"]

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
                  "app.kubernetes.io/component" = "distributor"
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

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_gateway" {
  metadata {
    name      = "release-name-loki-gateway"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "gateway"
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
        "app.kubernetes.io/component" = "gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "gateway"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
        }

        annotations = {
          "checksum/config" = "9ff0679f9eeb9729dcc7fe1b027cc62e00d69fe1fa5cb48d62a7cf47341968d9"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-loki-gateway"
          }
        }

        volume {
          name = "auth"

          secret {
            secret_name = "loki-gateway-auth-secret"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "docker-entrypoint-d-override"
          empty_dir = {}
        }

        container {
          name  = "nginx"
          image = "docker.io/nginxinc/nginx-unprivileged:1.29-alpine"

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/nginx"
          }

          volume_mount {
            name       = "auth"
            mount_path = "/etc/nginx/secrets"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "docker-entrypoint-d-override"
            mount_path = "/docker-entrypoint.d"
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
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
          run_as_user     = 101
          run_as_group    = 101
          run_as_non_root = true
          fs_group        = 101
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "gateway"
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

    strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_querier" {
  metadata {
    name      = "release-name-loki-querier"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "querier"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "querier"
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

        volume {
          name      = "data"
          empty_dir = {}
        }

        container {
          name  = "querier"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=querier,ui", "-distributor.zone-awareness-enabled=true"]

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
                  "app.kubernetes.io/component" = "querier"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
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
              "app.kubernetes.io/component" = "querier"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "loki"
            }
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_query_frontend" {
  metadata {
    name      = "release-name-loki-query-frontend"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "query-frontend"
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
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "query-frontend"
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
          name  = "query-frontend"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=query-frontend"]

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
                  "app.kubernetes.io/component" = "query-frontend"
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

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_query_scheduler" {
  metadata {
    name      = "release-name-loki-query-scheduler"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "query-scheduler"
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
        "app.kubernetes.io/component" = "query-scheduler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "query-scheduler"
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
          name  = "query-scheduler"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=query-scheduler"]

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
                  "app.kubernetes.io/component" = "query-scheduler"
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

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "loki_read" {
  metadata {
    name      = "loki-read"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "read"
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
        "app.kubernetes.io/component" = "read"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "read"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "data"
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
          name  = "loki"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=read,ui", "-legacy-read-mode=false", "-common.compactor-grpc-address=loki-backend.loki.svc.Sumicare:9095"]

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
                  "app.kubernetes.io/component" = "read"
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

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

