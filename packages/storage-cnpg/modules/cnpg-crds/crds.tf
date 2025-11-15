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

resource "kubernetes_manifest" "customresourcedefinition_backups_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/backups.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_clusterimagecatalogs_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/clusterimagecatalogs.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_clusters_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/clusters.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_databases_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/databases.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_failoverquorums_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/failoverquorums.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_poolers_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/poolers.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_publications_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/publications.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_imagecatalogs_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/imagecatalogs.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_scheduledbackups_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/scheduledbackups.postgresql.cnpg.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_subscriptions_postgresql_cnpg_io" {
  manifest = yamldecode(file("${path.module}/subscriptions.postgresql.cnpg.io.yaml"))
}

