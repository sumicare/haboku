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


resource "kubernetes_horizontal_pod_autoscaler" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/component"  = "availability"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    scale_target_ref {
      kind        = "deployment"
      name        = "release-name-alloy"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 5

    metric {
      type = "Resource"

      resource {
        name = "memory"

        target {
          type                = "Utilization"
          average_utilization = 80
        }
      }
    }

    behavior {
      scale_down {
        stabilization_window_seconds = 300
      }
    }
  }
}

