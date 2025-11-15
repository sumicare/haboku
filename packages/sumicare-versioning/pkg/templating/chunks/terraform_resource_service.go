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

const (
	// minPortParts is the minimum number of parts required for a port mapping.
	minPortParts = 3
	// partsWithTargetPort is the number of parts when target port is included.
	partsWithTargetPort = 4
	// partsWithAppProtocol is the number of parts when app protocol is included.
	partsWithAppProtocol = 5
)

// parsePortMapping parses a port mapping string into ServicePort structs.
// Format: "name--protocol--port--target_port--app_protocol,name2--protocol2--port2--target_port2--app_protocol2"
// Example: "http-metrics--TCP--8080--http-metrics--http,https--TCP--443--8443--https".
func parsePortMapping(portMapping string) []ServicePort {
	if portMapping == "" {
		return nil
	}

	portMappingChunks := strings.Split(portMapping, ",")

	ports := make([]ServicePort, 0, len(portMappingChunks))
	for i := range portMappingChunks {
		parts := strings.Split(portMappingChunks[i], "--")
		if len(parts) < minPortParts {
			continue
		}

		port := ServicePort{
			Name:     parts[0],
			Protocol: parts[1],
			Port:     parts[2],
			PortVar:  "var." + strings.ReplaceAll(parts[0], "-", "_") + "_port",
		}

		if len(parts) >= partsWithTargetPort {
			port.TargetPort = parts[partsWithTargetPort-1]
		}

		if len(parts) >= partsWithAppProtocol {
			port.AppProtocol = parts[partsWithAppProtocol-1]
		}

		ports = append(ports, port)
	}

	return ports
}

// TerraformResourceService generates a Kubernetes Service resource with configurable ports.
// Parameters:
//   - name: the resource name (e.g., "descheduler")
//   - portMapping: port mapping string in format "name--protocol--port--target_port--app_protocol,..."
//   - clusterIP: the cluster IP setting (e.g., "None" for headless service, or "" for default)
//   - serviceType: the service type (e.g., "ClusterIP", "LoadBalancer", "NodePort")
//   - dependencies: variable number of dependency resources (e.g., "kubernetes_deployment.descheduler", "data.kubernetes_namespace.descheduler")
func TerraformResourceService(name, portMapping, clusterIP, serviceType string, dependencies ...string) string {
	return TerraformResourceServiceNamed(name, "", "local.namespace", "local.selector_labels", portMapping, clusterIP, serviceType, dependencies...)
}

// TerraformResourceServiceNamed generates a Kubernetes Service resource with configurable naming and selectors.
// Parameters:
//   - name: the resource name (e.g., "dashboard")
//   - suffix: optional suffix for metadata name (e.g., "dashboard" -> "${local.app_name}-dashboard"), empty for no suffix
//   - namespace: the namespace reference (e.g., "local.namespace" or "var.namespace")
//   - selector: the selector labels reference (e.g., "local.selector_labels" or "local.dashboard_labels")
//   - portMapping: port mapping string in format "name--protocol--port--target_port,name2--protocol2--port2--target_port2"
//   - clusterIP: the cluster IP setting (e.g., "None" for headless service, or "" for default)
//   - serviceType: the service type (e.g., "ClusterIP", "LoadBalancer", "NodePort")
//   - dependencies: variable number of dependency resources
func TerraformResourceServiceNamed(name, suffix, namespace, selector, portMapping, clusterIP, serviceType string, dependencies ...string) string {
	ports := parsePortMapping(portMapping)

	var portBlocks strings.Builder

	for i := range ports {
		// Determine target port
		targetPort := ports[i].TargetPort
		if targetPort == "" {
			targetPort = "tostring(" + ports[i].PortVar + ")"
		} else {
			targetPort = `"` + targetPort + `"`
		}

		// Build app_protocol line if specified
		appProtocolLine := ""
		if ports[i].AppProtocol != "" {
			appProtocolLine = `
      app_protocol = "` + ports[i].AppProtocol + `"`
		}

		portBlocks.WriteString(`
    port {
      name        = "` + ports[i].Name + `"
      protocol    = "` + ports[i].Protocol + `"
      port        = ` + ports[i].Port + `
      target_port = ` + targetPort + appProtocolLine + `
    }
`)
	}

	clusterIPLine := ""
	if clusterIP != "" {
		clusterIPLine = `
    cluster_ip = "` + clusterIP + `"`
	}

	// Determine metadata name
	metadataName := localAppName
	if suffix != "" {
		metadataName = `"${local.app_name}-` + suffix + `"`
	}

	dependsOnBlock := ""
	if len(dependencies) > 0 {
		dependsOnBlock = `

  depends_on = [
    ` + strings.Join(dependencies, ",\n    ") + `
  ]`
	}

	return `resource "kubernetes_service" "` + name + `" {
  metadata {
    name      = ` + metadataName + `
    namespace = ` + namespace + `
    labels    = local.labels
  }

  spec {` + portBlocks.String() + `
    selector = ` + selector + clusterIPLine + `
    type     = "` + serviceType + `"
  }` + dependsOnBlock + `
}`
}
