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

// ServicePort represents a single port configuration for a Kubernetes Service.
type ServicePort struct {
	Name        string
	Protocol    string
	Port        string
	TargetPort  string // Optional: if empty, uses tostring(var.<port_var>_port)
	PortVar     string // Optional: if empty, uses var.<name>_port
	AppProtocol string // Optional: app_protocol for the port (e.g., "http", "https")
}

// TerraformVariableOrg returns the organization variable.
func TerraformVariableOrg() string {
	return `variable "org" {
  description = "Organization Name, used for image tagging."
  type        = string
  default     = "sumicare"
}`
}

// TerraformVariableRepository returns the repository variable.
func TerraformVariableRepository() string {
	return `variable "repository" {
  description = "Image repository path, with trailing '/'."
  type        = string
  default     = "docker.io/"
}`
}

// TerraformVariableEnv returns the environment variable for charts.
func TerraformVariableEnv() string {
	return `variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "Env must be one of dev, staging, or prod."
  }
}`
}

// TerraformVariableDebianVersion returns the debian version variable.
func TerraformVariableDebianVersion(debianVersion string) string {
	return `variable "debian_version" {
  description = "Debian Version to build distroless image from."
  type        = string
  default     = "` + debianVersion + `"
}`
}

// TerraformVariableRegistryAuth returns the docker registry auth variable.
func TerraformVariableRegistryAuth() string {
	return `variable "registry_auth" {
  description = "Docker registry auth configuration, to push images into."
  type = object({
    address  = string
    username = string
    password = string
  })
  default = null
}`
}

// TerraformVariableReplicas returns the replicas variable for deployments.
func TerraformVariableReplicas() string {
	return `variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 3
}`
}

// TerraformVariableDeployCustomResources returns the deploy custom resources variable.
func TerraformVariableDeployCustomResources() string {
	return `variable "deploy_custom_resources" {
  description = "Deploy custom resources"
  type        = bool
  default     = true
}`
}

// TerraformVariableMonitoringNamespace returns the monitoring namespace variable.
func TerraformVariableMonitoringNamespace() string {
	return `variable "monitoring_namespace" {
  description = "Namespace for observability custom resources"
  type        = string
  default     = "monitoring"
}`
}

// TerraformVariableResources returns the resources variable for containers.
func TerraformVariableResources() string {
	return `variable "resources" {
  description = "Resource requests and limits for the container"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "100m"
      memory = "64Mi"
    }
    limits = {
      cpu    = "250m"
      memory = "512Mi"
    }
  }
}`
}

// TerraformVariableProbeTimeouts returns the probe timeout variables.
func TerraformVariableProbeTimeouts() string {
	return `variable "probe_initial_delay" {
  description = "Initial delay for liveness/readiness probes"
  type        = number
  default     = 1
}

variable "probe_timeout" {
  description = "Timeout for liveness/readiness probes"
  type        = number
  default     = 2
}

variable "probe_period" {
  description = "Period for liveness/readiness probes"
  type        = number
  default     = 5
}

variable "probe_failure_threshold" {
  description = "Failure threshold for liveness/readiness probes"
  type        = number
  default     = 2
}`
}

// TerraformVariableRunAsUserGroup returns the run as user group variable.
func TerraformVariableRunAsUserGroup() string {
	return `variable "run_as_user" {
  description = "User user ID to run the container as"
  type        = number
  default     = 65532
}

variable "run_as_group" {
  description = "User group ID to run the container as"
  type        = number
  default     = 65532
}

variable "fs_group" {
  description = "Filesystem group ID for pod volumes"
  type        = number
  default     = 65532
}`
}

// TerraformVariablesChart returns common terraform variables for chart modules.
func TerraformVariablesChart() string {
	return TerraformVariableOrg() + newNewLine + TerraformVariableRepository() + newNewLine + TerraformVariableEnv()
}

// TerraformVariablesImage returns common terraform variables for image modules.
func TerraformVariablesImage(debianVersion string) string {
	return TerraformVariableOrg() + newNewLine + TerraformVariableRepository() + newNewLine +
		TerraformVariableRegistryAuth() + newNewLine + TerraformVariableDebianVersion(debianVersion)
}

// TerraformVariableRevisionHistoryLimit returns the revision history limit variable.
func TerraformVariableRevisionHistoryLimit() string {
	return `variable "revision_history_limit" {
  description = "Revision history limit for the deployment"
  type        = number
  default     = 10
}`
}

// TerraformNumberVariable generates a number Terraform variable
//
// Parameters:
//   - name: the variable name with hyphens (e.g., "http-metrics")
//   - description: the variable description
//   - defaultValue: the default port number as string
func TerraformNumberVariable(name, description, defaultValue string) string {
	varName := strings.ReplaceAll(name, "-", "_")

	return `variable "` + varName + `" {
  description = "` + description + `"
  type        = number
  default     = ` + defaultValue + `
}`
}

// TerraformVariablePort generates a port number Terraform variable.
// Parameters:
//   - name: the port name (e.g., "metrics", "operator")
//   - description: the variable description
//   - defaultValue: the default port number as string
func TerraformVariablePort(name, description, defaultValue string) string {
	varName := strings.ReplaceAll(name, "-", "_") + "_port"

	return `variable "` + varName + `" {
  description = "` + description + `"
  type        = number
  default     = ` + defaultValue + `
}`
}

// TerraformVariableClusterDomain returns the cluster domain variable.
func TerraformVariableClusterDomain() string {
	return `variable "cluster_domain" {
  description = "Kubernetes cluster domain"
  type        = string
  default     = "cluster.local"
}`
}

// TerraformVariableTLSIssuers returns the TLS issuer variables for cert-manager.
// Parameters:
//   - prefix: optional prefix for variable names (e.g., "operator" -> "operator_issuer_name")
func TerraformVariableTLSIssuers(prefix string) string {
	issuerVar := "issuer_name"
	selfsignedVar := "selfsigned_issuer_name"
	issuerDesc := "Name of the cert-manager Issuer for TLS certificates"
	selfsignedDesc := "Name of the cert-manager Issuer for self-signed CA certificates"

	if prefix != "" {
		issuerVar = prefix + "_" + issuerVar
		selfsignedVar = prefix + "_" + selfsignedVar
	}

	return `variable "` + issuerVar + `" {
  description = "` + issuerDesc + `"
  type        = string
  default     = null
}

variable "` + selfsignedVar + `" {
  description = "` + selfsignedDesc + `"
  type        = string
  default     = null
}`
}

// TerraformVariablesTLS returns all TLS-related variables (cluster_domain + issuers).
// Parameters:
//   - prefix: optional prefix for issuer variable names (e.g., "" or "operator")
func TerraformVariablesTLS(prefix string) string {
	return TerraformVariableClusterDomain() + newNewLine + TerraformVariableTLSIssuers(prefix)
}
