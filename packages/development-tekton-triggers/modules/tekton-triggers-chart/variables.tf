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
  description = "Kubernetes namespace for Tekton Operator"
  type        = string
  default     = "tekton-operator"
}

variable "tekton_operator_version" {
  description = "Version of Tekton Operator"
  type        = string
  default     = "0.74.0"
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 3
}

variable "image" {
  description = "Container image for Tekton Operator"
  type        = string
  default     = "gcr.io/tekton-releases/github.com/tektoncd/operator/cmd/kubernetes/operator"
}

variable "revision_history_limit" {
  description = "Revision history limit for deployment"
  type        = number
  default     = 10
}

variable "webhook_image" {
  description = "Container image for Tekton Operator Webhook"
  type        = string
  default     = "ghcr.io/tektoncd/operator/webhook-f2bb711aa8f0c0892856a4cbf6d9ddd8"
}

variable "proxy_webhook_image" {
  description = "Container image for Tekton Pipelines Proxy Webhook"
  type        = string
  default     = "ghcr.io/tektoncd/operator/proxy-webhook-f6167da7bc41b96a27c5529f850e63d1:v0.77.0@sha256:ae7240e5c0683fd513de469d59400010d8b0ecdb946eeffbf0b15a5fe6540faf"
}

variable "job_pruner_image" {
  description = "Container image for Tekton Job Pruner"
  type        = string
  default     = "ghcr.io/tektoncd/plumbing/tkn@sha256:233de6c8b8583a34c2379fa98d42dba739146c9336e8d41b66030484357481ed"
}

variable "cluster_domain" {
  description = "Kubernetes cluster domain"
  type        = string
  default     = "cluster.local"
}
