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

resource "kubernetes_manifest" "customresourcedefinition_analysisruns_argoproj_io" {
  manifest = yamldecode(file("${path.module}/analysisruns.argoproj.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_analysistemplates_argoproj_io" {
  manifest = yamldecode(file("${path.module}/analysistemplates.argoproj.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_clusteranalysistemplates_argoproj_io" {
  manifest = yamldecode(file("${path.module}/clusteranalysistemplates.argoproj.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_experiments_argoproj_io" {
  manifest = yamldecode(file("${path.module}/experiments.argoproj.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_rollouts_argoproj_io" {
  manifest = yamldecode(file("${path.module}/rollouts.argoproj.io.yaml"))
}

