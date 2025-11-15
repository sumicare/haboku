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


resource "kubernetes_service" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.29.0"
      "helm.sh/chart"                = "rollout-operator-0.33.2"
    }
  }

  spec {
    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = "8443"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "rollout-operator"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_query_scheduler_discovery" {
  metadata {
    name      = "release-name-loki-query-scheduler-discovery"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "backend"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "backend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "loki_backend_headless" {
  metadata {
    name      = "loki-backend-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "backend"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "prometheus.io/service-monitor" = "false"
      variant                         = "headless"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name         = "grpc"
      protocol     = "TCP"
      app_protocol = "tcp"
      port         = 9095
      target_port  = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "backend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "loki_backend" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "backend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_bloom_builder" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    port {
      name        = "grpclb"
      protocol    = "TCP"
      port        = 9096
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "bloom-builder"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_loki_bloom_gateway_headless" {
  metadata {
    name      = "release-name-loki-bloom-gateway-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "bloom-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_bloom_planner_headless" {
  metadata {
    name      = "release-name-loki-bloom-planner-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-planner"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "bloom-planner"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_chunks_cache" {
  metadata {
    name      = "release-name-loki-chunks-cache"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "memcached-chunks-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    port {
      name        = "memcached-client"
      port        = 11211
      target_port = "client"
    }

    port {
      name        = "http-metrics"
      port        = 9150
      target_port = "http-metrics"
    }

    selector = {
      "app.kubernetes.io/component" = "memcached-chunks-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_compactor" {
  metadata {
    name      = "release-name-loki-compactor"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "compactor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "compactor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_distributor_headless" {
  metadata {
    name      = "release-name-loki-distributor-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "distributor"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "prometheus.io/service-monitor" = "false"
      variant                         = "headless"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "distributor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_distributor" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "distributor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_gateway" {
  metadata {
    name      = "release-name-loki-gateway"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "gateway"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "app.kubernetes.io/version"     = "3.5.7"
      "helm.sh/chart"                 = "loki-6.46.0"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 80
      target_port = "http-metrics"
    }

    selector = {
      "app.kubernetes.io/component" = "gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_index_gateway_headless" {
  metadata {
    name      = "release-name-loki-index-gateway-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "index-gateway"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "index-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_index_gateway" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "index-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_ingester_zone_a_headless" {
  metadata {
    name      = "release-name-loki-ingester-zone-a-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "ingester"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "app.kubernetes.io/version"     = "3.5.7"
      "helm.sh/chart"                 = "loki-6.46.0"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      name                          = "ingester-zone-a"
      rollout-group                 = "ingester"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "release_name_loki_ingester_zone_b_headless" {
  metadata {
    name      = "release-name-loki-ingester-zone-b-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "ingester"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "app.kubernetes.io/version"     = "3.5.7"
      "helm.sh/chart"                 = "loki-6.46.0"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      name                          = "ingester-zone-b"
      rollout-group                 = "ingester"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "release_name_loki_ingester_zone_c_headless" {
  metadata {
    name      = "release-name-loki-ingester-zone-c-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "ingester"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "app.kubernetes.io/version"     = "3.5.7"
      "helm.sh/chart"                 = "loki-6.46.0"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      name                          = "ingester-zone-c"
      rollout-group                 = "ingester"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "release_name_loki_ingester" {
  metadata {
    name      = "release-name-loki-ingester"
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_querier" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "querier"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_query_frontend_headless" {
  metadata {
    name      = "release-name-loki-query-frontend-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "query-frontend"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "app.kubernetes.io/version"     = "3.5.7"
      "helm.sh/chart"                 = "loki-6.46.0"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    port {
      name        = "grpclb"
      protocol    = "TCP"
      port        = 9096
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "query-frontend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_loki_query_frontend" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    port {
      name        = "grpclb"
      protocol    = "TCP"
      port        = 9096
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "query-frontend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_loki_query_scheduler" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpclb"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "query-scheduler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "loki_read_headless" {
  metadata {
    name      = "loki-read-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "read"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "prometheus.io/service-monitor" = "false"
      variant                         = "headless"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name         = "grpc"
      protocol     = "TCP"
      app_protocol = "tcp"
      port         = 9095
      target_port  = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "read"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "loki_read" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "read"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_results_cache" {
  metadata {
    name      = "release-name-loki-results-cache"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "memcached-results-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    port {
      name        = "memcached-client"
      port        = 11211
      target_port = "client"
    }

    port {
      name        = "http-metrics"
      port        = 9150
      target_port = "http-metrics"
    }

    selector = {
      "app.kubernetes.io/component" = "memcached-results-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_ruler" {
  metadata {
    name      = "release-name-loki-ruler"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ruler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "ruler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_loki_memberlist" {
  metadata {
    name      = "release-name-loki-memberlist"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  spec {
    port {
      name        = "tcp"
      protocol    = "TCP"
      port        = 7946
      target_port = "http-memberlist"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/part-of"  = "memberlist"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "loki_write_headless" {
  metadata {
    name      = "loki-write-headless"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component"   = "write"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/name"        = "loki"
      "prometheus.io/service-monitor" = "false"
      variant                         = "headless"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name         = "grpc"
      protocol     = "TCP"
      app_protocol = "tcp"
      port         = 9095
      target_port  = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "write"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "loki_write" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3100
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "write"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
    }

    type = "ClusterIP"
  }
}

