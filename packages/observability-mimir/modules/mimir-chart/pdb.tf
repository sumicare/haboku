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


resource "kubernetes_pod_disruption_budget" "release_name_mimir_alertmanager" {
  metadata {
    name      = "release-name-mimir-alertmanager"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "alertmanager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "alertmanager"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_chunks_cache" {
  metadata {
    name      = "release-name-mimir-chunks-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "chunks-cache"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "chunks-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_compactor" {
  metadata {
    name      = "release-name-mimir-compactor"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_distributor" {
  metadata {
    name      = "release-name-mimir-distributor"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_gateway" {
  metadata {
    name      = "release-name-mimir-gateway"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_index_cache" {
  metadata {
    name      = "release-name-mimir-index-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "index-cache"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "index-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_ingester" {
  metadata {
    name      = "release-name-mimir-ingester"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_kafka" {
  metadata {
    name      = "release-name-mimir-kafka"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "kafka"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "kafka"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_metadata_cache" {
  metadata {
    name      = "release-name-mimir-metadata-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "metadata-cache"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "metadata-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_overrides_exporter" {
  metadata {
    name      = "release-name-mimir-overrides-exporter"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "overrides-exporter"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "overrides-exporter"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_querier" {
  metadata {
    name      = "release-name-mimir-querier"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_query_frontend" {
  metadata {
    name      = "release-name-mimir-query-frontend"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_query_scheduler" {
  metadata {
    name      = "release-name-mimir-query-scheduler"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "query-scheduler"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-scheduler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_ruler" {
  metadata {
    name      = "release-name-mimir-ruler"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "ruler"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ruler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_mimir_store_gateway" {
  metadata {
    name      = "release-name-mimir-store-gateway"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "store-gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "store-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    max_unavailable = "1"
  }
}

