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

resource "kubernetes_manifest" "customresourcedefinition_eventlisteners_triggers_tekton_dev" {
  manifest = yamldecode(file("${path.module}/eventlisteners.triggers.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_interceptors_triggers_tekton_dev" {
  manifest = yamldecode(file("${path.module}/interceptors.triggers.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_triggers_triggers_tekton_dev" {
  manifest = yamldecode(file("${path.module}/triggers.triggers.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_triggerbindings_triggers_tekton_dev" {
  manifest = yamldecode(file("${path.module}/triggerbindings.triggers.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_triggertemplates_triggers_tekton_dev" {
  manifest = yamldecode(file("${path.module}/triggertemplates.triggers.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_clusterinterceptors_triggers_tekton_dev" {
  manifest = yamldecode(file("${path.module}/clusterinterceptors.triggers.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_clustertriggerbindings_triggers_tekton_dev" {
  manifest = yamldecode(file("${path.module}/clustertriggerbindings.triggers.tekton.dev.yaml"))
}

