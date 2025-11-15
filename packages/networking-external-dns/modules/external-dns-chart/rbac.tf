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


resource "kubernetes_cluster_role" "release_name_external_dns" {
  metadata {
    name = "release-name-external-dns"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "external-dns"
      "app.kubernetes.io/version"    = "0.19.0"
      "helm.sh/chart"                = "external-dns-1.19.0"
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_external_dns_viewer" {
  metadata {
    name = "release-name-external-dns-viewer"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "external-dns"
      "app.kubernetes.io/version"    = "0.19.0"
      "helm.sh/chart"                = "external-dns-1.19.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-external-dns"
    namespace = "external-dns"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-external-dns"
  }
}

