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

# Configure Kubernetes provider to use the kind cluster
# The kind cluster is created manually via kind CLI in the test suite

terraform {
  required_version = ">= 1.10"

  required_providers {
    kubernetes = {
      source  = "registry.opentofu.org/hashicorp/kubernetes"
      version = "~> 2"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kube-ray-test"
}

locals {
  # Read version from package.json in parent directory
  package_json     = jsondecode(file("${path.module}/../../../package.json"))
  kube_ray_version = local.package_json.version
}

module "vpa_operator" {
  source = "./.."

  replicas                = 3
  kube_ray_version        = local.kube_ray_version
  deploy_custom_resources = false
}
