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


resource "kubernetes_role" "tekton_operator_info" {
  metadata {
    name      = "${local.app_name}-info"
    namespace = var.namespace
    labels    = local.labels
  }

  rule {
    verbs          = ["get", "describe"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["${local.app_name}-info"]
  }
}

resource "kubernetes_cluster_role" "tekton_config_read_role" {
  metadata {
    name   = "tekton-config-read-role"
    labels = local.labels
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["operator.tekton.dev"]
    resources  = ["tektonconfigs"]
  }
}

resource "kubernetes_cluster_role" "tekton_operator" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }

  rule {
    verbs      = ["list"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["delete", "deletecollection", "create", "patch", "get", "list", "update", "watch", "describe"]
    api_groups = [""]
    resources  = ["pods", "services", "endpoints", "persistentvolumeclaims", "events", "configmaps", "secrets", "pods/log", "limitranges"]
  }

  rule {
    verbs      = ["delete", "create", "patch", "get", "list", "update", "watch"]
    api_groups = ["extensions", "apps", "networking.k8s.io"]
    resources  = ["ingresses", "ingresses/status"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["update"]
    api_groups = [""]
    resources  = ["namespaces/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "replicasets", "statefulsets", "deployments/finalizers"]
  }

  rule {
    verbs      = ["get", "create", "delete"]
    api_groups = ["monitoring.coreos.com"]
    resources  = ["servicemonitors"]
  }

  rule {
    verbs      = ["get", "create", "update", "delete", "list", "watch"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterroles", "roles"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch", "impersonate"]
    api_groups = [""]
    resources  = ["serviceaccounts"]
  }

  rule {
    verbs      = ["get", "create", "update", "delete", "list", "watch"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterrolebindings", "rolebindings"]
  }

  rule {
    verbs      = ["get", "create", "update", "delete", "list", "patch", "watch"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions", "customresourcedefinitions/status"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = ["build.knative.dev"]
    resources  = ["builds", "buildtemplates", "clusterbuildtemplates"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = ["extensions"]
    resources  = ["deployments"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = ["extensions"]
    resources  = ["deployments/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
    api_groups = ["operator.tekton.dev"]
    resources  = ["*", "tektonaddons"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
    api_groups = ["tekton.dev"]
    resources  = ["tasks", "clustertasks", "taskruns", "pipelines", "pipelineruns", "pipelineresources", "conditions", "tasks/status", "clustertasks/status", "taskruns/status", "pipelines/status", "pipelineruns/status", "pipelineresources/status", "taskruns/finalizers", "pipelineruns/finalizers", "runs", "runs/status", "runs/finalizers", "customruns", "customruns/status", "customruns/finalizers", "verificationpolicies", "verificationpolicies/status", "stepactions", "stepactions/status"]
  }

  rule {
    verbs      = ["add", "get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
    api_groups = ["triggers.tekton.dev", "operator.tekton.dev"]
    resources  = ["*"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
    api_groups = ["dashboard.tekton.dev"]
    resources  = ["*", "tektonaddons", "extensions"]
  }

  rule {
    verbs      = ["use"]
    api_groups = ["security.openshift.io"]
    resources  = ["securitycontextconstraints"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "patch", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["delete", "deletecollection", "create", "patch", "get", "list", "update", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }

  rule {
    verbs      = ["delete", "deletecollection", "create", "patch", "get", "list", "update", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
    api_groups = ["serving.knative.dev"]
    resources  = ["*", "*/status", "*/finalizers"]
  }

  rule {
    verbs      = ["delete", "create", "patch", "get", "list", "update", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
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
    verbs      = ["delete", "deletecollection", "create", "patch", "get", "list", "update", "watch"]
    api_groups = ["results.tekton.dev"]
    resources  = ["*"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    api_groups = ["resolution.tekton.dev"]
    resources  = ["resolutionrequests", "resolutionrequests/status"]
  }

  rule {
    verbs      = ["add", "get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
    api_groups = ["openshift-pipelines.org"]
    resources  = ["approvaltasks", "approvaltasks/status"]
  }
}

resource "kubernetes_cluster_role" "tekton_result_read_role" {
  metadata {
    name   = "tekton-result-read-role"
    labels = local.labels
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["operator.tekton.dev"]
    resources  = ["tektonresults"]
  }
}

resource "kubernetes_role_binding" "tekton_operator_info" {
  metadata {
    name      = "${local.app_name}-info"
    namespace = var.namespace
    labels    = local.labels
  }

  subject {
    kind      = "Group"
    api_group = "rbac.authorization.k8s.io"
    name      = "system:authenticated"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${local.app_name}-info"
  }
}

resource "kubernetes_cluster_role_binding" "tekton_config_read_rolebinding" {
  metadata {
    name   = "tekton-config-read-rolebinding"
    labels = local.labels
  }

  subject {
    kind      = "Group"
    api_group = "rbac.authorization.k8s.io"
    name      = "system:authenticated"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "tekton-config-read-role"
  }
}

resource "kubernetes_cluster_role_binding" "tekton_operator" {
  metadata {
    name   = local.app_name
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

resource "kubernetes_cluster_role_binding" "tekton_result_read_rolebinding" {
  metadata {
    name   = "tekton-result-read-rolebinding"
    labels = local.labels
  }

  subject {
    kind      = "Group"
    api_group = "rbac.authorization.k8s.io"
    name      = "system:authenticated"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "tekton-result-read-role"
  }
}
