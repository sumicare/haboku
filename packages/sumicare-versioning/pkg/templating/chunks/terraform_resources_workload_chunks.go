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

import "strconv"

// ProbeType probe type string enum alias.
type ProbeType string

const (
	// ProbeTypeStartup startup probe.
	ProbeTypeStartup ProbeType = "startup"
	// ProbeTypeLiveness liveness probe.
	ProbeTypeLiveness ProbeType = "liveness"
	// ProbeTypeReadiness readiness probe.
	ProbeTypeReadiness ProbeType = "readiness"
)

// Probe returns a probe configuration.
func Probe(probeType ProbeType, probePath, probePort, probeScheme string) string {
	return `
` + string(probeType) + `_probe {
	http_get {
		path   = "` + probePath + `"
		port   = "` + probePort + `"
		scheme = "` + probeScheme + `"
	}

	initial_delay_seconds = var.probe_initial_delay
	timeout_seconds       = var.probe_timeout
	period_seconds        = var.probe_period
	success_threshold     = 1
	failure_threshold     = var.probe_failure_threshold
}`
}

// ContainerSecurityContext returns a container security context configuration.
func ContainerSecurityContext() string {
	return `
security_context {
	capabilities {
		drop = ["ALL"]
	}

	read_only_root_filesystem = true
}`
}

// PodSecurityContext returns a pod security context configuration.
func PodSecurityContext() string {
	return `
security_context {
	run_as_non_root = true
	run_as_user     = var.run_as_user
	run_as_group    = var.run_as_group
	fs_group        = var.fs_group
}`
}

// ContainerResources returns the container resources block.
func ContainerResources() string {
	return `
resources {
            limits = {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }

            requests = {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }
          }`
}

// NotFargateSelector returns a node selector configuration.
func NotFargateSelector() string {
	return `match_expressions {
	key      = "eks.amazonaws.com/compute-type"
	operator = "NotIn"
	values   = ["fargate", "auto"]
}`
}

// NotSpotSelector returns a node selector configuration.
func NotSpotSelector() string {
	return `match_expressions {
	key      = "lifecycle"
	operator = "NotIn"
	values   = ["Spot"]
}
	
match_expressions {
	key      = "cloud.google.com/gke-spot"
	operator = "NotIn"
	values   = ["true"]
}`
}

// PodAntiAffinity returns a pod anti affinity configuration.
// Parameters:
//   - selector: label selector (e.g., "local.selector_labels" or "local.controller_labels")
//   - weight: scheduling weight (e.g., 100 for node, 50 for zone)
//   - topologyKey: topology key (e.g., "kubernetes.io/hostname" or "topology.kubernetes.io/zone")
func PodAntiAffinity(selector string, weight int, topologyKey string) string {
	return `
preferred_during_scheduling_ignored_during_execution {
	weight = ` + strconv.Itoa(weight) + `

	pod_affinity_term {
	label_selector {
		match_labels = ` + selector + `
	}

	topology_key = "` + topologyKey + `"
	}
}`
}

// TopologySpreadConstraint returns a pod topology spread constraint configuration.
// Parameters:
//   - selector: label selector (e.g., "local.selector_labels" or "local.controller_labels")
//   - maxSkew: maximum difference in pod count
//   - topologyKey: topology key (e.g., "topology.kubernetes.io/zone")
//   - whenUnsatisfiable: action when constraint cannot be satisfied (e.g., "ScheduleAnyway", "DoNotSchedule")
func TopologySpreadConstraint(selector string, maxSkew int, topologyKey, whenUnsatisfiable string) string {
	return `
topology_spread_constraint {
          max_skew           = ` + strconv.Itoa(maxSkew) + `
          topology_key       = "` + topologyKey + `"
          when_unsatisfiable = "` + whenUnsatisfiable + `"

          label_selector {
            match_labels = ` + selector + `
          }
        }`
}

// DeploymentRollingUpdate returns a deployment rolling update configuration.
func DeploymentRollingUpdate(pct int) string {
	return `strategy {
	type = "RollingUpdate"

	rolling_update {
		max_unavailable = "` + strconv.Itoa(pct) + `%"
		max_surge       = "` + strconv.Itoa(pct) + `%"
	}
}`
}
