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
  description = "Kubernetes namespace for Dex"
  type        = string
  default     = "dex"
}

variable "dex_version" {
  description = "Version of Dex"
  type        = string
  default     = "2.44.0"
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 1
}

variable "image" {
  description = "Container image for Dex"
  type        = string
  default     = "ghcr.io/dexidp/dex"
}

variable "http_port" {
  description = "HTTP port for Dex"
  type        = number
  default     = 5556
}

variable "telemetry_port" {
  description = "Telemetry port for Dex"
  type        = number
  default     = 5558
}

variable "revision_history_limit" {
  description = "Revision history limit for deployment"
  type        = number
  default     = 10
}

variable "config_secret_data" {
  description = "Dex configuration secret data"
  type        = string
  default     = "{}"
}
