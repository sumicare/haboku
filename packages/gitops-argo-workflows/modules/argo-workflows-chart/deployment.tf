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


resource "kubernetes_deployment" "release_name_argo_workflows_workflow_controller" {
  metadata {
    name      = "release-name-argo-workflows-workflow-controller"
    namespace = "argo-workflows"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "app.kubernetes.io/version"    = "v3.7.3"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argo-workflows-workflow-controller"
      }
    }

    template {
      metadata {
        labels = {
          app                            = "workflow-controller"
          "app.kubernetes.io/component"  = "workflow-controller"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
          "app.kubernetes.io/part-of"    = "argo-workflows"
          "app.kubernetes.io/version"    = "v3.7.3"
          "helm.sh/chart"                = "argo-workflows-0.45.27"
        }
      }

      spec {
        container {
          name    = "controller"
          image   = "quay.io/argoproj/workflow-controller:v3.7.3"
          command = ["workflow-controller"]
          args    = ["--configmap", "release-name-argo-workflows-workflow-controller-configmap", "--executor-image", "quay.io/argoproj/argoexec:v3.7.3", "--loglevel", "info", "--gloglevel", "0", "--log-format", "text", "--workflow-workers", "32", "--workflow-ttl-workers", "4", "--pod-cleanup-workers", "4", "--cron-workflow-workers", "8"]

          port {
            name           = "metrics"
            container_port = 9090
          }

          port {
            container_port = 6060
          }

          env {
            name = "ARGO_NAMESPACE"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          env {
            name = "LEADER_ELECTION_IDENTITY"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }

          env {
            name  = "LEADER_ELECTION_DISABLE"
            value = "true"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "6060"
            }

            initial_delay_seconds = 90
            timeout_seconds       = 30
            period_seconds        = 60
            failure_threshold     = 3
          }

          image_pull_policy = "Always"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "release-name-argo-workflows-workflow-controller"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_argo_workflows_server" {
  metadata {
    name      = "release-name-argo-workflows-server"
    namespace = "argo-workflows"

    labels = {
      app                            = "server"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-server"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "app.kubernetes.io/version"    = "v3.7.3"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "argo-workflows-server"
      }
    }

    template {
      metadata {
        labels = {
          app                            = "server"
          "app.kubernetes.io/component"  = "server"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "argo-workflows-server"
          "app.kubernetes.io/part-of"    = "argo-workflows"
          "app.kubernetes.io/version"    = "v3.7.3"
          "helm.sh/chart"                = "argo-workflows-0.45.27"
        }

        annotations = {
          "checksum/cm" = "6d79e54bd750d7ba2f2a293800423b90a94a43f7db833ddd2800b6192dbd4a18"
        }
      }

      spec {
        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "argo-server"
          image = "quay.io/argoproj/argocli:v3.7.3"
          args  = ["server", "--configmap=release-name-argo-workflows-workflow-controller-configmap", "--auth-mode=sso", "--auth-mode=client", "--secure=true", "--loglevel", "info", "--gloglevel", "0", "--log-format", "text"]

          port {
            name           = "web"
            container_port = 2746
          }

          env {
            name  = "IN_CLUSTER"
            value = "true"
          }

          env {
            name = "ARGO_NAMESPACE"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          env {
            name  = "ARGO_BASE_HREF"
            value = "/"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = "2746"
              scheme = "HTTPS"
            }

            initial_delay_seconds = 10
            period_seconds        = 20
          }

          image_pull_policy = "Always"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_non_root = true
          }
        }

        termination_grace_period_seconds = 30

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "release-name-argo-workflows-server"

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "DoNotSchedule"

          label_selector {
            match_labels = {
              "app.kubernetes.io/instance" = "release-name"
              "app.kubernetes.io/name"     = "argo-workflows-server"
            }
          }
        }
      }
    }

    revision_history_limit = 10
  }
}

