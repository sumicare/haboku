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


resource "kubernetes_stateful_set" "release_name_tempo_ingester" {
  metadata {
    name      = "release-name-tempo-ingester"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "ingester"
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
          name      = "data"
          empty_dir = {}
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=ingester", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "grpc"
            container_port = 9095
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
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
            name       = "data"
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

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "ingester"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "kubernetes.io/hostname"
              }
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 75

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "ingester"
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
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    service_name           = "ingester"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_tempo_memcached" {
  metadata {
    name      = "release-name-tempo-memcached"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
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
        "app.kubernetes.io/component" = "memcached"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "memcached"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "docker.io/memcached:1.6.39-alpine"

          port {
            name           = "client"
            container_port = 11211
          }

          liveness_probe {
            exec {
              command = ["pgrep", "memcached"]
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            success_threshold     = 1
            failure_threshold     = 6
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

        service_account_name = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "memcached"
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
                    "app.kubernetes.io/component" = "memcached"
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
              "app.kubernetes.io/component" = "memcached"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    service_name = "memcached"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

