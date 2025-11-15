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


resource "kubernetes_deployment" "release_name_minio" {
  metadata {
    name = "release-name-minio"

    labels = {
      app      = "minio"
      chart    = "minio-5.4.0"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "minio"
        release = "release-name"
      }
    }

    template {
      metadata {
        name = "release-name-minio"

        labels = {
          app     = "minio"
          release = "release-name"
        }

        annotations = {
          "checksum/config"  = "b98a6c0d8086de24ec40aa45a31f6ab53fe80a87f3aa624287f135baca7c09f8"
          "checksum/secrets" = "1b9db1c229d9a611c469bca0f59e5a254f0e286dd0eef060f725ec4ce26aca35"
        }
      }

      spec {
        volume {
          name = "export"

          persistent_volume_claim {
            claim_name = "release-name-minio"
          }
        }

        volume {
          name = "minio-user"

          secret {
            secret_name = "release-name-minio"
          }
        }

        container {
          name    = "minio"
          image   = "quay.io/minio/minio:RELEASE.2024-12-18T13-15-44Z"
          command = ["/bin/sh", "-ce", "/usr/bin/docker-entrypoint.sh minio server /export -S /etc/minio/certs/ --address :9000 --console-address :9001"]

          port {
            name           = "http"
            container_port = 9000
          }

          port {
            name           = "http-console"
            container_port = 9001
          }

          env {
            name = "MINIO_ROOT_USER"

            value_from {
              secret_key_ref {
                name = "release-name-minio"
                key  = "rootUser"
              }
            }
          }

          env {
            name = "MINIO_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = "release-name-minio"
                key  = "rootPassword"
              }
            }
          }

          env {
            name  = "MINIO_PROMETHEUS_AUTH_TYPE"
            value = "public"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "minio-user"
            read_only  = true
            mount_path = "/tmp/credentials"
          }

          volume_mount {
            name       = "export"
            mount_path = "/export"
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "minio-sa"

        security_context {
          run_as_user            = 1000
          run_as_group           = 1000
          fs_group               = 1000
          fs_group_change_policy = "OnRootMismatch"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "100%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.32.0"
      "helm.sh/chart"                = "rollout-operator-0.37.1"
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
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "rollout-operator"
        }
      }

      spec {
        container {
          name  = "rollout-operator"
          image = "grafana/rollout-operator:v0.32.0"
          args  = ["-kubernetes.namespace=mimir", "-server-tls.enabled=true", "-server-tls.self-signed-cert.secret-name=certificate", "-server-tls.self-signed-cert.dns-name=release-name-rollout-operator.mimir.svc"]

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

resource "kubernetes_deployment" "release_name_mimir_distributor" {
  metadata {
    name      = "release-name-mimir-distributor"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "distributor"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "distributor"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=distributor", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-server.grpc.keepalive.max-connection-age=60s", "-server.grpc.keepalive.max-connection-age-grace=5m", "-server.grpc.keepalive.max-connection-idle=1m", "-shutdown-delay=90s"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "8"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 100
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "distributor"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }

          min_domains          = 1
          node_affinity_policy = "Honor"
          node_taints_policy   = "Honor"
          match_label_keys     = ["pod-template-hash"]
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_gateway" {
  metadata {
    name      = "release-name-mimir-gateway"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "gateway"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "9146afc55e0a0192aad4cfaf3ccbfd3800308f4bafbdf457034b5286621bca6d"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name = "nginx-config"

          config_map {
            name = "release-name-mimir-gateway-nginx"
          }
        }

        volume {
          name      = "docker-entrypoint-d-override"
          empty_dir = {}
        }

        volume {
          name = "auth"

          secret {
            secret_name = "mimir-basic-auth"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "gateway"
          image = "docker.io/nginxinc/nginx-unprivileged:1.29-alpine"

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = "2"
              memory = "256Mi"
            }

            requests = {
              cpu    = "1"
              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
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
              path = "/ready"
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
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_overrides_exporter" {
  metadata {
    name      = "release-name-mimir-overrides-exporter"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "overrides-exporter"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "overrides-exporter"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "overrides-exporter"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "overrides-exporter"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=overrides-exporter", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
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
        service_account_name             = "release-name-mimir"

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
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_querier" {
  metadata {
    name      = "release-name-mimir-querier"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "querier"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "querier"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=querier", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-querier.store-gateway-client.grpc-max-recv-msg-size=209715200"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "5"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 180
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
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
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_query_frontend" {
  metadata {
    name      = "release-name-mimir-query-frontend"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "query-frontend"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "query-frontend"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=query-frontend", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-server.grpc.keepalive.max-connection-age=30s", "-shutdown-delay=90s"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 390
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "query-frontend"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_query_scheduler" {
  metadata {
    name      = "release-name-mimir-query-scheduler"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "query-scheduler"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-scheduler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "query-scheduler"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "query-scheduler"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=query-scheduler", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 180
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "query-scheduler"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "1"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_ruler" {
  metadata {
    name      = "release-name-mimir-ruler"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "ruler"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ruler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "ruler"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ruler"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ruler", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-distributor.remote-timeout=10s"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 600
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ruler"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "50%"
      }
    }
  }
}

