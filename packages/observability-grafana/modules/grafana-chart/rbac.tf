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


resource "kubernetes_cluster_role" "release_name_grafana_clusterrole" {
  metadata {
    name = "release-name-grafana-clusterrole"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }
}

resource "kubernetes_cluster_role_binding" "release_name_grafana_clusterrolebinding" {
  metadata {
    name = "release-name-grafana-clusterrolebinding"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-grafana"
    namespace = "grafana"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-grafana-clusterrole"
  }
}

resource "kubernetes_role" "release_name_grafana" {
  metadata {
    name      = "release-name-grafana"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }
}

resource "kubernetes_role_binding" "release_name_grafana" {
  metadata {
    name      = "release-name-grafana"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-grafana"
    namespace = "grafana"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-grafana"
  }
}

