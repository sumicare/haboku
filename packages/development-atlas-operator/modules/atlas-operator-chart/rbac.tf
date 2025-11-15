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


resource "kubernetes_cluster_role" "atlas_operator_manager_role" {
  metadata {
    name   = "${local.app_name}-manager-role"
    labels = local.labels
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["apps"]
    resources  = ["deployments"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "update", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "secrets"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["db.atlasgo.io"]
    resources  = ["atlasmigrations"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["db.atlasgo.io"]
    resources  = ["atlasmigrations/finalizers"]
  }

  rule {
    verbs      = ["get", "patch", "update"]
    api_groups = ["db.atlasgo.io"]
    resources  = ["atlasmigrations/status"]
  }

  rule {
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
    api_groups = ["db.atlasgo.io"]
    resources  = ["atlasschemas"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["db.atlasgo.io"]
    resources  = ["atlasschemas/finalizers"]
  }

  rule {
    verbs      = ["get", "patch", "update"]
    api_groups = ["db.atlasgo.io"]
    resources  = ["atlasschemas/status"]
  }
}

resource "kubernetes_cluster_role_binding" "atlas_operator_manager_role_binding" {
  metadata {
    name   = "${local.app_name}-manager-role-binding"
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
    name      = "${local.app_name}-manager-role"
  }
}

resource "kubernetes_role" "atlas_operator_leader_election_role" {
  metadata {
    name      = "${local.app_name}-leader-election-role"
    namespace = var.namespace
    labels    = local.labels
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }
}

resource "kubernetes_role_binding" "atlas_operator_leader_election_role_binding" {
  metadata {
    name      = "${local.app_name}-leader-election-role-binding"
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
    name      = "${local.app_name}-leader-election-role"
  }
}
