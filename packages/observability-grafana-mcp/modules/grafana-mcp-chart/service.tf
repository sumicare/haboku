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


resource "kubernetes_service" "release_name_grafana_mcp" {
  metadata {
    name      = "release-name-grafana-mcp"
    namespace = "grafana-mcp"

    labels = {
      "app.kubernetes.io/component" = "mcp-server"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "grafana-mcp"
      "app.kubernetes.io/version"   = "0.7.8"
      "helm.sh/chart"               = "grafana-mcp-0.2.1"
    }
  }

  spec {
    port {
      name        = "mcp-http"
      protocol    = "TCP"
      port        = 8000
      target_port = "mcp-http"
    }

    selector = {
      "app.kubernetes.io/component" = "mcp-server"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "grafana-mcp"
    }

    type = "ClusterIP"
  }
}

