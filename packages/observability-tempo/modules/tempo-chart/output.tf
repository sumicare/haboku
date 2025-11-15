resource "kubernetes_pod_disruption_budget" "release_name_tempo_compactor" {
  metadata {
    name      = "release-name-tempo-compactor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_tempo_distributor" {
  metadata {
    name      = "release-name-tempo-distributor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_tempo_ingester" {
  metadata {
    name      = "release-name-tempo-ingester"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_tempo_querier" {
  metadata {
    name      = "release-name-tempo-querier"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_tempo_query_frontend" {
  metadata {
    name      = "release-name-tempo-query-frontend"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_service_account" "minio_sa" {
  metadata {
    name      = "minio-sa"
    namespace = "tempo"
  }
}

resource "kubernetes_service_account" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.31.1"
      "helm.sh/chart"                = "rollout-operator-0.35.1"
    }
  }
}

resource "kubernetes_service_account" "release_name_tempo" {
  metadata {
    name      = "release-name-tempo"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }
}

resource "kubernetes_secret" "release_name_minio" {
  metadata {
    name      = "release-name-minio"
    namespace = "tempo"

    labels = {
      app      = "minio"
      chart    = "minio-4.0.12"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  data = {
    rootPassword = "supersecret"
    rootUser     = "grafana-tempo"
  }

  type = "Opaque"
}

resource "kubernetes_persistent_volume_claim" "release_name_minio" {
  metadata {
    name      = "release-name-minio"
    namespace = "tempo"

    labels = {
      app      = "minio"
      chart    = "minio-4.0.12"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_cluster_role" "release_name_rollout_operator_webhook_clusterrole" {
  metadata {
    name = "release-name-rollout-operator-webhook-clusterrole"
  }

  rule {
    verbs      = ["list", "patch", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations", "mutatingwebhookconfigurations"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_rollout_operator_webhook_clusterrolebinding" {
  metadata {
    name = "release-name-rollout-operator-webhook-clusterrolebinding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "tempo"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-rollout-operator-webhook-clusterrole"
  }
}

resource "kubernetes_role" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.31.1"
      "helm.sh/chart"                = "rollout-operator-0.35.1"
    }
  }

  rule {
    verbs      = ["list", "get", "watch", "delete"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["list", "get", "watch", "patch"]
    api_groups = ["apps"]
    resources  = ["statefulsets"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["apps"]
    resources  = ["statefulsets/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["rollout-operator.grafana.com"]
    resources  = ["zoneawarepoddisruptionbudgets"]
  }

  rule {
    verbs      = ["get", "patch"]
    api_groups = ["rollout-operator.grafana.com"]
    resources  = ["replicatemplates/scale", "replicatemplates/status"]
  }
}

resource "kubernetes_role" "release_name_rollout_operator_webhook_role" {
  metadata {
    name      = "release-name-rollout-operator-webhook-role"
    namespace = "tempo"
  }

  rule {
    verbs          = ["update", "get"]
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["certificate"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_role_binding" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.31.1"
      "helm.sh/chart"                = "rollout-operator-0.35.1"
    }
  }

  subject {
    kind = "ServiceAccount"
    name = "release-name-rollout-operator"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-rollout-operator"
  }
}

resource "kubernetes_role_binding" "release_name_rollout_operator_webhook_rolebinding" {
  metadata {
    name      = "release-name-rollout-operator-webhook-rolebinding"
    namespace = "tempo"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "tempo"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-rollout-operator-webhook-role"
  }
}

resource "kubernetes_service" "release_name_minio_console" {
  metadata {
    name      = "release-name-minio-console"
    namespace = "tempo"

    labels = {
      app      = "minio"
      chart    = "minio-4.0.12"
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
    name      = "release-name-minio"
    namespace = "tempo"

    labels = {
      app        = "minio"
      chart      = "minio-4.0.12"
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
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.31.1"
      "helm.sh/chart"                = "rollout-operator-0.35.1"
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

resource "kubernetes_service" "release_name_tempo_compactor" {
  metadata {
    name      = "release-name-tempo-compactor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3200
      target_port = "http-metrics"
    }

    selector = {
      "app.kubernetes.io/component" = "compactor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    type             = "ClusterIP"
    ip_families      = ["IPv4"]
    ip_family_policy = "SingleStack"
  }
}

resource "kubernetes_service" "release_name_tempo_distributor_discovery" {
  metadata {
    name      = "release-name-tempo-distributor-discovery"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"   = "distributor"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "tempo"
      "app.kubernetes.io/version"     = "2.9.0"
      "helm.sh/chart"                 = "tempo-distributed-1.53.2"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      port        = 3200
      target_port = "http-metrics"
    }

    port {
      name         = "grpc-distributor-jaeger"
      protocol     = "TCP"
      app_protocol = "grpc"
      port         = 14250
      target_port  = "grpc-jaeger"
    }

    port {
      name        = "distributor-otlp-http"
      protocol    = "TCP"
      port        = 4318
      target_port = "otlp-http"
    }

    port {
      name         = "grpc-distributor-otlp"
      protocol     = "TCP"
      app_protocol = "grpc"
      port         = 4317
      target_port  = "grpc-otlp"
    }

    port {
      name         = "distributor-otlp-legacy"
      protocol     = "TCP"
      app_protocol = "grpc"
      port         = 55680
      target_port  = "grpc-otlp"
    }

    selector = {
      "app.kubernetes.io/component" = "distributor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_tempo_distributor" {
  metadata {
    name      = "release-name-tempo-distributor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      port        = 3200
      target_port = "http-metrics"
    }

    port {
      name         = "grpc"
      protocol     = "TCP"
      app_protocol = "grpc"
      port         = 9095
      target_port  = "9095"
    }

    port {
      name         = "grpc-distributor-jaeger"
      protocol     = "TCP"
      app_protocol = "grpc"
      port         = 14250
      target_port  = "grpc-jaeger"
    }

    port {
      name        = "distributor-otlp-http"
      protocol    = "TCP"
      port        = 4318
      target_port = "otlp-http"
    }

    port {
      name         = "grpc-distributor-otlp"
      protocol     = "TCP"
      app_protocol = "grpc"
      port         = 4317
      target_port  = "grpc-otlp"
    }

    port {
      name         = "distributor-otlp-legacy"
      protocol     = "TCP"
      app_protocol = "grpc"
      port         = 55680
      target_port  = "grpc-otlp"
    }

    selector = {
      "app.kubernetes.io/component" = "distributor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    type                    = "ClusterIP"
    ip_families             = ["IPv4"]
    ip_family_policy        = "SingleStack"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_tempo_gateway" {
  metadata {
    name      = "release-name-tempo-gateway"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
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
      name        = "grpc-otlp"
      protocol    = "TCP"
      port        = 4317
      target_port = "grpc-otlp"
    }

    selector = {
      "app.kubernetes.io/component" = "gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_tempo_gossip_ring" {
  metadata {
    name      = "release-name-tempo-gossip-ring"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "gossip-ring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "gossip-ring"
      protocol    = "TCP"
      port        = 7946
      target_port = "7946"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "tempo"
      "app.kubernetes.io/part-of"  = "memberlist"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
    ip_families                 = ["IPv4"]
    ip_family_policy            = "SingleStack"
  }
}

resource "kubernetes_service" "release_name_tempo_ingester_discovery" {
  metadata {
    name      = "release-name-tempo-ingester-discovery"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"   = "ingester"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "tempo"
      "app.kubernetes.io/version"     = "2.9.0"
      "helm.sh/chart"                 = "tempo-distributed-1.53.2"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3200
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
      "app.kubernetes.io/name"      = "tempo"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_tempo_ingester" {
  metadata {
    name      = "release-name-tempo-ingester"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3200
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
      "app.kubernetes.io/name"      = "tempo"
    }

    type                    = "ClusterIP"
    ip_families             = ["IPv4"]
    ip_family_policy        = "SingleStack"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_service" "release_name_tempo_memcached" {
  metadata {
    name      = "release-name-tempo-memcached"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
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
      "app.kubernetes.io/component" = "memcached"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    ip_families      = ["IPv4"]
    ip_family_policy = "SingleStack"
  }
}

resource "kubernetes_service" "release_name_tempo_metrics_generator_discovery" {
  metadata {
    name      = "release-name-tempo-metrics-generator-discovery"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"   = "metrics-generator"
      "app.kubernetes.io/instance"    = "release-name"
      "app.kubernetes.io/managed-by"  = "Helm"
      "app.kubernetes.io/name"        = "tempo"
      "app.kubernetes.io/part-of"     = "memberlist"
      "app.kubernetes.io/version"     = "2.9.0"
      "helm.sh/chart"                 = "tempo-distributed-1.53.2"
      "prometheus.io/service-monitor" = "false"
    }
  }

  spec {
    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "9095"
    }

    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3200
      target_port = "3200"
    }

    selector = {
      "app.kubernetes.io/component" = "metrics-generator"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    cluster_ip = "None"
    type       = "ClusterIP"
  }
}

resource "kubernetes_service" "release_name_tempo_metrics_generator" {
  metadata {
    name      = "release-name-tempo-metrics-generator"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "metrics-generator"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "9095"
    }

    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3200
      target_port = "3200"
    }

    selector = {
      "app.kubernetes.io/component" = "metrics-generator"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    ip_families      = ["IPv4"]
    ip_family_policy = "SingleStack"
  }
}

resource "kubernetes_service" "release_name_tempo_querier" {
  metadata {
    name      = "release-name-tempo-querier"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 3200
      target_port = "http-metrics"
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 9095
      target_port = "9095"
    }

    selector = {
      "app.kubernetes.io/component" = "querier"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "tempo"
    }

    ip_families      = ["IPv4"]
    ip_family_policy = "SingleStack"
  }
}

resource "kubernetes_service" "release_name_tempo_query_frontend_discovery" {
  metadata {
    name      = "release-name-tempo-query-frontend-discovery"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "http"
      port        = 3200
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
      "app.kubernetes.io/name"      = "tempo"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_tempo_query_frontend" {
  metadata {
    name      = "release-name-tempo-query-frontend"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      port        = 3200
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
      "app.kubernetes.io/name"      = "tempo"
    }

    type             = "ClusterIP"
    ip_families      = ["IPv4"]
    ip_family_policy = "SingleStack"
  }
}

resource "kubernetes_deployment" "release_name_minio" {
  metadata {
    name      = "release-name-minio"
    namespace = "tempo"

    labels = {
      app      = "minio"
      chart    = "minio-4.0.12"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "minio"
        release = "release-name"
      }
    }

    template {
      metadata {
        name = "release-name-minio"

        labels = {
          app     = "minio"
          release = "release-name"
        }

        annotations = {
          "checksum/config"  = "663aee13e764aa74addc22b416f456d143580cee879300dfecd050a3993be1ad"
          "checksum/secrets" = "7e7c33e7a33bb192309908ec820a7adeaa533d194a4128feb20df2da2e12e62b"
        }
      }

      spec {
        volume {
          name = "export"

          persistent_volume_claim {
            claim_name = "release-name-minio"
          }
        }

        volume {
          name = "minio-user"

          secret {
            secret_name = "release-name-minio"
          }
        }

        container {
          name    = "minio"
          image   = "quay.io/minio/minio:RELEASE.2022-08-13T21-54-44Z"
          command = ["/bin/sh", "-ce", "/usr/bin/docker-entrypoint.sh minio server /export -S /etc/minio/certs/ --address :9000 --console-address :9001"]

          port {
            name           = "http"
            container_port = 9000
          }

          port {
            name           = "http-console"
            container_port = 9001
          }

          env {
            name = "MINIO_ROOT_USER"

            value_from {
              secret_key_ref {
                name = "release-name-minio"
                key  = "rootUser"
              }
            }
          }

          env {
            name = "MINIO_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = "release-name-minio"
                key  = "rootPassword"
              }
            }
          }

          env {
            name  = "MINIO_PROMETHEUS_AUTH_TYPE"
            value = "public"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "minio-user"
            read_only  = true
            mount_path = "/tmp/credentials"
          }

          volume_mount {
            name       = "export"
            mount_path = "/export"
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "minio-sa"

        security_context {
          run_as_user            = 1000
          run_as_group           = 1000
          fs_group               = 1000
          fs_group_change_policy = "OnRootMismatch"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "100%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_rollout_operator" {
  metadata {
    name      = "release-name-rollout-operator"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.31.1"
      "helm.sh/chart"                = "rollout-operator-0.35.1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "rollout-operator"
      }
    }

    template {
      metadata {
        namespace = "tempo"

        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "rollout-operator"
        }
      }

      spec {
        container {
          name  = "rollout-operator"
          image = "grafana/rollout-operator:v0.31.1"
          args  = ["-kubernetes.namespace=tempo", "-server-tls.enabled=true", "-server-tls.self-signed-cert.secret-name=certificate"]

          port {
            name           = "http-metrics"
            container_port = 8001
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = 8443
            protocol       = "TCP"
          }

          resources {
            limits = {
              memory = "200Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        service_account_name = "release-name-rollout-operator"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_compactor" {
  metadata {
    name      = "release-name-tempo-compactor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "compactor"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "6db59e049e06a25ea7225005ebf9d426e47ebd5cf5af97cab759f702202e92a6"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-compactor-store"
          empty_dir = {}
        }

        container {
          name  = "compactor"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=compactor", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-compactor-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "compactor"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "compactor"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_distributor" {
  metadata {
    name      = "release-name-tempo-distributor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "distributor"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "6db59e049e06a25ea7225005ebf9d426e47ebd5cf5af97cab759f702202e92a6"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-distributor-store"
          empty_dir = {}
        }

        container {
          name  = "distributor"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=distributor", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          port {
            name           = "grpc-jaeger"
            container_port = 14250
            protocol       = "TCP"
          }

          port {
            name           = "otlp-http"
            container_port = 4318
            protocol       = "TCP"
          }

          port {
            name           = "grpc-otlp"
            container_port = 4317
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-distributor-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "distributor"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "distributor"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "distributor"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_gateway" {
  metadata {
    name      = "release-name-tempo-gateway"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "gateway"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "gateway"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "tempo"
        }

        annotations = {
          "checksum/config" = "ae0c7c5f7c7ea54ec49884cbc26c67b1625abdfdb1a2d3da51eae1a8264d8324"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-gateway"
          }
        }

        volume {
          name = "auth"

          secret {
            secret_name = "tempo-basic-auth"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "docker-entrypoint-d-override"
          empty_dir = {}
        }

        container {
          name  = "nginx"
          image = "docker.io/nginxinc/nginx-unprivileged:1.27-alpine"

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc-otlp"
            container_port = 4317
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/nginx"
          }

          volume_mount {
            name       = "auth"
            mount_path = "/etc/nginx/secrets"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "docker-entrypoint-d-override"
            mount_path = "/docker-entrypoint.d"
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "gateway"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "gateway"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_metrics_generator" {
  metadata {
    name      = "release-name-tempo-metrics-generator"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "metrics-generator"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "metrics-generator"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "metrics-generator"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "6db59e049e06a25ea7225005ebf9d426e47ebd5cf5af97cab759f702202e92a6"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "wal"
          empty_dir = {}
        }

        container {
          name  = "metrics-generator"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=metrics-generator", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "grpc"
            container_port = 9095
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
          }

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "wal"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "metrics-generator"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "metrics-generator"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "metrics-generator"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_querier" {
  metadata {
    name      = "release-name-tempo-querier"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "querier"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "6db59e049e06a25ea7225005ebf9d426e47ebd5cf5af97cab759f702202e92a6"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-querier-store"
          empty_dir = {}
        }

        container {
          name  = "querier"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=querier", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-querier-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "querier"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "querier"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "querier"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_tempo_query_frontend" {
  metadata {
    name      = "release-name-tempo-query-frontend"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "query-frontend"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "6db59e049e06a25ea7225005ebf9d426e47ebd5cf5af97cab759f702202e92a6"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        volume {
          name      = "tempo-queryfrontend-store"
          empty_dir = {}
        }

        container {
          name  = "query-frontend"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=query-frontend", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          port {
            name           = "grpc"
            container_port = 9095
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "tempo-queryfrontend-store"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "query-frontend"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "query-frontend"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "query-frontend"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_compactor" {
  metadata {
    name      = "release-name-tempo-compactor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "compactor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-compactor"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 100
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_distributor" {
  metadata {
    name      = "release-name-tempo-distributor"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "distributor"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-distributor"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_querier" {
  metadata {
    name      = "release-name-tempo-querier"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "querier"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-querier"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_tempo_query_frontend" {
  metadata {
    name      = "release-name-tempo-query-frontend"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "query-frontend"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-tempo-query-frontend"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}

resource "kubernetes_stateful_set" "release_name_tempo_ingester" {
  metadata {
    name      = "release-name-tempo-ingester"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "ingester"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/part-of"    = "memberlist"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "ingester"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }

        annotations = {
          "checksum/config" = "6db59e049e06a25ea7225005ebf9d426e47ebd5cf5af97cab759f702202e92a6"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-tempo-config"

            items {
              key  = "tempo.yaml"
              path = "tempo.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-tempo-runtime"

            items {
              key  = "overrides.yaml"
              path = "overrides.yaml"
            }
          }
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/tempo:2.9.0"
          args  = ["-target=ingester", "-config.file=/conf/tempo.yaml", "-mem-ballast-size-mbs=1024"]

          port {
            name           = "grpc"
            container_port = 9095
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
          }

          port {
            name           = "http-metrics"
            container_port = 3200
          }

          volume_mount {
            name       = "config"
            mount_path = "/conf"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/tempo"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "ingester"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "kubernetes.io/hostname"
              }
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 75

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "ingester"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    service_name           = "ingester"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10

    persistent_volume_claim_retention_policy {
      when_deleted = "Retain"
      when_scaled  = "Retain"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_tempo_memcached" {
  metadata {
    name      = "release-name-tempo-memcached"
    namespace = "tempo"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "tempo"
      "app.kubernetes.io/version"    = "2.9.0"
      "helm.sh/chart"                = "tempo-distributed-1.53.2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "memcached"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "tempo"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "memcached"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "tempo"
          "app.kubernetes.io/version"    = "2.9.0"
          "helm.sh/chart"                = "tempo-distributed-1.53.2"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "docker.io/memcached:1.6.39-alpine"

          port {
            name           = "client"
            container_port = 11211
          }

          liveness_probe {
            exec {
              command = ["pgrep", "memcached"]
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            success_threshold     = 1
            failure_threshold     = 6
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        container {
          name  = "exporter"
          image = "docker.io/prom/memcached-exporter:v0.15.3"
          args  = ["--memcached.address=localhost:11211", "--web.listen-address=0.0.0.0:9150"]

          port {
            name           = "http-metrics"
            container_port = 9150
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 1000
            run_as_group              = 1000
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        service_account_name = "release-name-tempo"

        security_context {
          fs_group = 1000
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "memcached"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "tempo"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }

            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "memcached"
                    "app.kubernetes.io/instance"  = "release-name"
                    "app.kubernetes.io/name"      = "tempo"
                  }
                }

                topology_key = "topology.kubernetes.io/zone"
              }
            }
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "memcached"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "tempo"
            }
          }
        }
      }
    }

    service_name = "memcached"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_job" "release_name_minio_make_bucket_job" {
  metadata {
    name      = "release-name-minio-make-bucket-job"
    namespace = "tempo"

    labels = {
      app      = "minio-make-bucket-job"
      chart    = "minio-4.0.12"
      heritage = "Helm"
      release  = "release-name"
    }

    annotations = {
      "helm.sh/hook"               = "post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "hook-succeeded,before-hook-creation"
    }
  }

  spec {
    template {
      metadata {
        labels = {
          app     = "minio-job"
          release = "release-name"
        }
      }

      spec {
        volume {
          name = "minio-configuration"

          projected {
            sources {
              config_map {
                name = "release-name-minio"
              }
            }

            sources {
              secret {
                name = "release-name-minio"
              }
            }
          }
        }

        container {
          name    = "minio-mc"
          image   = "quay.io/minio/mc:RELEASE.2022-08-11T00-30-48Z"
          command = ["/bin/sh", "/config/initialize"]

          env {
            name  = "MINIO_ENDPOINT"
            value = "release-name-minio"
          }

          env {
            name  = "MINIO_PORT"
            value = "9000"
          }

          resources {
            requests = {
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "minio-configuration"
            mount_path = "/config"
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "OnFailure"
      }
    }
  }
}

resource "kubernetes_job" "release_name_minio_make_user_job" {
  metadata {
    name      = "release-name-minio-make-user-job"
    namespace = "tempo"

    labels = {
      app      = "minio-make-user-job"
      chart    = "minio-4.0.12"
      heritage = "Helm"
      release  = "release-name"
    }

    annotations = {
      "helm.sh/hook"               = "post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "hook-succeeded,before-hook-creation"
    }
  }

  spec {
    template {
      metadata {
        labels = {
          app     = "minio-job"
          release = "release-name"
        }
      }

      spec {
        volume {
          name = "minio-configuration"

          projected {
            sources {
              config_map {
                name = "release-name-minio"
              }
            }

            sources {
              secret {
                name = "release-name-minio"
              }
            }
          }
        }

        container {
          name    = "minio-mc"
          image   = "quay.io/minio/mc:RELEASE.2022-08-11T00-30-48Z"
          command = ["/bin/sh", "/config/add-user"]

          env {
            name  = "MINIO_ENDPOINT"
            value = "release-name-minio"
          }

          env {
            name  = "MINIO_PORT"
            value = "9000"
          }

          resources {
            requests = {
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "minio-configuration"
            mount_path = "/config"
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "OnFailure"
      }
    }
  }
}

