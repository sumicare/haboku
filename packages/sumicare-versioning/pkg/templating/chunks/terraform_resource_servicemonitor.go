//
// Copyright (c) 2025 Sumicare
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package chunks

import "strings"

// TerraformResourceServiceMonitorSimple generates a simple Kubernetes ServiceMonitor resource.
// Parameters:
//   - name: the resource name (e.g., "operator")
//   - suffix: optional suffix for metadata name (e.g., "operator" -> "${local.app_name}-operator"), empty for no suffix
//   - namespace: the namespace reference for namespaceSelector (e.g., "var.namespace")
//   - selector: selector labels for the ServiceMonitor (e.g., "local.operator_labels")
//   - port: the port name for metrics (e.g., "metrics")
//   - path: the metrics path (e.g., "/metrics")
//   - scheme: the scheme to use (e.g., "http" or "https")
func TerraformResourceServiceMonitorSimple(name, suffix, namespace, selector, port, path, scheme string) string {
	// Determine metadata name
	metadataName := localAppName
	if suffix != "" {
		metadataName = `"${local.app_name}-` + suffix + `"`
	}

	return `resource "kubernetes_manifest" "servicemonitor_` + name + `" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      labels = local.labels
      name   = ` + metadataName + `
    }
    spec = {
      endpoints = [
        {
          path   = "` + path + `"
          port   = "` + port + `"
          scheme = "` + scheme + `"
        },
      ]
      namespaceSelector = {
        matchNames = [
          ` + namespace + `
        ]
      }
      selector = {
        matchLabels = ` + selector + `
      }
    }
  }
}`
}

// TerraformResourceServiceMonitor generates a Kubernetes ServiceMonitor resource for Prometheus monitoring.
//
//nolint:revive // tlsInsecureSkipVerify is not a control flag
func TerraformResourceServiceMonitor(name, metricsRegex, metricsPort, scheme string, tlsInsecureSkipVerify bool, dependencies ...string) string {
	tlsConfig := ""
	if tlsInsecureSkipVerify {
		tlsConfig = `
          "tlsConfig" = {
            "insecureSkipVerify" = true
          }`
	}

	return `resource "kubernetes_manifest" "servicemonitor" {
  for_each = var.deploy_custom_resources ? toset(["` + name + `"]) : toset([])

  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "ServiceMonitor"
    "metadata" = {
      "labels" = merge(local.labels, {
        "monitoring" = "` + name + `"
      })
      "name"      = local.app_name
      "namespace" = var.monitoring_namespace
    }
    "spec" = {
      "endpoints" = [
        {
          "honorLabels" = true
          "metricRelabelings" = [
            {
              "action" = "keep"
              "regex"  = "` + metricsRegex + `"
              "sourceLabels" = [
                "__name__",
              ]
            },
          ]
          "port" = "` + metricsPort + `"
          "relabelings" = [
            {
              "action"      = "replace"
              "regex"       = "^(.*)$"
              "replacement" = "$1"
              "separator"   = ";"
              "sourceLabels" = [
                "__meta_kubernetes_pod_node_name",
              ]
              "targetLabel" = "nodename"
            },
          ]
          "scheme" = "` + scheme + `"` + tlsConfig + `
        },
      ]
      "jobLabel" = "jobLabel"
      "namespaceSelector" = {
        "matchNames" = [
          local.namespace,
        ]
      }
      "selector" = {
        "matchLabels" = local.selector_labels
      }
    }
  }

  depends_on = [
    ` + strings.Join(dependencies, ",\n    ") + `
  ]
}`
}
