#
# Copyright 2025 Sumicare
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

###           DO NOT EDIT            ###
# This file is automagically generated #

resource "kubernetes_manifest" "customresourcedefinition_configs_artifact_falcosecurity_dev" {
  manifest = yamldecode(file("${path.module}/configs.artifact.falcosecurity.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_plugins_artifact_falcosecurity_dev" {
  manifest = yamldecode(file("${path.module}/plugins.artifact.falcosecurity.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_rulesfiles_artifact_falcosecurity_dev" {
  manifest = yamldecode(file("${path.module}/rulesfiles.artifact.falcosecurity.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_falcos_instance_falcosecurity_dev" {
  manifest = yamldecode(file("${path.module}/falcos.instance.falcosecurity.dev.yaml"))
}

