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


resource "kubernetes_manifest" "volcano_prometheus_rule" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PrometheusRule"

    metadata = {
      name      = "volcano-alerts"
      namespace = "volcano"
      labels = {
        app        = "volcano"
        component  = "monitoring"
        prometheus = "volcano"
      }
    }

    spec = {
      groups = [
        {
          name = "volcano"
          rules = [
            {
              alert = "HighPodMemory"
              expr  = "sum(container_memory_usage_bytes{namespace=\"volcano-system\"}) > 1073741824"
              for   = "5m"
              labels = {
                severity = "warning"
              }
              annotations = {
                summary     = "High Memory Usage in Volcano"
                description = "Volcano system pods are using {{ $value | humanize }} bytes of memory"
              }
            }
          ]
        }
      ]
    }
  }
}
