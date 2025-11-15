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


resource "kubernetes_cluster_role" "tigera_operator_secrets" {
  metadata {
    name = "tigera-operator-secrets"

    labels = {
      k8s-app = "tigera-operator"
    }
  }

  rule {
    verbs      = ["create", "update", "delete"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_cluster_role" "tigera_operator" {
  metadata {
    name = "tigera-operator"

    labels = {
      k8s-app = "tigera-operator"
    }
  }

  rule {
    verbs      = ["get", "list", "watch", "create"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = ["apiextensions.k8s.io"]
    resources      = ["customresourcedefinitions"]
    resource_names = ["apiservers.operator.tigera.io", "gatewayapis.operator.tigera.io", "imagesets.operator.tigera.io", "installations.operator.tigera.io", "tigerastatuses.operator.tigera.io", "bgpconfigurations.crd.projectcalico.org", "bgpfilters.crd.projectcalico.org", "bgppeers.crd.projectcalico.org", "blockaffinities.crd.projectcalico.org", "caliconodestatuses.crd.projectcalico.org", "clusterinformations.crd.projectcalico.org", "felixconfigurations.crd.projectcalico.org", "globalnetworkpolicies.crd.projectcalico.org", "stagedglobalnetworkpolicies.crd.projectcalico.org", "globalnetworksets.crd.projectcalico.org", "hostendpoints.crd.projectcalico.org", "ipamblocks.crd.projectcalico.org", "ipamconfigs.crd.projectcalico.org", "ipamhandles.crd.projectcalico.org", "ippools.crd.projectcalico.org", "ipreservations.crd.projectcalico.org", "kubecontrollersconfigurations.crd.projectcalico.org", "networkpolicies.crd.projectcalico.org", "stagednetworkpolicies.crd.projectcalico.org", "stagedkubernetesnetworkpolicies.crd.projectcalico.org", "networksets.crd.projectcalico.org", "tiers.crd.projectcalico.org", "whiskers.operator.tigera.io", "goldmanes.operator.tigera.io", "managementclusterconnections.operator.tigera.io"]
  }

  rule {
    verbs          = ["update", "delete"]
    api_groups     = ["apiextensions.k8s.io"]
    resources      = ["customresourcedefinitions"]
    resource_names = ["adminnetworkpolicies.policy.networking.k8s.io", "baselineadminnetworkpolicies.policy.networking.k8s.io"]
  }

  rule {
    verbs      = ["create", "get", "list", "update", "delete", "watch"]
    api_groups = [""]
    resources  = ["namespaces", "pods", "podtemplates", "services", "endpoints", "events", "configmaps", "serviceaccounts"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = [""]
    resources  = ["resourcequotas", "secrets"]
  }

  rule {
    verbs          = ["create", "get", "list", "update", "delete", "watch"]
    api_groups     = [""]
    resources      = ["resourcequotas"]
    resource_names = ["calico-critical-pods", "tigera-critical-pods"]
  }

  rule {
    verbs      = ["get", "patch", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create", "get", "list", "update", "delete", "watch", "bind", "escalate"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterroles", "clusterrolebindings", "rolebindings", "roles"]
  }

  rule {
    verbs      = ["create", "get", "list", "patch", "update", "delete", "watch"]
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = ["apps"]
    resources      = ["deployments/finalizers"]
    resource_names = ["tigera-operator"]
  }

  rule {
    verbs      = ["get", "list", "update", "patch", "watch"]
    api_groups = ["operator.tigera.io"]
    resources  = ["apiservers", "apiservers/finalizers", "apiservers/status", "gatewayapis", "gatewayapis/finalizers", "goldmanes", "goldmanes/finalizers", "goldmanes/status", "imagesets", "installations", "installations/finalizers", "installations/status", "managementclusterconnections", "managementclusterconnections/finalizers", "managementclusterconnections/status", "tigerastatuses", "tigerastatuses/status", "tigerastatuses/finalizers", "whiskers", "whiskers/finalizers", "whiskers/status"]
  }

  rule {
    verbs      = ["create", "delete"]
    api_groups = ["operator.tigera.io"]
    resources  = ["tigerastatuses"]
  }

  rule {
    verbs      = ["delete"]
    api_groups = ["operator.tigera.io"]
    resources  = ["installations", "apiservers", "whiskers", "goldmanes"]
  }

  rule {
    verbs      = ["create", "update", "delete", "get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
  }

  rule {
    verbs      = ["create", "patch", "list", "get", "watch"]
    api_groups = ["crd.projectcalico.org"]
    resources  = ["felixconfigurations", "ippools"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["crd.projectcalico.org"]
    resources  = ["kubecontrollersconfigurations", "bgpconfigurations", "clusterinformations"]
  }

  rule {
    verbs      = ["create", "update", "delete", "patch", "get", "list", "watch"]
    api_groups = ["projectcalico.org"]
    resources  = ["ippools"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["projectcalico.org"]
    resources  = ["ipamconfigurations", "clusterinformations"]
  }

  rule {
    verbs      = ["create", "get", "list", "update", "delete", "watch"]
    api_groups = ["scheduling.k8s.io"]
    resources  = ["priorityclasses"]
  }

  rule {
    verbs      = ["create", "get", "list", "update", "delete", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["list", "watch", "create", "update"]
    api_groups = ["apiregistration.k8s.io"]
    resources  = ["apiservices"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
  }

  rule {
    verbs      = ["delete", "get", "list", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["create", "get", "list", "update", "delete", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["list", "watch", "update", "get", "create", "delete"]
    api_groups = ["storage.k8s.io"]
    resources  = ["csidrivers"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs          = ["use"]
    api_groups     = ["policy"]
    resources      = ["podsecuritypolicies"]
    resource_names = ["tigera-operator"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
    api_groups = ["policy"]
    resources  = ["podsecuritypolicies"]
  }

  rule {
    verbs          = ["list", "watch", "get", "create", "update", "delete"]
    api_groups     = ["projectcalico.org"]
    resources      = ["tier.networkpolicies", "tier.globalnetworkpolicies"]
    resource_names = ["allow-tigera.*"]
  }

  rule {
    verbs          = ["get", "delete", "update"]
    api_groups     = ["projectcalico.org"]
    resources      = ["tiers"]
    resource_names = ["allow-tigera"]
  }

  rule {
    verbs      = ["create", "list", "watch"]
    api_groups = ["projectcalico.org"]
    resources  = ["tiers"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = ["apiextensions.k8s.io"]
    resources      = ["customresourcedefinitions"]
    resource_names = ["backendlbpolicies.gateway.networking.k8s.io", "backendtlspolicies.gateway.networking.k8s.io", "gatewayclasses.gateway.networking.k8s.io", "gateways.gateway.networking.k8s.io", "grpcroutes.gateway.networking.k8s.io", "httproutes.gateway.networking.k8s.io", "referencegrants.gateway.networking.k8s.io", "tcproutes.gateway.networking.k8s.io", "tlsroutes.gateway.networking.k8s.io", "udproutes.gateway.networking.k8s.io", "backends.gateway.envoyproxy.io", "backendtrafficpolicies.gateway.envoyproxy.io", "clienttrafficpolicies.gateway.envoyproxy.io", "envoyextensionpolicies.gateway.envoyproxy.io", "envoypatchpolicies.gateway.envoyproxy.io", "envoyproxies.gateway.envoyproxy.io", "httproutefilters.gateway.envoyproxy.io", "securitypolicies.gateway.envoyproxy.io"]
  }

  rule {
    verbs      = ["create", "update", "delete", "list", "get", "watch"]
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["gatewayclasses"]
  }

  rule {
    verbs      = ["create", "update", "delete", "list", "get", "watch"]
    api_groups = ["gateway.envoyproxy.io"]
    resources  = ["envoyproxies"]
  }

  rule {
    verbs      = ["create", "list", "watch"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = ["batch"]
    resources      = ["jobs"]
    resource_names = ["tigera-gateway-api-gateway-helm-certgen"]
  }
}

resource "kubernetes_cluster_role_binding" "tigera_operator" {
  metadata {
    name = "tigera-operator"

    labels = {
      k8s-app = "tigera-operator"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tigera-operator"
    namespace = "argocd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "tigera-operator"
  }
}

resource "kubernetes_role_binding" "tigera_operator_secrets" {
  metadata {
    name      = "tigera-operator-secrets"
    namespace = "argocd"

    labels = {
      k8s-app = "tigera-operator"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tigera-operator"
    namespace = "argocd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "tigera-operator-secrets"
  }
}

