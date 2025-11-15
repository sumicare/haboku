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


resource "kubernetes_deployment" "release_name_tempo_compactor" {
  metadata {
    name      = "release-name-tempo-compactor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "compactor"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "ac2f9ac2f4342a589e5897602e07d47f85c41bee0102380d0b50c4514aa08b66"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-compactor-store"
          empty_dir = {}
        }

        container {
          name  = "compactor"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=compactor", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-compactor-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "compactor"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "compactor"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
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

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_distributor" {
  metadata {
    name      = "release-name-tempo-distributor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "distributor"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "ac2f9ac2f4342a589e5897602e07d47f85c41bee0102380d0b50c4514aa08b66"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-distributor-store"
          empty_dir = {}
        }

        container {
          name  = "distributor"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=distributor", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-distributor-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "distributor"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "distributor"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "distributor"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
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

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_querier" {
  metadata {
    name      = "release-name-tempo-querier"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "querier"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "ac2f9ac2f4342a589e5897602e07d47f85c41bee0102380d0b50c4514aa08b66"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-querier-store"
          empty_dir = {}
        }

        container {
          name  = "querier"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=querier", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-querier-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "querier"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "querier"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "querier"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
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

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_query_frontend" {
  metadata {
    name      = "release-name-tempo-query-frontend"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "query-frontend"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "ac2f9ac2f4342a589e5897602e07d47f85c41bee0102380d0b50c4514aa08b66"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-queryfrontend-store"
          empty_dir = {}
        }

        container {
          name  = "query-frontend"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=query-frontend", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          port {
            name           = "grpc"
            container_port = 9095
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-queryfrontend-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "query-frontend"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "query-frontend"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "query-frontend"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
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

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

