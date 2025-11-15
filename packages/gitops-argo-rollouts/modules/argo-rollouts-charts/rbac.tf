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


resource "kubernetes_cluster_role" "release_name_argo_rollouts_aggregate_to_view" {
  metadata {
    name = "release-name-argo-rollouts-aggregate-to-view"

    labels = {
      "app.kubernetes.io/component"                 = "rollouts-controller"
      "app.kubernetes.io/instance"                  = "release-name"
      "app.kubernetes.io/managed-by"                = "Helm"
      "app.kubernetes.io/name"                      = "argo-rollouts"
      "app.kubernetes.io/part-of"                   = "argo-rollouts"
      "app.kubernetes.io/version"                   = "v1.8.3"
      "helm.sh/chart"                               = "argo-rollouts-2.40.5"
      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["rollouts", "rollouts/scale", "experiments", "analysistemplates", "clusteranalysistemplates", "analysisruns"]
  }
}

resource "kubernetes_cluster_role" "release_name_argo_rollouts_aggregate_to_edit" {
  metadata {
    name = "release-name-argo-rollouts-aggregate-to-edit"

    labels = {
      "app.kubernetes.io/component"                 = "rollouts-controller"
      "app.kubernetes.io/instance"                  = "release-name"
      "app.kubernetes.io/managed-by"                = "Helm"
      "app.kubernetes.io/name"                      = "argo-rollouts"
      "app.kubernetes.io/part-of"                   = "argo-rollouts"
      "app.kubernetes.io/version"                   = "v1.8.3"
      "helm.sh/chart"                               = "argo-rollouts-2.40.5"
      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
    }
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["rollouts", "rollouts/scale", "rollouts/status", "experiments", "analysistemplates", "clusteranalysistemplates", "analysisruns"]
  }
}

resource "kubernetes_cluster_role" "release_name_argo_rollouts_aggregate_to_admin" {
  metadata {
    name = "release-name-argo-rollouts-aggregate-to-admin"

    labels = {
      "app.kubernetes.io/component"                  = "rollouts-controller"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "argo-rollouts"
      "app.kubernetes.io/part-of"                    = "argo-rollouts"
      "app.kubernetes.io/version"                    = "v1.8.3"
      "helm.sh/chart"                                = "argo-rollouts-2.40.5"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }

  rule {
    verbs      = ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["rollouts", "rollouts/scale", "rollouts/status", "experiments", "analysistemplates", "clusteranalysistemplates", "analysisruns"]
  }
}

resource "kubernetes_cluster_role" "release_name_argo_rollouts" {
  metadata {
    name = "release-name-argo-rollouts"

    labels = {
      "app.kubernetes.io/component"  = "rollouts-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-rollouts"
      "app.kubernetes.io/part-of"    = "argo-rollouts"
      "app.kubernetes.io/version"    = "v1.8.3"
      "helm.sh/chart"                = "argo-rollouts-2.40.5"
    }
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "patch"]
    api_groups = ["argoproj.io"]
    resources  = ["rollouts", "rollouts/status", "rollouts/finalizers"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "patch", "delete"]
    api_groups = ["argoproj.io"]
    resources  = ["analysisruns", "analysisruns/finalizers", "experiments", "experiments/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["argoproj.io"]
    resources  = ["analysistemplates", "clusteranalysistemplates"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "patch", "delete"]
    api_groups = ["apps"]
    resources  = ["replicasets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update"]
    api_groups = ["", "apps"]
    resources  = ["deployments", "podtemplates"]
  }

  rule {
    verbs      = ["get", "list", "watch", "patch", "create", "delete"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["create", "get", "update"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["list", "update", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/eviction"]
  }

  rule {
    verbs      = ["create", "update", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "patch"]
    api_groups = ["networking.k8s.io", "extensions"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "patch", "delete"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["watch", "get", "update", "patch", "list"]
    api_groups = ["networking.istio.io"]
    resources  = ["virtualservices", "destinationrules"]
  }

  rule {
    verbs      = ["create", "watch", "get", "update", "patch"]
    api_groups = ["split.smi-spec.io"]
    resources  = ["trafficsplits"]
  }

  rule {
    verbs      = ["create", "watch", "get", "update", "list", "delete"]
    api_groups = ["getambassador.io", "x.getambassador.io"]
    resources  = ["mappings", "ambassadormappings"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["endpoints"]
  }

  rule {
    verbs      = ["list", "get"]
    api_groups = ["elbv2.k8s.aws"]
    resources  = ["targetgroupbindings"]
  }

  rule {
    verbs      = ["watch", "get", "list"]
    api_groups = ["appmesh.k8s.aws"]
    resources  = ["virtualservices"]
  }

  rule {
    verbs      = ["watch", "get", "list", "update", "patch"]
    api_groups = ["appmesh.k8s.aws"]
    resources  = ["virtualnodes", "virtualrouters"]
  }

  rule {
    verbs      = ["watch", "get", "update"]
    api_groups = ["traefik.containo.us", "traefik.io"]
    resources  = ["traefikservices"]
  }

  rule {
    verbs      = ["watch", "get", "update"]
    api_groups = ["apisix.apache.org"]
    resources  = ["apisixroutes"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update"]
    api_groups = ["projectcontour.io"]
    resources  = ["httpproxies"]
  }

  rule {
    verbs      = ["*"]
    api_groups = ["networking.gloo.solo.io"]
    resources  = ["routetables"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update"]
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["httproutes", "tcproutes", "tlsroutes", "udproutes", "grpcroutes"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_argo_rollouts" {
  metadata {
    name = "release-name-argo-rollouts"

    labels = {
      "app.kubernetes.io/component"  = "rollouts-controller"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "argo-rollouts"
      "app.kubernetes.io/part-of"    = "argo-rollouts"
      "app.kubernetes.io/version"    = "v1.8.3"
      "helm.sh/chart"                = "argo-rollouts-2.40.5"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-argo-rollouts"
    namespace = "argo-rollouts"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-argo-rollouts"
  }
}

