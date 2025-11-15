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


resource "kubernetes_cluster_role" "linkerd_linkerd_identity" {
  metadata {
    name = "linkerd-linkerd-identity"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_linkerd_identity" {
  metadata {
    name = "linkerd-linkerd-identity"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-identity"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-linkerd-identity"
  }
}

resource "kubernetes_cluster_role" "linkerd_linkerd_destination" {
  metadata {
    name = "linkerd-linkerd-destination"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["apps"]
    resources  = ["replicasets"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = [""]
    resources  = ["pods", "endpoints", "services", "nodes"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["linkerd.io"]
    resources  = ["serviceprofiles"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["workload.linkerd.io"]
    resources  = ["externalworkloads"]
  }

  rule {
    verbs      = ["create", "get", "update", "patch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["list", "get", "watch", "create", "update", "patch", "delete"]
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_linkerd_destination" {
  metadata {
    name = "linkerd-linkerd-destination"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-destination"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-linkerd-destination"
  }
}

resource "kubernetes_cluster_role" "linkerd_policy" {
  metadata {
    name = "linkerd-policy"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["apps"]
    resources  = ["deployments"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["policy.linkerd.io"]
    resources  = ["authorizationpolicies", "httplocalratelimitpolicies", "httproutes", "meshtlsauthentications", "networkauthentications", "servers", "serverauthorizations", "egressnetworks"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["httproutes", "grpcroutes", "tlsroutes", "tcproutes"]
  }

  rule {
    verbs      = ["patch"]
    api_groups = ["policy.linkerd.io"]
    resources  = ["httproutes/status", "httplocalratelimitpolicies/status", "egressnetworks/status"]
  }

  rule {
    verbs      = ["patch"]
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["httproutes/status", "grpcroutes/status", "tlsroutes/status", "tcproutes/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["workload.linkerd.io"]
    resources  = ["externalworkloads"]
  }

  rule {
    verbs      = ["create", "get", "patch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_destination_policy" {
  metadata {
    name = "linkerd-destination-policy"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-destination"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-policy"
  }
}

resource "kubernetes_role" "remote_discovery" {
  metadata {
    name      = "remote-discovery"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_role_binding" "linkerd_destination_remote_discovery" {
  metadata {
    name      = "linkerd-destination-remote-discovery"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-destination"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "remote-discovery"
  }
}

resource "kubernetes_role" "linkerd_heartbeat" {
  metadata {
    name      = "linkerd-heartbeat"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  rule {
    verbs          = ["get"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["linkerd-config"]
  }
}

resource "kubernetes_role_binding" "linkerd_heartbeat" {
  metadata {
    name      = "linkerd-heartbeat"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-heartbeat"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "linkerd-heartbeat"
  }
}

resource "kubernetes_cluster_role" "linkerd_heartbeat" {
  metadata {
    name = "linkerd-heartbeat"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  rule {
    verbs      = ["list"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["list"]
    api_groups = ["linkerd.io"]
    resources  = ["serviceprofiles"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_heartbeat" {
  metadata {
    name = "linkerd-heartbeat"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-heartbeat"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-heartbeat"
  }
}

resource "kubernetes_cluster_role" "linkerd_linkerd_proxy_injector" {
  metadata {
    name = "linkerd-linkerd-proxy-injector"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = [""]
    resources  = ["namespaces", "replicationcontrollers"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["extensions", "apps"]
    resources  = ["deployments", "replicasets", "daemonsets", "statefulsets"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["extensions", "batch"]
    resources  = ["cronjobs", "jobs"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_linkerd_proxy_injector" {
  metadata {
    name = "linkerd-linkerd-proxy-injector"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-proxy-injector"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-linkerd-proxy-injector"
  }
}

resource "kubernetes_role" "ext_namespace_metadata_linkerd_config" {
  metadata {
    name      = "ext-namespace-metadata-linkerd-config"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  rule {
    verbs          = ["get"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["linkerd-config"]
  }
}

