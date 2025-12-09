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


resource "kubernetes_cron_job_v1" "linkerd_heartbeat" {
  metadata {
    name      = "linkerd-heartbeat"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "heartbeat"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "heartbeat"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    schedule           = "40 10 * * *"
    concurrency_policy = "Replace"

    job_template {
      metadata {}

      spec {
        template {
          metadata {
            labels = {
              "linkerd.io/control-plane-component" = "heartbeat"
              "linkerd.io/workload-ns"             = "linkerd"
            }

            annotations = {
              "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
            }
          }

          spec {
            volume {
              name = "kube-api-access"

              projected {
                sources {
                  service_account_token {
                    expiration_seconds = 3607
                    path               = "token"
                  }
                }

                sources {
                  config_map {
                    name = "kube-root-ca.crt"

                    items {
                      key  = "ca.crt"
                      path = "ca.crt"
                    }
                  }
                }

                sources {
                  downward_api {
                    items {
                      path = "namespace"

                      field_ref {
                        api_version = "v1"
                        field_path  = "metadata.namespace"
                      }
                    }
                  }
                }

                default_mode = "0644"
              }
            }

            container {
              name  = "heartbeat"
              image = "cr.l5d.io/linkerd/controller:edge-25.8.5@sha256:f184bafbea2e4b535a68f9e57ae2bcb756ac156189c7e694a769ed5e364dd4f6"
              args  = ["heartbeat", "-controller-namespace=linkerd", "-log-level=info", "-log-format=plain", "-prometheus-url=http://prometheus.linkerd-viz.svc.cluster.local:9090"]

              env {
                name  = "LINKERD_DISABLED"
                value = "the heartbeat controller does not use the proxy"
              }

              volume_mount {
                name       = "kube-api-access"
                read_only  = true
                mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
              }

              image_pull_policy = "IfNotPresent"

              security_context {
                capabilities {
                  drop = ["ALL"]
                }

                run_as_user               = 2103
                run_as_non_root           = true
                read_only_root_filesystem = true

                seccomp_profile {
                  type = "RuntimeDefault"
                }
              }
            }

            restart_policy = "Never"

            node_selector = {
              "kubernetes.io/os" = "linux"
            }

            service_account_name = "linkerd-heartbeat"

            security_context {
              seccomp_profile {
                type = "RuntimeDefault"
              }
            }
          }
        }
      }
    }
  }
}

