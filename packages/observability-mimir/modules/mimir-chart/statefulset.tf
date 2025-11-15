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


resource "kubernetes_stateful_set" "release_name_mimir_alertmanager_zone_a" {
  metadata {
    name      = "release-name-mimir-alertmanager-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "alertmanager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "alertmanager-zone-a"
      rollout-group                  = "alertmanager"
      zone                           = "zone-a"
    }

    annotations = {
      rollout-max-unavailable = "2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "alertmanager"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "alertmanager"
        zone                          = "zone-a"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "alertmanager"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "alertmanager-zone-a"
          rollout-group                  = "alertmanager"
          zone                           = "zone-a"
        }

        annotations = {
          "checksum/alertmanager-fallback-config" = "230274102d470b64082478b2a146ca962b0668b130c72df7f72d05565393f18a"
          "checksum/config"                       = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
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
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        volume {
          name = "alertmanager-fallback-config"

          config_map {
            name = "release-name-mimir-alertmanager-fallback-config"
          }
        }

        container {
          name  = "alertmanager"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=alertmanager", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-alertmanager.sharding-ring.instance-availability-zone=zone-a", "-server.http-idle-timeout=6m"]

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
              cpu    = "10m"
              memory = "32Mi"
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
            name       = "alertmanager-fallback-config"
            mount_path = "/configs/"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
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

        termination_grace_period_seconds = 900
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
              "app.kubernetes.io/component" = "alertmanager"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "release-name-mimir-alertmanager"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_alertmanager_zone_b" {
  metadata {
    name      = "release-name-mimir-alertmanager-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "alertmanager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "alertmanager-zone-b"
      rollout-group                  = "alertmanager"
      zone                           = "zone-b"
    }

    annotations = {
      rollout-max-unavailable = "2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "alertmanager"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "alertmanager"
        zone                          = "zone-b"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "alertmanager"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "alertmanager-zone-b"
          rollout-group                  = "alertmanager"
          zone                           = "zone-b"
        }

        annotations = {
          "checksum/alertmanager-fallback-config" = "230274102d470b64082478b2a146ca962b0668b130c72df7f72d05565393f18a"
          "checksum/config"                       = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
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
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        volume {
          name = "alertmanager-fallback-config"

          config_map {
            name = "release-name-mimir-alertmanager-fallback-config"
          }
        }

        container {
          name  = "alertmanager"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=alertmanager", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-alertmanager.sharding-ring.instance-availability-zone=zone-b", "-server.http-idle-timeout=6m"]

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
              cpu    = "10m"
              memory = "32Mi"
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
            name       = "alertmanager-fallback-config"
            mount_path = "/configs/"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
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

        termination_grace_period_seconds = 900
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
              "app.kubernetes.io/component" = "alertmanager"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "release-name-mimir-alertmanager"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_alertmanager_zone_c" {
  metadata {
    name      = "release-name-mimir-alertmanager-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "alertmanager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "alertmanager-zone-c"
      rollout-group                  = "alertmanager"
      zone                           = "zone-c"
    }

    annotations = {
      rollout-max-unavailable = "2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "alertmanager"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "alertmanager"
        zone                          = "zone-c"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "alertmanager"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "alertmanager-zone-c"
          rollout-group                  = "alertmanager"
          zone                           = "zone-c"
        }

        annotations = {
          "checksum/alertmanager-fallback-config" = "230274102d470b64082478b2a146ca962b0668b130c72df7f72d05565393f18a"
          "checksum/config"                       = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
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
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        volume {
          name = "alertmanager-fallback-config"

          config_map {
            name = "release-name-mimir-alertmanager-fallback-config"
          }
        }

        container {
          name  = "alertmanager"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=alertmanager", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-alertmanager.sharding-ring.instance-availability-zone=zone-c", "-server.http-idle-timeout=6m"]

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
              cpu    = "10m"
              memory = "32Mi"
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
            name       = "alertmanager-fallback-config"
            mount_path = "/configs/"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
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

        termination_grace_period_seconds = 900
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
              "app.kubernetes.io/component" = "alertmanager"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "release-name-mimir-alertmanager"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_chunks_cache" {
  metadata {
    name      = "release-name-mimir-chunks-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
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
        "app.kubernetes.io/component" = "chunks-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "chunks-cache"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 8192", "--extended=modern", "-I 1m", "-c 16384", "-v", "-u 11211"]

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

          resources {
            limits = {
              memory = "250Mi"
            }

            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
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

    service_name          = "release-name-mimir-chunks-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_compactor" {
  metadata {
    name      = "release-name-mimir-compactor"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "compactor"
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
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "compactor"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=compactor", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml"]

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

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 900
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
              "app.kubernetes.io/component" = "compactor"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-compactor"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_index_cache" {
  metadata {
    name      = "release-name-mimir-index-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
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
        "app.kubernetes.io/component" = "index-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "index-cache"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 2048", "--extended=modern", "-I 5m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "2458Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "2458Mi"
            }
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

          resources {
            limits = {
              memory = "250Mi"
            }

            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
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

    service_name          = "release-name-mimir-index-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_ingester_zone_a" {
  metadata {
    name      = "release-name-mimir-ingester-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "ingester"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "12h"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "ingester-zone-a"
      rollout-group                                  = "ingester"
      zone                                           = "zone-a"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "ingester/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "ingester"
        zone                          = "zone-a"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "ingester"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "ingester-zone-a"
          rollout-group                  = "ingester"
          zone                           = "zone-a"
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
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ingester"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ingester", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-ingester.ring.instance-availability-zone=zone-a", "-memberlist.abort-if-fast-join-fails=true"]

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
            value = "4"
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

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 1200
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
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-ingester-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_ingester_zone_b" {
  metadata {
    name      = "release-name-mimir-ingester-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "ingester"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "12h"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "ingester-zone-b"
      rollout-group                                  = "ingester"
      zone                                           = "zone-b"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "ingester/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-ingester-zone-a"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "ingester"
        zone                          = "zone-b"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "ingester"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "ingester-zone-b"
          rollout-group                  = "ingester"
          zone                           = "zone-b"
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
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ingester"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ingester", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-ingester.ring.instance-availability-zone=zone-b", "-memberlist.abort-if-fast-join-fails=true"]

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
            value = "4"
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

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 1200
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
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-ingester-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_ingester_zone_c" {
  metadata {
    name      = "release-name-mimir-ingester-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "ingester"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "12h"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "ingester-zone-c"
      rollout-group                                  = "ingester"
      zone                                           = "zone-c"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "ingester/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-ingester-zone-b"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "ingester"
        zone                          = "zone-c"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "ingester"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "ingester-zone-c"
          rollout-group                  = "ingester"
          zone                           = "zone-c"
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
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ingester"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ingester", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-ingester.ring.instance-availability-zone=zone-c", "-memberlist.abort-if-fast-join-fails=true"]

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
            value = "4"
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

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 1200
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
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-ingester-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_kafka" {
  metadata {
    name      = "release-name-mimir-kafka"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "kafka"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "kafka"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "kafka"
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
          name      = "kafka-config"
          empty_dir = {}
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "kafka"
          image = "apache/kafka-native:4.1.0"

          port {
            name           = "kafka"
            container_port = 9092
            protocol       = "TCP"
          }

          port {
            name           = "controller"
            container_port = 9093
            protocol       = "TCP"
          }

          env {
            name = "_POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "KAFKA_CLUSTER_ID"
          }

          env {
            name = "KAFKA_NODE_ID"

            value_from {
              field_ref {
                field_path = "metadata.labels['apps.kubernetes.io/pod-index']"
              }
            }
          }

          env {
            name  = "KAFKA_PROCESS_ROLES"
            value = "broker,controller"
          }

          env {
            name  = "KAFKA_LISTENERS"
            value = "PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093"
          }

          env {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://$(_POD_NAME).release-name-mimir-kafka-headless.mimir.svc.cluster.local.:9092"
          }

          env {
            name  = "KAFKA_CONTROLLER_QUORUM_VOTERS"
            value = "0@release-name-mimir-kafka-0.release-name-mimir-kafka-headless.mimir.svc.cluster.local:9093"
          }

          env {
            name  = "KAFKA_CONTROLLER_LISTENER_NAMES"
            value = "CONTROLLER"
          }

          env {
            name  = "KAFKA_INTER_BROKER_LISTENER_NAME"
            value = "PLAINTEXT"
          }

          env {
            name  = "KAFKA_LOG_DIRS"
            value = "/var/lib/kafka/data"
          }

          env {
            name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR"
            value = "1"
          }

          env {
            name  = "KAFKA_LOG_RETENTION_HOURS"
            value = "24"
          }

          resources {
            requests = {
              cpu    = "1"
              memory = "1Gi"
            }
          }

          volume_mount {
            name       = "kafka-data"
            mount_path = "/var/lib/kafka"
          }

          volume_mount {
            name       = "kafka-config"
            mount_path = "/opt/kafka/config"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          readiness_probe {
            tcp_socket {
              port = "kafka"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
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

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 1001
          run_as_group    = 1001
          run_as_non_root = true
          fs_group        = 1001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "kafka-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "5Gi"
          }
        }
      }
    }

    service_name = "release-name-mimir-kafka-headless"
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_metadata_cache" {
  metadata {
    name      = "release-name-mimir-metadata-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
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
        "app.kubernetes.io/component" = "metadata-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "metadata-cache"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 512", "--extended=modern", "-I 1m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "614Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "614Mi"
            }
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

          resources {
            limits = {
              memory = "250Mi"
            }

            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
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

    service_name          = "release-name-mimir-metadata-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_store_gateway_zone_a" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "store-gateway"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "30m"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "store-gateway-zone-a"
      rollout-group                                  = "store-gateway"
      zone                                           = "zone-a"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "store-gateway/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "store-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "store-gateway"
        zone                          = "zone-a"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "store-gateway"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "store-gateway-zone-a"
          rollout-group                  = "store-gateway"
          zone                           = "zone-a"
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
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "store-gateway"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=store-gateway", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-store-gateway.sharding-ring.instance-availability-zone=zone-a", "-server.grpc-max-send-msg-size-bytes=209715200"]

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

          env {
            name  = "GOMEMLIMIT"
            value = "536870912"
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

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 120
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
              "app.kubernetes.io/component" = "store-gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-store-gateway-headless"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_store_gateway_zone_b" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "store-gateway"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "30m"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "store-gateway-zone-b"
      rollout-group                                  = "store-gateway"
      zone                                           = "zone-b"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "store-gateway/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-store-gateway-zone-a"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "store-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "store-gateway"
        zone                          = "zone-b"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "store-gateway"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "store-gateway-zone-b"
          rollout-group                  = "store-gateway"
          zone                           = "zone-b"
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
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "store-gateway"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=store-gateway", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-store-gateway.sharding-ring.instance-availability-zone=zone-b", "-server.grpc-max-send-msg-size-bytes=209715200"]

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

          env {
            name  = "GOMEMLIMIT"
            value = "536870912"
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

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 120
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
              "app.kubernetes.io/component" = "store-gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-store-gateway-headless"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_store_gateway_zone_c" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "store-gateway"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "30m"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "store-gateway-zone-c"
      rollout-group                                  = "store-gateway"
      zone                                           = "zone-c"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "store-gateway/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-store-gateway-zone-b"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "store-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "store-gateway"
        zone                          = "zone-c"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "store-gateway"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
          name                           = "store-gateway-zone-c"
          rollout-group                  = "store-gateway"
          zone                           = "zone-c"
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
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "store-gateway"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=store-gateway", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-store-gateway.sharding-ring.instance-availability-zone=zone-c", "-server.grpc-max-send-msg-size-bytes=209715200"]

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

          env {
            name  = "GOMEMLIMIT"
            value = "536870912"
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

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 120
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
              "app.kubernetes.io/component" = "store-gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-store-gateway-headless"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "OnDelete"
    }
  }
}

