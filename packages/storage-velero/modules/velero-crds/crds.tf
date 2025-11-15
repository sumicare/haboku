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

resource "kubernetes_manifest" "customresourcedefinition_datadownloads_velero_io" {
  manifest = yamldecode(file("${path.module}/datadownloads.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_datauploads_velero_io" {
  manifest = yamldecode(file("${path.module}/datauploads.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_deletebackuprequests_velero_io" {
  manifest = yamldecode(file("${path.module}/deletebackuprequests.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_downloadrequests_velero_io" {
  manifest = yamldecode(file("${path.module}/downloadrequests.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_podvolumebackups_velero_io" {
  manifest = yamldecode(file("${path.module}/podvolumebackups.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_podvolumerestores_velero_io" {
  manifest = yamldecode(file("${path.module}/podvolumerestores.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_restores_velero_io" {
  manifest = yamldecode(file("${path.module}/restores.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_schedules_velero_io" {
  manifest = yamldecode(file("${path.module}/schedules.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_backuprepositories_velero_io" {
  manifest = yamldecode(file("${path.module}/backuprepositories.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_backups_velero_io" {
  manifest = yamldecode(file("${path.module}/backups.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_backupstoragelocations_velero_io" {
  manifest = yamldecode(file("${path.module}/backupstoragelocations.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_serverstatusrequests_velero_io" {
  manifest = yamldecode(file("${path.module}/serverstatusrequests.velero.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_volumesnapshotlocations_velero_io" {
  manifest = yamldecode(file("${path.module}/volumesnapshotlocations.velero.io.yaml"))
}

