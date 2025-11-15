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


resource "kubernetes_cluster_role" "release_name_alloy" {
  metadata {
    name = "release-name-alloy"

    labels = {
      "app.kubernetes.io/component"  = "rbac"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["", "discovery.k8s.io", "networking.k8s.io"]
    resources  = ["endpoints", "endpointslices", "ingresses", "pods", "services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods", "pods/log", "namespaces"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["monitoring.grafana.com"]
    resources  = ["podlogs"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["monitoring.coreos.com"]
    resources  = ["prometheusrules"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["monitoring.coreos.com"]
    resources  = ["podmonitors", "servicemonitors", "probes", "scrapeconfigs"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "secrets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apps", "extensions"]
    resources  = ["replicasets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_alloy" {
  metadata {
    name = "release-name-alloy"

    labels = {
      "app.kubernetes.io/component"  = "rbac"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-alloy"
    namespace = "alloy"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-alloy"
  }
}

