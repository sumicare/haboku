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

resource "kubernetes_manifest" "customresourcedefinition_numatopologies_nodeinfo_volcano_sh" {
  manifest = yamldecode(file("${path.module}/numatopologies.nodeinfo.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_jobtemplates_flow_volcano_sh" {
  manifest = yamldecode(file("${path.module}/jobtemplates.flow.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_hypernodes_topology_volcano_sh" {
  manifest = yamldecode(file("${path.module}/hypernodes.topology.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_jobs_batch_volcano_sh" {
  manifest = yamldecode(file("${path.module}/jobs.batch.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_commands_bus_volcano_sh" {
  manifest = yamldecode(file("${path.module}/commands.bus.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_podgroups_scheduling_volcano_sh" {
  manifest = yamldecode(file("${path.module}/podgroups.scheduling.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_jobflows_flow_volcano_sh" {
  manifest = yamldecode(file("${path.module}/jobflows.flow.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_cronjobs_batch_volcano_sh" {
  manifest = yamldecode(file("${path.module}/cronjobs.batch.volcano.sh.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_queues_scheduling_volcano_sh" {
  manifest = yamldecode(file("${path.module}/queues.scheduling.volcano.sh.yaml"))
}

