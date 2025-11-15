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


# Prometheus Custom Resource for Prometheus Operator
# This replaces the ConfigMap-based Prometheus configuration

resource "kubernetes_manifest" "prometheus" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "Prometheus"

    metadata = {
      name      = "volcano-prometheus"
      namespace = "volcano"
      labels = {
        app       = "prometheus"
        component = "monitoring"
      }
    }

    spec = {
      replicas = 1

      serviceAccountName = "prometheus"

      serviceMonitorSelector = {
        matchLabels = {
          prometheus = "volcano"
        }
      }

      podMonitorSelector = {
        matchLabels = {
          prometheus = "volcano"
        }
      }

      ruleSelector = {
        matchLabels = {
          prometheus = "volcano"
        }
      }

      # Global configuration
      scrapeInterval     = "5s"
      evaluationInterval = "5s"

      # Alertmanager configuration
      alerting = {
        alertmanagers = [
          {
            namespace = "monitoring"
            name      = "alertmanager"
            port      = "web"
          }
        ]
      }

      # Resources
      resources = {
        requests = {
          memory = "400Mi"
          cpu    = "200m"
        }
        limits = {
          memory = "2Gi"
          cpu    = "1000m"
        }
      }

      # Storage
      storage = {
        volumeClaimTemplate = {
          spec = {
            accessModes = ["ReadWriteOnce"]
            resources = {
              requests = {
                storage = "10Gi"
              }
            }
          }
        }
      }

      # Security context
      securityContext = {
        fsGroup      = 2000
        runAsNonRoot = true
        runAsUser    = 1000
      }
    }
  }
}

# ServiceMonitor for Kubernetes API Server
resource "kubernetes_manifest" "servicemonitor_kubernetes_apiservers" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"

    metadata = {
      name      = "kubernetes-apiservers"
      namespace = "volcano"
      labels = {
        prometheus = "volcano"
      }
    }

    spec = {
      endpoints = [
        {
          port   = "https"
          scheme = "https"

          tlsConfig = {
            caFile             = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
            insecureSkipVerify = false
          }

          bearerTokenFile = "/var/run/secrets/kubernetes.io/serviceaccount/token"
        }
      ]

      selector = {
        matchLabels = {
          component = "apiserver"
          provider  = "kubernetes"
        }
      }

      namespaceSelector = {
        matchNames = ["default"]
      }
    }
  }
}

# ServiceMonitor for Kubernetes Nodes
resource "kubernetes_manifest" "servicemonitor_kubernetes_nodes" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"

    metadata = {
      name      = "kubernetes-nodes"
      namespace = "volcano"
      labels = {
        prometheus = "volcano"
      }
    }

    spec = {
      endpoints = [
        {
          port            = "https-metrics"
          scheme          = "https"
          interval        = "30s"
          bearerTokenFile = "/var/run/secrets/kubernetes.io/serviceaccount/token"

          tlsConfig = {
            caFile             = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
            insecureSkipVerify = false
          }

          relabelings = [
            {
              action = "labelmap"
              regex  = "__meta_kubernetes_node_label_(.+)"
            }
          ]
        }
      ]

      jobLabel = "kubernetes-nodes"

      selector = {}

      namespaceSelector = {
        any = true
      }
    }
  }
}

# PodMonitor for Kubernetes Pods with annotations
resource "kubernetes_manifest" "podmonitor_kubernetes_pods" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PodMonitor"

    metadata = {
      name      = "kubernetes-pods"
      namespace = "volcano"
      labels = {
        prometheus = "volcano"
      }
    }

    spec = {
      podMetricsEndpoints = [
        {
          interval = "30s"

          relabelings = [
            {
              sourceLabels = ["__meta_kubernetes_pod_annotation_prometheus_io_scrape"]
              action       = "keep"
              regex        = "true"
            },
            {
              sourceLabels = ["__meta_kubernetes_pod_annotation_prometheus_io_path"]
              action       = "replace"
              targetLabel  = "__metrics_path__"
              regex        = "(.+)"
            },
            {
              sourceLabels = ["__address__", "__meta_kubernetes_pod_annotation_prometheus_io_port"]
              action       = "replace"
              regex        = "([^:]+)(?::\\d+)?;(\\d+)"
              replacement  = "$1:$2"
              targetLabel  = "__address__"
            },
            {
              action = "labelmap"
              regex  = "__meta_kubernetes_pod_label_(.+)"
            },
            {
              sourceLabels = ["__meta_kubernetes_namespace"]
              action       = "replace"
              targetLabel  = "kubernetes_namespace"
            },
            {
              sourceLabels = ["__meta_kubernetes_pod_name"]
              action       = "replace"
              targetLabel  = "kubernetes_pod_name"
            }
          ]
        }
      ]

      selector = {}

      namespaceSelector = {
        any = true
      }
    }
  }
}

# ServiceMonitor for kube-state-metrics
resource "kubernetes_manifest" "servicemonitor_kube_state_metrics" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"

    metadata = {
      name      = "kube-state-metrics"
      namespace = "volcano"
      labels = {
        prometheus = "volcano"
      }
    }

    spec = {
      endpoints = [
        {
          port     = "http-metrics"
          interval = "30s"
        }
      ]

      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "kube-state-metrics"
        }
      }

      namespaceSelector = {
        matchNames = ["volcano"]
      }
    }
  }
}

# ServiceMonitor for cAdvisor
resource "kubernetes_manifest" "servicemonitor_kubernetes_cadvisor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"

    metadata = {
      name      = "kubernetes-cadvisor"
      namespace = "volcano"
      labels = {
        prometheus = "volcano"
      }
    }

    spec = {
      endpoints = [
        {
          port            = "https-metrics"
          path            = "/metrics/cadvisor"
          scheme          = "https"
          interval        = "30s"
          bearerTokenFile = "/var/run/secrets/kubernetes.io/serviceaccount/token"

          tlsConfig = {
            caFile             = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
            insecureSkipVerify = false
          }

          relabelings = [
            {
              action = "labelmap"
              regex  = "__meta_kubernetes_node_label_(.+)"
            }
          ]
        }
      ]

      jobLabel = "kubernetes-cadvisor"

      selector = {}

      namespaceSelector = {
        any = true
      }
    }
  }
}

# ServiceMonitor for Kubernetes Service Endpoints with annotations
resource "kubernetes_manifest" "servicemonitor_kubernetes_service_endpoints" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"

    metadata = {
      name      = "kubernetes-service-endpoints"
      namespace = "volcano"
      labels = {
        prometheus = "volcano"
      }
    }

    spec = {
      endpoints = [
        {
          interval = "30s"

          relabelings = [
            {
              sourceLabels = ["__meta_kubernetes_service_annotation_prometheus_io_scrape"]
              action       = "keep"
              regex        = "true"
            },
            {
              sourceLabels = ["__meta_kubernetes_service_annotation_prometheus_io_scheme"]
              action       = "replace"
              targetLabel  = "__scheme__"
              regex        = "(https?)"
            },
            {
              sourceLabels = ["__meta_kubernetes_service_annotation_prometheus_io_path"]
              action       = "replace"
              targetLabel  = "__metrics_path__"
              regex        = "(.+)"
            },
            {
              sourceLabels = ["__address__", "__meta_kubernetes_service_annotation_prometheus_io_port"]
              action       = "replace"
              targetLabel  = "__address__"
              regex        = "([^:]+)(?::\\d+)?;(\\d+)"
              replacement  = "$1:$2"
            },
            {
              action = "labelmap"
              regex  = "__meta_kubernetes_service_label_(.+)"
            },
            {
              sourceLabels = ["__meta_kubernetes_namespace"]
              action       = "replace"
              targetLabel  = "kubernetes_namespace"
            },
            {
              sourceLabels = ["__meta_kubernetes_service_name"]
              action       = "replace"
              targetLabel  = "kubernetes_name"
            }
          ]
        }
      ]

      selector = {}

      namespaceSelector = {
        any = true
      }
    }
  }
}
