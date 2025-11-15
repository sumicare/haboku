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

resource "kubernetes_manifest" "customresourcedefinition_challenges_acme_cert_manager_io" {
  manifest = yamldecode(file("${path.module}/challenges.acme.cert-manager.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_orders_acme_cert_manager_io" {
  manifest = yamldecode(file("${path.module}/orders.acme.cert-manager.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_certificaterequests_cert_manager_io" {
  manifest = yamldecode(file("${path.module}/certificaterequests.cert-manager.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_certificates_cert_manager_io" {
  manifest = yamldecode(file("${path.module}/certificates.cert-manager.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_clusterissuers_cert_manager_io" {
  manifest = yamldecode(file("${path.module}/clusterissuers.cert-manager.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_issuers_cert_manager_io" {
  manifest = yamldecode(file("${path.module}/issuers.cert-manager.io.yaml"))
}

