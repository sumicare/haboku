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


resource "kubernetes_deployment" "release_name_external_dns" {
  metadata {
    name      = "release-name-external-dns"
    namespace = "external-dns"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "external-dns"
      "app.kubernetes.io/version"    = "0.19.0"
      "helm.sh/chart"                = "external-dns-1.19.0"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "external-dns"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "external-dns"
        }
      }

      spec {
        container {
          name  = "external-dns"
          image = "registry.k8s.io/external-dns/external-dns:v0.19.0"
          args  = ["--log-level=info", "--log-format=text", "--interval=1m", "--source=service", "--source=ingress", "--policy=upsert-only", "--registry=txt", "--provider=aws"]

          port {
            name           = "http"
            container_port = 7979
            protocol       = "TCP"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 2
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 65532
            run_as_group              = 65532
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        service_account_name            = "release-name-external-dns"
        automount_service_account_token = true

        security_context {
          run_as_non_root = true
          fs_group        = 65534

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

