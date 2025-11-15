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


# Grafana Dashboard Provider as Custom Resource
# This replaces the ConfigMap-based dashboard provisioning with Grafana Operator CR

resource "kubernetes_manifest" "grafana_dashboard_provider" {
  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDashboard"

    metadata = {
      name      = "volcano-dashboard-provider"
      namespace = "volcano"
      labels = {
        app       = "grafana"
        component = "dashboard-provider"
      }
    }

    spec = {
      instanceSelector = {
        matchLabels = {
          dashboards = "volcano"
        }
      }

      folder       = "Volcano"
      resyncPeriod = "30s"

      datasources = [
        {
          inputName      = "DS_PROMETHEUS"
          datasourceName = "Prometheus"
        }
      ]
    }
  }
}

# Individual dashboard CRs for each dashboard JSON
resource "kubernetes_manifest" "grafana_dashboard_global_overview" {
  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDashboard"

    metadata = {
      name      = "volcano-global-overview"
      namespace = "volcano"
      labels = {
        app       = "grafana"
        dashboard = "volcano"
      }
    }

    spec = {
      instanceSelector = {
        matchLabels = {
          dashboards = "volcano"
        }
      }

      folder = "Volcano"
      json   = file("${path.module}/conf/volcano-global-overview-dashboard.json")
    }
  }
}

resource "kubernetes_manifest" "grafana_dashboard_namespace_overview" {
  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDashboard"

    metadata = {
      name      = "volcano-namespace-overview"
      namespace = "volcano"
      labels = {
        app       = "grafana"
        dashboard = "volcano"
      }
    }

    spec = {
      instanceSelector = {
        matchLabels = {
          dashboards = "volcano"
        }
      }

      folder = "Volcano"
      json   = file("${path.module}/conf/volcano-namespace-overview-dashboard.json")
    }
  }
}

resource "kubernetes_manifest" "grafana_dashboard_queue_overview" {
  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDashboard"

    metadata = {
      name      = "volcano-queue-overview"
      namespace = "volcano"
      labels = {
        app       = "grafana"
        dashboard = "volcano"
      }
    }

    spec = {
      instanceSelector = {
        matchLabels = {
          dashboards = "volcano"
        }
      }

      folder = "Volcano"
      json   = file("${path.module}/conf/volcano-queue-overview-dashboard.json")
    }
  }
}
