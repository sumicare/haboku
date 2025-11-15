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

variable "repository" {
  description = "Image repository path, WITH trailing /"
  type        = string
  default     = "docker.io/"
}

variable "registry_auth" {
  description = "Docker registry auth configuration"
  type = object({
    address  = string
    username = string
    password = string
  })
  default = null
}

variable "versions_json_url" {
  description = "JSON object URL containing versions of containerized software"
  type        = string
  default     = "https://raw.githubusercontent.com/sumicare/terraform-kubernetes-modules/master/versions.json"
}
