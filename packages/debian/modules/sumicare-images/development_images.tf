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

# module "atlas_operator_images" {
#   source = "${path.module}/../../../development-atlas-operator/modules/atlas-operator-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version         = local.debian_version
#   atlas_operator_version = local.atlas_operator_version

#   depends_on = [module.base_debian_images]
# }

# module "dex_images" {
#   source = "${path.module}/../../../development-dex/modules/dex-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version = local.debian_version
#   dex_version    = local.dex_version

#   depends_on = [module.base_debian_images]
# }

# module "tekton_chains_images" {
#   source = "${path.module}/../../../development-tekton-chains/modules/tekton-chains-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version        = local.debian_version
#   tekton_chains_version = local.tekton_chains_version

#   depends_on = [module.base_debian_images]
# }

# module "tekton_dashboard_images" {
#   source = "${path.module}/../../../development-tekton-dashboard/modules/tekton-dashboard-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version           = local.debian_version
#   tekton_dashboard_version = local.tekton_dashboard_version

#   depends_on = [module.base_debian_images]
# }

# module "tekton_pipeline_images" {
#   source = "${path.module}/../../../development-tekton-pipeline/modules/tekton-pipeline-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version          = local.debian_version
#   tekton_pipeline_version = local.tekton_pipeline_version

#   depends_on = [module.base_debian_images]
# }

# module "tekton_results_images" {
#   source = "${path.module}/../../../development-tekton-results/modules/tekton-results-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version         = local.debian_version
#   tekton_results_version = local.tekton_results_version

#   depends_on = [module.base_debian_images]
# }

# module "tekton_trigger_images" {
#   source = "${path.module}/../../../development-tekton-trigger/modules/tekton-trigger-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version         = local.debian_version
#   tekton_trigger_version = local.tekton_trigger_version

#   depends_on = [module.base_debian_images]
# }

# module "tekton_theia_images" {
#   source = "${path.module}/../../../development-theia/modules/theia-image"

#   org           = var.org
#   repository    = var.repository
#   registry_auth = var.registry_auth

#   debian_version = local.debian_version
#   theia_version  = local.theia_version

#   depends_on = [module.base_debian_images]
# }
