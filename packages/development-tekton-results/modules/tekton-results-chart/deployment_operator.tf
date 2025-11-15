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


resource "kubernetes_deployment" "tekton_operator" {
  metadata {
    name      = local.app_name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = local.operator_labels
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    template {
      metadata {
        labels = local.operator_labels
      }

      spec {
        container {
          name  = "${local.app_name}-lifecycle"
          image = "${var.image}:v${var.tekton_operator_version}"
          args  = ["-controllers", "tektonconfig,tektonpipeline,tektontrigger,tektonhub,tektonchain,tektonresult,tektondashboard,manualapprovalgate,tektonpruner", "-unique-process-name", "${local.app_name}-lifecycle"]

          env {
            name  = "KUBERNETES_MIN_VERSION"
            value = "v1.0.0"
          }

          env {
            name = "SYSTEM_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name  = "OPERATOR_NAME"
            value = local.app_name
          }

          env {
            name  = "IMAGE_PIPELINES_PROXY"
            value = var.proxy_webhook_image
          }

          env {
            name  = "IMAGE_JOB_PRUNER_TKN"
            value = var.job_pruner_image
          }

          env {
            name  = "METRICS_DOMAIN"
            value = "tekton.dev/operator"
          }

          env {
            name  = "VERSION"
            value = "v${var.tekton_operator_version}"
          }

          env {
            name  = "CONFIG_OBSERVABILITY_NAME"
            value = "tekton-config-observability"
          }

          env {
            name  = "CONFIG_LEADERELECTION_NAME"
            value = "${local.app_name}-controller-config-leader-election"
          }

          env {
            name = "AUTOINSTALL_COMPONENTS"

            value_from {
              config_map_key_ref {
                name = "tekton-config-defaults"
                key  = "AUTOINSTALL_COMPONENTS"
              }
            }
          }

          env {
            name = "DEFAULT_TARGET_NAMESPACE"

            value_from {
              config_map_key_ref {
                name = "tekton-config-defaults"
                key  = "DEFAULT_TARGET_NAMESPACE"
              }
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "${local.app_name}-cluster-operations"
          image = "${var.image}:v${var.tekton_operator_version}@${var.operator_image_digest}"
          args  = ["-controllers", "tektoninstallerset", "-unique-process-name", "${local.app_name}-cluster-operations"]

          env {
            name  = "KUBERNETES_MIN_VERSION"
            value = "v1.0.0"
          }

          env {
            name = "SYSTEM_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name  = "OPERATOR_NAME"
            value = local.app_name
          }

          env {
            name  = "PROFILING_PORT"
            value = "9009"
          }

          env {
            name  = "VERSION"
            value = "v${var.tekton_operator_version}"
          }

          env {
            name  = "METRICS_DOMAIN"
            value = "tekton.dev/operator"
          }

          env {
            name  = "CONFIG_LEADERELECTION_NAME"
            value = "${local.app_name}-controller-config-leader-election"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        service_account_name = local.app_name

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "eks.amazonaws.com/compute-type"
                  operator = "NotIn"
                  values   = ["fargate", "auto"]
                }

                match_expressions {
                  key      = "lifecycle"
                  operator = "NotIn"
                  values   = ["Spot"]
                }
              }
            }
          }

          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = [local.app_name]
                  }

                  match_expressions {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["operator"]
                  }
                }

                topology_key = "kubernetes.io/hostname"
              }
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 50

              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = [local.app_name]
                  }

                  match_expressions {
                    key      = "app.kubernetes.io/component"
                    operator = "In"
                    values   = ["operator"]
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
          when_unsatisfiable = "DoNotSchedule"

          label_selector {
            match_labels = local.operator_labels
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = local.operator_labels
          }
        }
      }
    }

    revision_history_limit = var.revision_history_limit
  }

  lifecycle {
    # This is managed by VPA recommender
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].resources.requests,
      spec[0].template[0].spec[0].container[0].resources.limits,
    ]
  }
}
