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

resource "kubernetes_manifest" "customresourcedefinition_gateways_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/gateways.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_grpcroutes_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/grpcroutes.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_httproutes_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/httproutes.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_tcproutes_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/tcproutes.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_udproutes_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/udproutes.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_xbackendtrafficpolicies_gateway_networking_x_k8s_io" {
  manifest = yamldecode(file("${path.module}/xbackendtrafficpolicies.gateway.networking.x-k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_backendtlspolicies_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/backendtlspolicies.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_referencegrants_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/referencegrants.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_tlsroutes_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/tlsroutes.gateway.networking.k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_xlistenersets_gateway_networking_x_k8s_io" {
  manifest = yamldecode(file("${path.module}/xlistenersets.gateway.networking.x-k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_xmeshes_gateway_networking_x_k8s_io" {
  manifest = yamldecode(file("${path.module}/xmeshes.gateway.networking.x-k8s.io.yaml"))
}

resource "kubernetes_manifest" "customresourcedefinition_gatewayclasses_gateway_networking_k8s_io" {
  manifest = yamldecode(file("${path.module}/gatewayclasses.gateway.networking.k8s.io.yaml"))
}

