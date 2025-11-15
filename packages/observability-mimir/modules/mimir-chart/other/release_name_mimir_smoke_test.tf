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


resource "kubernetes_job" "release_name_mimir_smoke_test" {
  metadata {
    name      = "release-name-mimir-smoke-test"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "smoke-test"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }

    annotations = {
      "helm.sh/hook" = "test"
    }
  }

  spec {
    parallelism   = 1
    completions   = 1
    backoff_limit = 5

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "smoke-test"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }
      }

      spec {
        container {
          name              = "smoke-test"
          image             = "grafana/mimir:3.0.0"
          args              = ["-target=continuous-test", "-activity-tracker.filepath=", "-tests.smoke-test", "-tests.write-endpoint=http://release-name-mimir-gateway.mimir.svc:80", "-tests.read-endpoint=http://release-name-mimir-gateway.mimir.svc:80/prometheus", "-tests.tenant-id=", "-tests.write-read-series-test.num-series=1000", "-tests.write-read-series-test.max-query-age=48h", "-server.http-listen-port=8080"]
          image_pull_policy = "IfNotPresent"
        }

        restart_policy       = "OnFailure"
        service_account_name = "release-name-mimir"

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
  }
}

