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


resource "kubernetes_cluster_role" "release_name_admission" {
  metadata {
    name = "release-name-admission"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["get", "list", "create", "delete"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["create", "update"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests/approval"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["queues"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["podgroups"]
  }
}

resource "kubernetes_cluster_role" "release_name_agent" {
  metadata {
    name = "release-name-agent"

    labels = {
      app = "volcano-agent"
    }
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/eviction"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["list", "watch", "create", "update", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }
}

resource "kubernetes_cluster_role" "release_name_controllers" {
  metadata {
    name = "release-name-controllers"
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "delete"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs/status", "jobs/finalizers"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["cronjobs"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["cronjobs/status", "cronjobs/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "delete"]
    api_groups = ["bus.volcano.sh"]
    resources  = ["commands"]
  }

  rule {
    verbs      = ["create", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "delete", "patch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = [""]
    resources  = ["pods/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create"]
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "create", "delete", "update"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["podgroups", "queues", "queues/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update"]
    api_groups = ["flow.volcano.sh"]
    resources  = ["jobflows", "jobtemplates"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["flow.volcano.sh"]
    resources  = ["jobflows/status", "jobs/finalizers", "jobtemplates/status", "jobtemplates/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete"]
    api_groups = ["scheduling.k8s.io"]
    resources  = ["priorityclasses"]
  }

  rule {
    verbs      = ["get", "create", "delete"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["apps"]
    resources  = ["daemonsets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apps"]
    resources  = ["replicasets", "statefulsets"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["get", "create", "update", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["list", "watch", "get", "create", "delete", "update", "patch"]
    api_groups = ["topology.volcano.sh"]
    resources  = ["hypernodes", "hypernodes/status"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["nodes"]
  }
}

resource "kubernetes_cluster_role" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "secrets", "nodes", "pods", "services", "resourcequotas", "replicationcontrollers", "limitranges", "persistentvolumeclaims", "persistentvolumes", "namespaces", "endpoints"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "replicasets", "ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "volumeattachments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
  }
}

resource "kubernetes_cluster_role" "prometheus_volcano" {
  metadata {
    name = "prometheus-volcano"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["ingresses"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role" "release_name_scheduler" {
  metadata {
    name = "release-name-scheduler"
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "delete"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs/status"]
  }

  rule {
    verbs      = ["create", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch", "patch", "delete"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["update"]
    api_groups = [""]
    resources  = ["pods/status"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/binding"]
  }

  rule {
    verbs      = ["list", "watch", "update"]
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
  }

  rule {
    verbs      = ["list", "watch", "update"]
    api_groups = [""]
    resources  = ["persistentvolumes"]
  }

  rule {
    verbs      = ["list", "watch", "get"]
    api_groups = [""]
    resources  = ["namespaces", "services", "replicationcontrollers"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["resourcequotas"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities", "volumeattachments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["scheduling.k8s.io"]
    resources  = ["priorityclasses"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["queues"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["queues/status"]
  }

  rule {
    verbs      = ["list", "watch", "update"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["podgroups"]
  }

  rule {
    verbs      = ["get", "list", "watch", "delete"]
    api_groups = ["nodeinfo.volcano.sh"]
    resources  = ["numatopologies"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["topology.volcano.sh"]
    resources  = ["hypernodes", "hypernodes/status"]
  }

  rule {
    verbs      = ["get", "create", "delete", "update"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["list", "watch", "get"]
    api_groups = ["apps"]
    resources  = ["daemonsets", "replicasets", "statefulsets"]
  }

  rule {
    verbs      = ["get", "create", "update", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["resource.k8s.io"]
    resources  = ["resourceclaims"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["resource.k8s.io"]
    resources  = ["resourceclaims/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create"]
    api_groups = ["resource.k8s.io"]
    resources  = ["deviceclasses", "resourceslices"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["resource.k8s.io"]
    resources  = ["devicetaintrules"]
  }
}

resource "kubernetes_cluster_role" "vcjob_editor_role" {
  metadata {
    name = "vcjob-editor-role"
  }

  rule {
    verbs      = ["create", "get", "list", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["create", "get", "list"]
    api_groups = ["bus.volcano.sh"]
    resources  = ["commands"]
  }
}

resource "kubernetes_cluster_role" "vcjob_viewer_role" {
  metadata {
    name = "vcjob-viewer-role"
  }

  rule {
    verbs      = ["get", "list"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_admission_role" {
  metadata {
    name = "release-name-admission-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-admission"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-admission"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_agent_role" {
  metadata {
    name = "release-name-agent-role"
    labels = {
      app = "volcano-agent"
    }
  }
  subject {
    kind      = "ServiceAccount"
    name      = "release-name-agent"
    namespace = "volcano"
  }
  subject {
    kind      = "User"
    api_group = "rbac.authorization.k8s.io"
    name      = "release-name-agent"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-agent"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_controllers_role" {
  metadata {
    name = "release-name-controllers-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-controllers"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-controllers"
  }
}

resource "kubernetes_cluster_role_binding" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-state-metrics"
  }
}

resource "kubernetes_cluster_role_binding" "prometheus_volcano" {
  metadata {
    name = "prometheus-volcano"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus-volcano"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_scheduler_role" {
  metadata {
    name = "release-name-scheduler-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-scheduler"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-scheduler"
  }
}

resource "kubernetes_role" "release_name_admission_init" {
  metadata {
    name      = "release-name-admission-init"
    namespace = "volcano"

    annotations = {
      "helm.sh/hook"               = "pre-install,pre-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
      "helm.sh/hook-weight"        = "0"
    }
  }

  rule {
    verbs      = ["create", "patch", "get"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_role_binding" "release_name_admission_init_role" {
  metadata {
    name      = "release-name-admission-init-role"
    namespace = "volcano"

    annotations = {
      "helm.sh/hook"               = "pre-install,pre-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
      "helm.sh/hook-weight"        = "0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-admission-init"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-admission-init"
  }
}

