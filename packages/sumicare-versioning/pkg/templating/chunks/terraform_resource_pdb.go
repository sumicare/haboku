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

import (
	"strconv"
	"strings"
)

// TerraformResourcePDB generates a Kubernetes PodDisruptionBudget resource
// Parameters:
//   - name: the resource name (e.g., "descheduler")
//   - selector: selector labels for the PDB
//   - minAvailable: the minimum number of replicas that must be available
//   - maxUnavailable: the maximum number of replicas that can be unavailable
//   - dependencies: variable number of dependency resources
func TerraformResourcePDB(name, selector, minAvailable, maxUnavailable string, dependencies ...string) string {
	envs := []string{"prod", "staging"}
	envCondition := `contains(["` + strings.Join(envs, `", "`) + `"], var.env)`

	minAvailableToUse := `"` + minAvailable + `"`

	minAvailableNumber, err := strconv.Atoi(minAvailable)
	if err == nil {
		minAvailableToUse = strconv.Itoa(minAvailableNumber)
	}

	maxUnavailableToUse := `"` + maxUnavailable + `"`

	maxUnavailableNumber, err := strconv.Atoi(maxUnavailable)
	if err == nil {
		maxUnavailableToUse = strconv.Itoa(maxUnavailableNumber)
	}

	return `resource "kubernetes_pod_disruption_budget" "` + name + `" {
  for_each = ` + envCondition + ` ? toset(["` + name + `"]) : toset([])

  metadata {
    name      = each.value
    namespace = local.namespace
    labels    = local.labels
  }

  spec {
    selector {
      match_labels = ` + selector + `
    }

    min_available   = ` + minAvailableToUse + `
    max_unavailable = ` + maxUnavailableToUse + `
  }

  depends_on = [
    ` + strings.Join(dependencies, ",\n    ") + `
  ]
}`
}

// TerraformResourceCommonPDB generates a Kubernetes PodDisruptionBudget resource with
// common PodDistruption settings of min_available = 1 and max_unavailable = 30%
//
// Parameters:
//   - name: the resource name (e.g., "descheduler")
//   - dependencies: variable number of dependency resources
func TerraformResourceCommonPDB(name string, dependencies ...string) string {
	return TerraformResourcePDB(name, "local.selector_labels", "1", "30%", dependencies...)
}

// TerraformResourcePDBNamed generates a Kubernetes PodDisruptionBudget resource with custom naming.
// Parameters:
//   - name: the resource name (e.g., "operator")
//   - suffix: optional suffix for metadata name (e.g., "operator" -> "${local.app_name}-operator"), empty for no suffix
//   - namespace: the namespace reference (e.g., "local.namespace" or "var.namespace")
//   - selector: selector labels for the PDB (e.g., "local.operator_labels")
//   - replicasVar: the replicas variable for max_unavailable calculation (e.g., "var.operator_replicas")
//   - dependencies: variable number of dependency resources
func TerraformResourcePDBNamed(name, suffix, namespace, selector, replicasVar string, dependencies ...string) string {
	envs := []string{"prod", "staging"}
	envCondition := `contains(["` + strings.Join(envs, `", "`) + `"], var.env)`

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

	return `resource "kubernetes_pod_disruption_budget" "` + name + `" {
  for_each = ` + envCondition + ` ? toset(["` + name + `"]) : toset([])

  metadata {
    name      = ` + metadataName + `
    namespace = ` + namespace + `
    labels    = local.labels
  }

  spec {
    selector {
      match_labels = ` + selector + `
    }

    max_unavailable = ceil(` + replicasVar + ` / 2)
  }` + dependsOnBlock + `
}`
}
