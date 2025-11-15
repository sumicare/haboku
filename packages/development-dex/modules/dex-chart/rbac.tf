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


resource "kubernetes_cluster_role" "dex" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }

  rule {
    verbs      = ["list", "create"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }
}

resource "kubernetes_cluster_role_binding" "dex_cluster" {
  metadata {
    name   = "${local.app_name}-cluster"
    labels = local.labels
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.app_name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.app_name
  }
}

resource "kubernetes_role" "dex" {
  metadata {
    name      = local.app_name
    namespace = var.namespace
    labels    = local.labels
  }

  rule {
    verbs      = ["*"]
    api_groups = ["dex.coreos.com"]
    resources  = ["*"]
  }
}

resource "kubernetes_role_binding" "dex" {
  metadata {
    name      = local.app_name
    namespace = var.namespace
    labels    = local.labels
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.app_name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = local.app_name
  }
}
