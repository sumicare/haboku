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

resource "kubernetes_manifest" "customresourcedefinition_stepactions_tekton_dev" {
  manifest = yamldecode(file("${path.module}/stepactions.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_tasks_tekton_dev" {
  manifest = yamldecode(file("${path.module}/tasks.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_taskruns_tekton_dev" {
  manifest = yamldecode(file("${path.module}/taskruns.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_verificationpolicies_tekton_dev" {
  manifest = yamldecode(file("${path.module}/verificationpolicies.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_customruns_tekton_dev" {
  manifest = yamldecode(file("${path.module}/customruns.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_pipelines_tekton_dev" {
  manifest = yamldecode(file("${path.module}/pipelines.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_pipelineruns_tekton_dev" {
  manifest = yamldecode(file("${path.module}/pipelineruns.tekton.dev.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_resolutionrequests_resolution_tekton_dev" {
  manifest = yamldecode(file("${path.module}/resolutionrequests.resolution.tekton.dev.yaml"))
}

