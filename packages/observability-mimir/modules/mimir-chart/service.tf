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


resource "kubernetes_service" "release_name_minio_console" {
  metadata {
    name = "release-name-minio-console"

    labels = {
      app      = "minio"
      chart    = "minio-5.4.0"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 9001
      target_port = "9001"
    }

    selector = {
      app     = "minio"
      release = "release-name"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_minio" {
  metadata {
    name = "release-name-minio"

    labels = {
      app        = "minio"
      chart      = "minio-5.4.0"
      heritage   = "Helm"
      monitoring = "true"
      release    = "release-name"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 9000
      target_port = "9000"
    }

    selector = {
      app     = "minio"
      release = "release-name"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.32.0"
      "helm.sh/chart"                = "rollout-operator-0.37.1"
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

resource "kubernetes_service" "release_name_mimir_alertmanager_headless" {
  metadata {
    name      = "release-name-mimir-alertmanager-headless"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"   = "alertmanager"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "mimir"
      "app.kubernetes.io/part-of"     = "memberlist"
      "app.kubernetes.io/version"     = "3.0.0"
      "helm.sh/chart"                 = "mimir-distributed-6.0.3"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    port {
      name     = "cluster"
      protocol = "TCP"
      port     = 9094
    }

    selector = {
      "app.kubernetes.io/component" = "alertmanager"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_mimir_alertmanager_zone_a" {
  metadata {
    name      = "release-name-mimir-alertmanager-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "alertmanager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "alertmanager-zone-a"
      rollout-group                  = "alertmanager"
      zone                           = "zone-a"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "alertmanager"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "alertmanager"
      zone                          = "zone-a"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_alertmanager_zone_b" {
  metadata {
    name      = "release-name-mimir-alertmanager-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "alertmanager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "alertmanager-zone-b"
      rollout-group                  = "alertmanager"
      zone                           = "zone-b"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "alertmanager"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "alertmanager"
      zone                          = "zone-b"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_alertmanager_zone_c" {
  metadata {
    name      = "release-name-mimir-alertmanager-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "alertmanager"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "alertmanager-zone-c"
      rollout-group                  = "alertmanager"
      zone                           = "zone-c"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "alertmanager"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "alertmanager"
      zone                          = "zone-c"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_chunks_cache" {
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
    port {
      name        = "memcached-client"
      port        = 11211
      target_port = "11211"
    }

    port {
      name        = "http-metrics"
      port        = 9150
      target_port = "9150"
    }

    selector = {
      "app.kubernetes.io/component" = "chunks-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_compactor" {
  metadata {
    name      = "release-name-mimir-compactor"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_distributor_headless" {
  metadata {
    name      = "release-name-mimir-distributor-headless"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"   = "distributor"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "mimir"
      "app.kubernetes.io/part-of"     = "memberlist"
      "app.kubernetes.io/version"     = "3.0.0"
      "helm.sh/chart"                 = "mimir-distributed-6.0.3"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_distributor" {
  metadata {
    name      = "release-name-mimir-distributor"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_gateway" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 80
      target_port = "http-metrics"
    }

    port {
      name        = "legacy-http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    selector = {
      "app.kubernetes.io/component" = "gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_gossip_ring" {
  metadata {
    name      = "release-name-mimir-gossip-ring"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "gossip-ring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    port {
      name         = "gossip-ring"
      protocol     = "TCP"
      app_protocol = "tcp"
      port         = 7946
      target_port  = "7946"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "mimir"
      "app.kubernetes.io/part-of"  = "memberlist"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_mimir_index_cache" {
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
    port {
      name        = "memcached-client"
      port        = 11211
      target_port = "11211"
    }

    port {
      name        = "http-metrics"
      port        = 9150
      target_port = "9150"
    }

    selector = {
      "app.kubernetes.io/component" = "index-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_ingester_headless" {
  metadata {
    name      = "release-name-mimir-ingester-headless"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"   = "ingester"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "mimir"
      "app.kubernetes.io/part-of"     = "memberlist"
      "app.kubernetes.io/version"     = "3.0.0"
      "helm.sh/chart"                 = "mimir-distributed-6.0.3"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_ingester_zone_a" {
  metadata {
    name      = "release-name-mimir-ingester-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "ingester-zone-a"
      rollout-group                  = "ingester"
      zone                           = "zone-a"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "ingester"
      zone                          = "zone-a"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_ingester_zone_b" {
  metadata {
    name      = "release-name-mimir-ingester-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "ingester-zone-b"
      rollout-group                  = "ingester"
      zone                           = "zone-b"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "ingester"
      zone                          = "zone-b"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_ingester_zone_c" {
  metadata {
    name      = "release-name-mimir-ingester-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "ingester-zone-c"
      rollout-group                  = "ingester"
      zone                           = "zone-c"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "ingester"
      zone                          = "zone-c"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_kafka_headless" {
  metadata {
    name      = "release-name-mimir-kafka-headless"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"   = "kafka"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "mimir"
      "app.kubernetes.io/version"     = "3.0.0"
      "helm.sh/chart"                 = "mimir-distributed-6.0.3"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "kafka"
      protocol    = "TCP"
      port        = 9092
      target_port = "kafka"
    }

    port {
      name        = "controller"
      protocol    = "TCP"
      port        = 9093
      target_port = "controller"
    }

    selector = {
      "app.kubernetes.io/component" = "kafka"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_kafka" {
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
    port {
      name        = "kafka"
      protocol    = "TCP"
      port        = 9092
      target_port = "kafka"
    }

    selector = {
      "app.kubernetes.io/component" = "kafka"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_metadata_cache" {
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
    port {
      name        = "memcached-client"
      port        = 11211
      target_port = "11211"
    }

    port {
      name        = "http-metrics"
      port        = 9150
      target_port = "9150"
    }

    selector = {
      "app.kubernetes.io/component" = "metadata-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_overrides_exporter" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "overrides-exporter"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_querier" {
  metadata {
    name      = "release-name-mimir-querier"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
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
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_query_frontend" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "query-frontend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_query_scheduler_headless" {
  metadata {
    name      = "release-name-mimir-query-scheduler-headless"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"   = "query-scheduler"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "mimir"
      "app.kubernetes.io/version"     = "3.0.0"
      "helm.sh/chart"                 = "mimir-distributed-6.0.3"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "query-scheduler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_mimir_query_scheduler" {
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
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "query-scheduler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_ruler" {
  metadata {
    name      = "release-name-mimir-ruler"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "ruler"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    selector = {
      "app.kubernetes.io/component" = "ruler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_store_gateway_headless" {
  metadata {
    name      = "release-name-mimir-store-gateway-headless"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"   = "store-gateway"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "mimir"
      "app.kubernetes.io/part-of"     = "memberlist"
      "app.kubernetes.io/version"     = "3.0.0"
      "helm.sh/chart"                 = "mimir-distributed-6.0.3"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "store-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_mimir_store_gateway_zone_a" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "store-gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "store-gateway-zone-a"
      rollout-group                  = "store-gateway"
      zone                           = "zone-a"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "store-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "store-gateway"
      zone                          = "zone-a"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_store_gateway_zone_b" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "store-gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "store-gateway-zone-b"
      rollout-group                  = "store-gateway"
      zone                           = "zone-b"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "store-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "store-gateway"
      zone                          = "zone-b"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_mimir_store_gateway_zone_c" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "store-gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
      name                           = "store-gateway-zone-c"
      rollout-group                  = "store-gateway"
      zone                           = "zone-c"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "grpc"
    }

    selector = {
      "app.kubernetes.io/component" = "store-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "mimir"
      rollout-group                 = "store-gateway"
      zone                          = "zone-c"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

