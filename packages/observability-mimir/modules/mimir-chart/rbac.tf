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


resource "kubernetes_cluster_role" "release_name_rollout_operator_webhook_clusterrole" {
  metadata {
    name = "release-name-rollout-operator-webhook-clusterrole"
  }

  rule {
    verbs      = ["list", "patch", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations", "mutatingwebhookconfigurations"]
  }
}

resource "kubernetes_cluster_role" "release_name_mimir_grafana_agent" {
  metadata {
    name = "release-name-mimir-grafana-agent"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods", "events"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics", "/metrics/cadvisor"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_rollout_operator_webhook_clusterrolebinding" {
  metadata {
    name = "release-name-rollout-operator-webhook-clusterrolebinding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "mimir"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-rollout-operator-webhook-clusterrole"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_mimir_grafana_agent" {
  metadata {
    name = "release-name-mimir-grafana-agent"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-mimir"
    namespace = "mimir"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-mimir-grafana-agent"
  }
}

resource "kubernetes_role" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.32.0"
      "helm.sh/chart"                = "rollout-operator-0.37.1"
    }
  }

  rule {
    verbs      = ["list", "get", "watch", "delete"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["list", "get", "watch", "patch"]
    api_groups = ["apps"]
    resources  = ["statefulsets"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["apps"]
    resources  = ["statefulsets/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["rollout-operator.grafana.com"]
    resources  = ["zoneawarepoddisruptionbudgets"]
  }

  rule {
    verbs      = ["get", "patch"]
    api_groups = ["rollout-operator.grafana.com"]
    resources  = ["replicatemplates/scale", "replicatemplates/status"]
  }
}

resource "kubernetes_role" "release_name_rollout_operator_webhook_role" {
  metadata {
    name      = "release-name-rollout-operator-webhook-role"
    namespace = "mimir"
  }

  rule {
    verbs          = ["update", "get"]
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["certificate"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_role_binding" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.32.0"
      "helm.sh/chart"                = "rollout-operator-0.37.1"
    }
  }

  subject {
    kind = "ServiceAccount"
    name = "release-name-rollout-operator"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-rollout-operator"
  }
}

resource "kubernetes_role_binding" "release_name_rollout_operator_webhook_rolebinding" {
  metadata {
    name      = "release-name-rollout-operator-webhook-rolebinding"
    namespace = "mimir"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "mimir"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-rollout-operator-webhook-role"
  }
}

