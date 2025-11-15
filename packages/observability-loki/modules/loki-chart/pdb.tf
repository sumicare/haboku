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


resource "kubernetes_pod_disruption_budget" "loki_backend" {
  metadata {
    name      = "loki-backend"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "backend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "backend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_bloom_builder" {
  metadata {
    name      = "release-name-loki-bloom-builder"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-builder"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "bloom-builder"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_distributor" {
  metadata {
    name      = "release-name-loki-distributor"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "distributor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_gateway" {
  metadata {
    name      = "release-name-loki-gateway"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_index_gateway" {
  metadata {
    name      = "release-name-loki-index-gateway"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "index-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "index-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_ingester_rollout" {
  metadata {
    name      = "release-name-loki-ingester-rollout"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        rollout-group = "ingester"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_pattern_ingester" {
  metadata {
    name      = "release-name-loki-pattern-ingester"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "pattern-ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "pattern-ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_querier" {
  metadata {
    name      = "release-name-loki-querier"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "querier"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_query_frontend" {
  metadata {
    name      = "release-name-loki-query-frontend"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "query-frontend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_query_scheduler" {
  metadata {
    name      = "release-name-loki-query-scheduler"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "query-scheduler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-scheduler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "loki_read" {
  metadata {
    name      = "loki-read"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "read"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "read"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_loki_ruler" {
  metadata {
    name      = "release-name-loki-ruler"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ruler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ruler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "loki_write" {
  metadata {
    name      = "loki-write"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "write"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "write"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    max_unavailable = "1"
  }
}

