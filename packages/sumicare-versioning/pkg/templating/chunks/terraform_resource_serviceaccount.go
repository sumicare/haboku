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

// TerraformResourceServiceAccount generates a Kubernetes ServiceAccount resource.
// Parameters:
//   - name: the resource name (e.g., "descheduler")
//   - dependencies: variable number of dependency resources (e.g., "data.kubernetes_namespace.descheduler")
func TerraformResourceServiceAccount(name string, dependencies ...string) string {
	return TerraformResourceServiceAccountNamed(name, "", "local.namespace", dependencies...)
}

// TerraformResourceServiceAccountNamed generates a Kubernetes ServiceAccount resource with custom naming.
// Parameters:
//   - name: the resource name (e.g., "operator")
//   - suffix: optional suffix for metadata name (e.g., "operator" -> "${local.app_name}-operator"), empty for no suffix
//   - namespace: the namespace reference (e.g., "local.namespace" or "var.namespace")
//   - dependencies: variable number of dependency resources
func TerraformResourceServiceAccountNamed(name, suffix, namespace string, dependencies ...string) string {
	var deps strings.Builder
	for i, dep := range dependencies {
		if i > 0 {
			deps.WriteString(",\n    ")
		}

		deps.WriteString(dep)
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
    ` + deps.String() + `
  ]`
	}

	return `resource "kubernetes_service_account" "` + name + `" {
  metadata {
    name      = ` + metadataName + `
    namespace = ` + namespace + `
    labels    = local.labels
  }` + dependsOnBlock + `
}`
}
