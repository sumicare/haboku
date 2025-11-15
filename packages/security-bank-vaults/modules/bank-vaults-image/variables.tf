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

###           DO NOT EDIT            ###
# This file is automagically generated #

variable "org" {
  description = "Organization Name, used for image tagging."
  type        = string
  default     = "sumicare"
}

variable "repository" {
  description = "Image repository path, with trailing '/'."
  type        = string
  default     = "docker.io/"
}

variable "registry_auth" {
  description = "Docker registry auth configuration, to push images into."
  type = object({
    address  = string
    username = string
    password = string
  })
  default = null
}

variable "debian_version" {
  description = "Debian Version to build distroless image from."
  type        = string
  default     = "trixie-20251117-slim"
}

variable "bank_vaults_webhook_version" {
  description = "Version of Bank Vaults Webhook"
  type        = string
  default     = "0.3.0"
}
