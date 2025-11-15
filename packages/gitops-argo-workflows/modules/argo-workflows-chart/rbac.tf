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


resource "kubernetes_cluster_role_binding" "release_name_argo_workflows_workflow_controller" {
  metadata {
    name = "release-name-argo-workflows-workflow-controller"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-argo-workflows-workflow-controller"
    namespace = "argo-workflows"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-argo-workflows-workflow-controller"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_argo_workflows_workflow_controller_cluster_template" {
  metadata {
    name = "release-name-argo-workflows-workflow-controller-cluster-template"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-argo-workflows-workflow-controller"
    namespace = "argo-workflows"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-argo-workflows-workflow-controller-cluster-template"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_argo_workflows_server" {
  metadata {
    name = "release-name-argo-workflows-server"

    labels = {
      app                            = "server"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-server"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-argo-workflows-server"
    namespace = "argo-workflows"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-argo-workflows-server"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_argo_workflows_server_cluster_template" {
  metadata {
    name = "release-name-argo-workflows-server-cluster-template"

    labels = {
      app                            = "server"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-server"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-argo-workflows-server"
    namespace = "argo-workflows"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-argo-workflows-server-cluster-template"
  }
}

resource "kubernetes_role" "release_name_argo_workflows_workflow" {
  metadata {
    name      = "release-name-argo-workflows-workflow"
    namespace = "default"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = ["argoproj.io"]
    resources  = ["workflowtaskresults"]
  }
}

resource "kubernetes_role" "release_name_argo_workflows_workflow" {
  metadata {
    name      = "release-name-argo-workflows-workflow"
    namespace = "argo-workflows"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = ["argoproj.io"]
    resources  = ["workflowtaskresults"]
  }
}

resource "kubernetes_role_binding" "release_name_argo_workflows_workflow" {
  metadata {
    name      = "release-name-argo-workflows-workflow"
    namespace = "default"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "argo-workflow"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-argo-workflows-workflow"
  }
}

resource "kubernetes_role_binding" "release_name_argo_workflows_workflow" {
  metadata {
    name      = "release-name-argo-workflows-workflow"
    namespace = "argo-workflows"

    labels = {
      app                            = "workflow-controller"
      "app.kubernetes.io/component"  = "workflow-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-workflows-workflow-controller"
      "app.kubernetes.io/part-of"    = "argo-workflows"
      "helm.sh/chart"                = "argo-workflows-0.45.27"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "argo-workflow"
    namespace = "argo-workflows"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-argo-workflows-workflow"
  }
}

