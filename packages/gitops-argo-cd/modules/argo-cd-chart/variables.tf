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
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_image" {
  description = "ArgoCD container image repository"
  type        = string
  default     = "quay.io/argoproj/argocd"
}

variable "argocd_version" {
  description = "Version of ArgoCD"
  type        = string
  default     = "v3.1.8"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "8.6.4"
}

variable "application_controller_replicas" {
  description = "Number of replicas for application controller"
  type        = number
  default     = 3
}

variable "applicationset_controller_replicas" {
  description = "Number of replicas for applicationset controller"
  type        = number
  default     = 3
}

variable "notifications_controller_replicas" {
  description = "Number of replicas for notifications controller"
  type        = number
  default     = 1
}

variable "repo_server_replicas" {
  description = "Number of replicas for repo server"
  type        = number
  default     = 3
}

variable "server_replicas" {
  description = "Number of replicas for server"
  type        = number
  default     = 3
}

variable "dex_server_replicas" {
  description = "Number of replicas for dex server"
  type        = number
  default     = 1
}

variable "redis_replicas" {
  description = "Number of replicas for redis"
  type        = number
  default     = 1
}
