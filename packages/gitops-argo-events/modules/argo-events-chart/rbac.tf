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


resource "kubernetes_cluster_role" "release_name_argo_events_aggregate_to_admin" {
  metadata {
    name = "release-name-argo-events-aggregate-to-admin"

    labels = {
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/part-of"                    = "argo-events"
      "helm.sh/chart"                                = "argo-events-2.4.16"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["sensors", "sensors/finalizers", "sensors/status", "eventsources", "eventsources/finalizers", "eventsources/status", "eventbus", "eventbus/finalizers", "eventbus/status"]
  }
}

resource "kubernetes_cluster_role" "release_name_argo_events_aggregate_to_edit" {
  metadata {
    name = "release-name-argo-events-aggregate-to-edit"

    labels = {
      "app.kubernetes.io/instance"                  = "release-name"
      "app.kubernetes.io/managed-by"                = "Helm"
      "app.kubernetes.io/part-of"                   = "argo-events"
      "helm.sh/chart"                               = "argo-events-2.4.16"
      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
    }
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["sensors", "sensors/finalizers", "sensors/status", "eventsources", "eventsources/finalizers", "eventsources/status", "eventbus", "eventbus/finalizers", "eventbus/status"]
  }
}

resource "kubernetes_cluster_role" "release_name_argo_events_aggregate_to_view" {
  metadata {
    name = "release-name-argo-events-aggregate-to-view"

    labels = {
      "app.kubernetes.io/instance"                  = "release-name"
      "app.kubernetes.io/managed-by"                = "Helm"
      "app.kubernetes.io/part-of"                   = "argo-events"
      "helm.sh/chart"                               = "argo-events-2.4.16"
      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["sensors", "sensors/finalizers", "sensors/status", "eventsources", "eventsources/finalizers", "eventsources/status", "eventbus", "eventbus/finalizers", "eventbus/status"]
  }
}

resource "kubernetes_cluster_role" "release_name_argo_events_controller_manager" {
  metadata {
    name = "release-name-argo-events-controller-manager"

    labels = {
      "app.kubernetes.io/component"  = "controller-manager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-controller-manager"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["sensors", "sensors/finalizers", "sensors/status", "eventsources", "eventsources/finalizers", "eventsources/status", "eventbus", "eventbus/finalizers", "eventbus/status"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "patch", "delete"]
    api_groups = [""]
    resources  = ["pods", "pods/exec", "configmaps", "services", "persistentvolumeclaims"]
  }

  rule {
    verbs      = ["create", "get", "list", "update", "patch", "delete"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "patch", "delete"]
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets"]
  }
}

resource "kubernetes_cluster_role" "argo_events_webhook" {
  metadata {
    name = "argo-events-webhook"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-events-webhook"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list"]
    api_groups = ["apps"]
    resources  = ["deployments"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["eventbus", "eventsources", "sensors"]
  }

  rule {
    verbs      = ["get", "list"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterroles"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_argo_events_controller_manager" {
  metadata {
    name = "release-name-argo-events-controller-manager"

    labels = {
      "app.kubernetes.io/component"  = "controller-manager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-controller-manager"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-argo-events-controller-manager"
    namespace = "argo-events"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-argo-events-controller-manager"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_argo_events_events_webhook" {
  metadata {
    name = "release-name-argo-events-events-webhook"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-events-events-webhook"
      "app.kubernetes.io/part-of"    = "argo-events"
      "helm.sh/chart"                = "argo-events-2.4.16"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-argo-events-events-webhook"
    namespace = "argo-events"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "argo-events-webhook"
  }
}

