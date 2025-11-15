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


resource "kubernetes_network_policy" "loki_namespace_only" {
  metadata {
    name      = "loki-namespace-only"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  spec {
    pod_selector {}

    ingress {}

    egress {}

    policy_types = ["Ingress", "Egress"]
  }
}

resource "kubernetes_network_policy" "loki_egress_dns" {
  metadata {
    name      = "loki-egress-dns"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "loki"
      }
    }

    egress {
      ports {
        protocol = "UDP"
        port     = "53"
      }

      ports {
        protocol = "TCP"
        port     = "53"
      }
    }

    policy_types = ["Egress"]
  }
}

resource "kubernetes_network_policy" "loki_ingress" {
  metadata {
    name      = "loki-ingress"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "loki"
      }

      match_expressions {
        key      = "app.kubernetes.io/component"
        operator = "In"
        values   = ["gateway"]
      }
    }

    ingress {
      ports {
        protocol = "TCP"
        port     = "http-metrics"
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "loki_ingress_metrics" {
  metadata {
    name      = "loki-ingress-metrics"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "loki"
      }
    }

    ingress {
      ports {
        protocol = "TCP"
        port     = "http-metrics"
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "loki_egress_alertmanager" {
  metadata {
    name      = "loki-egress-alertmanager"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/component" = "backend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    egress {
      ports {
        protocol = "TCP"
        port     = "9093"
      }
    }

    policy_types = ["Egress"]
  }
}

