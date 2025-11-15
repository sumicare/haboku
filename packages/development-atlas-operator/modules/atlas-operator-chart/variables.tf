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


variable "org" {
  description = "Organization Name"
  type        = string
  default     = "sumicare"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of dev, staging, or prod"
  }
}

variable "namespace" {
  description = "Kubernetes namespace for Atlas Operator"
  type        = string
  default     = "default"
}

variable "atlas_operator_version" {
  description = "Version of Atlas Operator"
  type        = string
  default     = "0.7.11"
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 3
}

variable "image" {
  description = "Container image for Atlas Operator"
  type        = string
  default     = "arigaio/atlas-operator"
}

variable "prewarm_devdb" {
  description = "Enable prewarming of dev database"
  type        = bool
  default     = true
}

variable "allow_custom_config" {
  description = "Allow custom configuration"
  type        = bool
  default     = false
}

variable "run_as_user" {
  description = "User ID to run the container as"
  type        = number
  default     = 1000
}

variable "liveness_probe_initial_delay" {
  description = "Initial delay for liveness probe in seconds"
  type        = number
  default     = 15
}

variable "liveness_probe_period" {
  description = "Period for liveness probe in seconds"
  type        = number
  default     = 20
}

variable "readiness_probe_initial_delay" {
  description = "Initial delay for readiness probe in seconds"
  type        = number
  default     = 5
}

variable "readiness_probe_period" {
  description = "Period for readiness probe in seconds"
  type        = number
  default     = 10
}

variable "termination_grace_period_seconds" {
  description = "Termination grace period in seconds"
  type        = number
  default     = 10
}
