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


resource "kubernetes_deployment" "tigera_operator" {
  metadata {
    name      = "tigera-operator"
    namespace = "argocd"

    labels = {
      k8s-app = "tigera-operator"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "tigera-operator"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "tigera-operator"
          name    = "tigera-operator"
        }
      }

      spec {
        volume {
          name = "var-lib-calico"

          host_path {
            path = "/var/lib/calico"
          }
        }

        container {
          name    = "tigera-operator"
          image   = "quay.io/tigera/operator:v1.40.0"
          command = ["operator"]
          args    = ["-manage-crds=true"]

          env_from {
            config_map_ref {
              name     = "kubernetes-services-endpoint"
              optional = true
            }
          }

          env {
            name = "WATCH_NAMESPACE"
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
            value = "tigera-operator"
          }

          env {
            name  = "TIGERA_OPERATOR_INIT_IMAGE_VERSION"
            value = "v1.40.0"
          }

          volume_mount {
            name       = "var-lib-calico"
            read_only  = true
            mount_path = "/var/lib/calico"
          }

          image_pull_policy = "IfNotPresent"
        }

        termination_grace_period_seconds = 60
        dns_policy                       = "ClusterFirstWithHostNet"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "tigera-operator"
        host_network         = true

        toleration {
          operator = "Exists"
          effect   = "NoExecute"
        }

        toleration {
          operator = "Exists"
          effect   = "NoSchedule"
        }
      }
    }
  }
}

