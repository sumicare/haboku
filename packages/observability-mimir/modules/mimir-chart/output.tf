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

resource "kubernetes_service_account" "minio_sa" {
  metadata {
    name = "minio-sa"
  }
}

resource "kubernetes_service_account" "release_name_rollout_operator" {
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
}

resource "kubernetes_service_account" "release_name_mimir" {
  metadata {
    name      = "release-name-mimir"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }
}

resource "kubernetes_secret" "release_name_minio" {
  metadata {
    name = "release-name-minio"

    labels = {
      app      = "minio"
      chart    = "minio-5.4.0"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  data = {
    rootPassword = "supersecret"
    rootUser     = "grafana-mimir"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "release_name_mimir_logs_instance_usernames" {
  metadata {
    name      = "release-name-mimir-logs-instance-usernames"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }
}

resource "kubernetes_secret" "release_name_mimir_metrics_instance_usernames" {
  metadata {
    name      = "release-name-mimir-metrics-instance-usernames"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "release_name_minio" {
  metadata {
    name = "release-name-minio"

    labels = {
      app      = "minio"
      chart    = "minio-5.4.0"
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

resource "kubernetes_cluster_role" "release_name_mimir_grafana_agent" {
  metadata {
    name = "release-name-mimir-grafana-agent"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods", "events"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics", "/metrics/cadvisor"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_rollout_operator_webhook_clusterrolebinding" {
  metadata {
    name = "release-name-rollout-operator-webhook-clusterrolebinding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "mimir"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-rollout-operator-webhook-clusterrole"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_mimir_grafana_agent" {
  metadata {
    name = "release-name-mimir-grafana-agent"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-mimir"
    namespace = "mimir"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-mimir-grafana-agent"
  }
}

resource "kubernetes_role" "release_name_rollout_operator" {
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
    namespace = "mimir"
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
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.32.0"
      "helm.sh/chart"                = "rollout-operator-0.37.1"
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
    namespace = "mimir"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "mimir"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-rollout-operator-webhook-role"
  }
}

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

resource "kubernetes_deployment" "release_name_minio" {
  metadata {
    name = "release-name-minio"

    labels = {
      app      = "minio"
      chart    = "minio-5.4.0"
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
          "checksum/config"  = "b98a6c0d8086de24ec40aa45a31f6ab53fe80a87f3aa624287f135baca7c09f8"
          "checksum/secrets" = "1b9db1c229d9a611c469bca0f59e5a254f0e286dd0eef060f725ec4ce26aca35"
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
          image   = "quay.io/minio/minio:RELEASE.2024-12-18T13-15-44Z"
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
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "rollout-operator"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "rollout-operator"
        }
      }

      spec {
        container {
          name  = "rollout-operator"
          image = "grafana/rollout-operator:v0.32.0"
          args  = ["-kubernetes.namespace=mimir", "-server-tls.enabled=true", "-server-tls.self-signed-cert.secret-name=certificate", "-server-tls.self-signed-cert.dns-name=release-name-rollout-operator.mimir.svc"]

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

resource "kubernetes_deployment" "release_name_mimir_distributor" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "distributor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "distributor"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=distributor", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-server.grpc.keepalive.max-connection-age=60s", "-server.grpc.keepalive.max-connection-age-grace=5m", "-server.grpc.keepalive.max-connection-idle=1m", "-shutdown-delay=90s"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "8"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 100
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "distributor"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }

          min_domains          = 1
          node_affinity_policy = "Honor"
          node_taints_policy   = "Honor"
          match_label_keys     = ["pod-template-hash"]
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_gateway" {
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

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "gateway"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "9146afc55e0a0192aad4cfaf3ccbfd3800308f4bafbdf457034b5286621bca6d"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name = "nginx-config"

          config_map {
            name = "release-name-mimir-gateway-nginx"
          }
        }

        volume {
          name      = "docker-entrypoint-d-override"
          empty_dir = {}
        }

        volume {
          name = "auth"

          secret {
            secret_name = "mimir-basic-auth"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "gateway"
          image = "docker.io/nginxinc/nginx-unprivileged:1.29-alpine"

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = "2"
              memory = "256Mi"
            }

            requests = {
              cpu    = "1"
              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
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

          readiness_probe {
            http_get {
              path = "/ready"
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_overrides_exporter" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "overrides-exporter"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "overrides-exporter"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "overrides-exporter"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=overrides-exporter", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-mimir"

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
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_querier" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "querier"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "querier"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/part-of"    = "memberlist"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "querier"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=querier", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-querier.store-gateway-client.grpc-max-recv-msg-size=209715200"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "5"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 180
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "querier"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_query_frontend" {
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

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "query-frontend"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "query-frontend"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=query-frontend", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-server.grpc.keepalive.max-connection-age=30s", "-shutdown-delay=90s"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 390
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "query-frontend"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "15%"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_query_scheduler" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-scheduler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "query-scheduler"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "query-scheduler"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=query-scheduler", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 180
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "query-scheduler"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "1"
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_mimir_ruler" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ruler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "storage"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ruler"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ruler", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-distributor.remote-timeout=10s"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 600
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ruler"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "50%"
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_mimir_gateway" {
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
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-mimir-gateway"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "memory"

        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_alertmanager_zone_a" {
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

    annotations = {
      rollout-max-unavailable = "2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "alertmanager"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "alertmanager"
        zone                          = "zone-a"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/alertmanager-fallback-config" = "230274102d470b64082478b2a146ca962b0668b130c72df7f72d05565393f18a"
          "checksum/config"                       = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        volume {
          name = "alertmanager-fallback-config"

          config_map {
            name = "release-name-mimir-alertmanager-fallback-config"
          }
        }

        container {
          name  = "alertmanager"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=alertmanager", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-alertmanager.sharding-ring.instance-availability-zone=zone-a", "-server.http-idle-timeout=6m"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "32Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "alertmanager-fallback-config"
            mount_path = "/configs/"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 900
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "alertmanager"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "release-name-mimir-alertmanager"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_alertmanager_zone_b" {
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

    annotations = {
      rollout-max-unavailable = "2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "alertmanager"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "alertmanager"
        zone                          = "zone-b"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/alertmanager-fallback-config" = "230274102d470b64082478b2a146ca962b0668b130c72df7f72d05565393f18a"
          "checksum/config"                       = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        volume {
          name = "alertmanager-fallback-config"

          config_map {
            name = "release-name-mimir-alertmanager-fallback-config"
          }
        }

        container {
          name  = "alertmanager"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=alertmanager", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-alertmanager.sharding-ring.instance-availability-zone=zone-b", "-server.http-idle-timeout=6m"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "32Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "alertmanager-fallback-config"
            mount_path = "/configs/"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 900
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "alertmanager"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "release-name-mimir-alertmanager"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_alertmanager_zone_c" {
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

    annotations = {
      rollout-max-unavailable = "2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "alertmanager"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "alertmanager"
        zone                          = "zone-c"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/alertmanager-fallback-config" = "230274102d470b64082478b2a146ca962b0668b130c72df7f72d05565393f18a"
          "checksum/config"                       = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        volume {
          name = "alertmanager-fallback-config"

          config_map {
            name = "release-name-mimir-alertmanager-fallback-config"
          }
        }

        container {
          name  = "alertmanager"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=alertmanager", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-alertmanager.sharding-ring.instance-availability-zone=zone-c", "-server.http-idle-timeout=6m"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "32Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "alertmanager-fallback-config"
            mount_path = "/configs/"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 45
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 900
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "alertmanager"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "release-name-mimir-alertmanager"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_chunks_cache" {
  metadata {
    name      = "release-name-mimir-chunks-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "chunks-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
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
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 8192", "--extended=modern", "-I 1m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "9830Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "9830Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        container {
          name  = "exporter"
          image = "prom/memcached-exporter:v0.15.3"
          args  = ["--memcached.address=localhost:11211", "--web.listen-address=0.0.0.0:9150"]

          port {
            name           = "http-metrics"
            container_port = 9150
          }

          resources {
            limits = {
              memory = "250Mi"
            }

            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-mimir"

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

    service_name          = "release-name-mimir-chunks-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_compactor" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "compactor"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=compactor", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 900
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "compactor"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-compactor"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_index_cache" {
  metadata {
    name      = "release-name-mimir-index-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "index-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
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
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 2048", "--extended=modern", "-I 5m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "2458Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "2458Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        container {
          name  = "exporter"
          image = "prom/memcached-exporter:v0.15.3"
          args  = ["--memcached.address=localhost:11211", "--web.listen-address=0.0.0.0:9150"]

          port {
            name           = "http-metrics"
            container_port = 9150
          }

          resources {
            limits = {
              memory = "250Mi"
            }

            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-mimir"

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

    service_name          = "release-name-mimir-index-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_ingester_zone_a" {
  metadata {
    name      = "release-name-mimir-ingester-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "ingester"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "12h"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "ingester-zone-a"
      rollout-group                                  = "ingester"
      zone                                           = "zone-a"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "ingester/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "ingester"
        zone                          = "zone-a"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ingester"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ingester", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-ingester.ring.instance-availability-zone=zone-a", "-memberlist.abort-if-fast-join-fails=true"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "4"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 1200
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-ingester-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_ingester_zone_b" {
  metadata {
    name      = "release-name-mimir-ingester-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "ingester"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "12h"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "ingester-zone-b"
      rollout-group                                  = "ingester"
      zone                                           = "zone-b"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "ingester/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-ingester-zone-a"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "ingester"
        zone                          = "zone-b"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ingester"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ingester", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-ingester.ring.instance-availability-zone=zone-b", "-memberlist.abort-if-fast-join-fails=true"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "4"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 1200
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-ingester-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_ingester_zone_c" {
  metadata {
    name      = "release-name-mimir-ingester-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "ingester"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "12h"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "ingester-zone-c"
      rollout-group                                  = "ingester"
      zone                                           = "zone-c"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "ingester/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-ingester-zone-b"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "ingester"
        zone                          = "zone-c"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "ingester"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=ingester", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-ingester.ring.instance-availability-zone=zone-c", "-memberlist.abort-if-fast-join-fails=true"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "4"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 1200
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "ingester"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-ingester-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_kafka" {
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
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "kafka"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
        namespace = "mimir"

        labels = {
          "app.kubernetes.io/component"  = "kafka"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name      = "kafka-config"
          empty_dir = {}
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "kafka"
          image = "apache/kafka-native:4.1.0"

          port {
            name           = "kafka"
            container_port = 9092
            protocol       = "TCP"
          }

          port {
            name           = "controller"
            container_port = 9093
            protocol       = "TCP"
          }

          env {
            name = "_POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "KAFKA_CLUSTER_ID"
          }

          env {
            name = "KAFKA_NODE_ID"

            value_from {
              field_ref {
                field_path = "metadata.labels['apps.kubernetes.io/pod-index']"
              }
            }
          }

          env {
            name  = "KAFKA_PROCESS_ROLES"
            value = "broker,controller"
          }

          env {
            name  = "KAFKA_LISTENERS"
            value = "PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093"
          }

          env {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://$(_POD_NAME).release-name-mimir-kafka-headless.mimir.svc.cluster.local.:9092"
          }

          env {
            name  = "KAFKA_CONTROLLER_QUORUM_VOTERS"
            value = "0@release-name-mimir-kafka-0.release-name-mimir-kafka-headless.mimir.svc.cluster.local:9093"
          }

          env {
            name  = "KAFKA_CONTROLLER_LISTENER_NAMES"
            value = "CONTROLLER"
          }

          env {
            name  = "KAFKA_INTER_BROKER_LISTENER_NAME"
            value = "PLAINTEXT"
          }

          env {
            name  = "KAFKA_LOG_DIRS"
            value = "/var/lib/kafka/data"
          }

          env {
            name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR"
            value = "1"
          }

          env {
            name  = "KAFKA_LOG_RETENTION_HOURS"
            value = "24"
          }

          resources {
            requests = {
              cpu    = "1"
              memory = "1Gi"
            }
          }

          volume_mount {
            name       = "kafka-data"
            mount_path = "/var/lib/kafka"
          }

          volume_mount {
            name       = "kafka-config"
            mount_path = "/opt/kafka/config"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          readiness_probe {
            tcp_socket {
              port = "kafka"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
            period_seconds        = 5
            failure_threshold     = 3
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 1001
          run_as_group    = 1001
          run_as_non_root = true
          fs_group        = 1001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "kafka-data"
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

    service_name = "release-name-mimir-kafka-headless"
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_metadata_cache" {
  metadata {
    name      = "release-name-mimir-metadata-cache"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "memcached"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "metadata-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
      }
    }

    template {
      metadata {
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
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 512", "--extended=modern", "-I 1m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "614Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "614Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        container {
          name  = "exporter"
          image = "prom/memcached-exporter:v0.15.3"
          args  = ["--memcached.address=localhost:11211", "--web.listen-address=0.0.0.0:9150"]

          port {
            name           = "http-metrics"
            container_port = 9150
          }

          resources {
            limits = {
              memory = "250Mi"
            }

            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-mimir"

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

    service_name          = "release-name-mimir-metadata-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_store_gateway_zone_a" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-a"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "store-gateway"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "30m"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "store-gateway-zone-a"
      rollout-group                                  = "store-gateway"
      zone                                           = "zone-a"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "store-gateway/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "store-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "store-gateway"
        zone                          = "zone-a"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "store-gateway"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=store-gateway", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-store-gateway.sharding-ring.instance-availability-zone=zone-a", "-server.grpc-max-send-msg-size-bytes=209715200"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "5"
          }

          env {
            name  = "GOMEMLIMIT"
            value = "536870912"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 120
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "store-gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-store-gateway-headless"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_store_gateway_zone_b" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-b"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "store-gateway"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "30m"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "store-gateway-zone-b"
      rollout-group                                  = "store-gateway"
      zone                                           = "zone-b"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "store-gateway/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-store-gateway-zone-a"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "store-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "store-gateway"
        zone                          = "zone-b"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "store-gateway"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=store-gateway", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-store-gateway.sharding-ring.instance-availability-zone=zone-b", "-server.grpc-max-send-msg-size-bytes=209715200"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "5"
          }

          env {
            name  = "GOMEMLIMIT"
            value = "536870912"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 120
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "store-gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-store-gateway-headless"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_mimir_store_gateway_zone_c" {
  metadata {
    name      = "release-name-mimir-store-gateway-zone-c"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"                  = "store-gateway"
      "app.kubernetes.io/instance"                   = "release-name"
      "app.kubernetes.io/managed-by"                 = "Helm"
      "app.kubernetes.io/name"                       = "mimir"
      "app.kubernetes.io/part-of"                    = "memberlist"
      "app.kubernetes.io/version"                    = "3.0.0"
      "grafana.com/min-time-between-zones-downscale" = "30m"
      "grafana.com/prepare-downscale"                = "true"
      "helm.sh/chart"                                = "mimir-distributed-6.0.3"
      name                                           = "store-gateway-zone-c"
      rollout-group                                  = "store-gateway"
      zone                                           = "zone-c"
    }

    annotations = {
      "grafana.com/prepare-downscale-http-path" = "store-gateway/prepare-shutdown"
      "grafana.com/prepare-downscale-http-port" = "8080"
      "grafana.com/rollout-downscale-leader"    = "release-name-mimir-store-gateway-zone-b"
      rollout-max-unavailable                   = "50"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "store-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "mimir"
        rollout-group                 = "store-gateway"
        zone                          = "zone-c"
      }
    }

    template {
      metadata {
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

        annotations = {
          "checksum/config" = "c8855ce0ce6d5c308f09aa9313c8cdbf20258b94d2157b9242ac1badf765b358"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-mimir-config"

            items {
              key  = "mimir.yaml"
              path = "mimir.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "release-name-mimir-runtime"
          }
        }

        volume {
          name      = "active-queries"
          empty_dir = {}
        }

        container {
          name  = "store-gateway"
          image = "grafana/mimir:3.0.0"
          args  = ["-target=store-gateway", "-config.expand-env=true", "-config.file=/etc/mimir/mimir.yaml", "-store-gateway.sharding-ring.instance-availability-zone=zone-c", "-server.grpc-max-send-msg-size-bytes=209715200"]

          port {
            name           = "http-metrics"
            container_port = 8080
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          env {
            name  = "GOMAXPROCS"
            value = "5"
          }

          env {
            name  = "GOMEMLIMIT"
            value = "536870912"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mimir"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/var/mimir"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/data"
          }

          volume_mount {
            name       = "active-queries"
            mount_path = "/active-query-tracker"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 60
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 120
        service_account_name             = "release-name-mimir"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/component" = "store-gateway"
              "app.kubernetes.io/instance"  = "release-name"
              "app.kubernetes.io/name"      = "mimir"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    service_name          = "release-name-mimir-store-gateway-headless"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_job" "release_name_mimir_make_minio_buckets_5_4_0" {
  metadata {
    name      = "release-name-mimir-make-minio-buckets-5.4.0"
    namespace = "mimir"

    labels = {
      app      = "mimir-distributed-make-bucket-job"
      chart    = "mimir-distributed-6.0.3"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  spec {
    template {
      metadata {
        labels = {
          app     = "mimir-distributed-job"
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
          image   = "quay.io/minio/mc:RELEASE.2024-11-21T17-21-54Z"
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

resource "kubernetes_job" "release_name_minio_post_job" {
  metadata {
    name = "release-name-minio-post-job"

    labels = {
      app      = "minio-post-job"
      chart    = "minio-5.4.0"
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
          name      = "etc-path"
          empty_dir = {}
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

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
          name    = "minio-make-bucket"
          image   = "quay.io/minio/mc:RELEASE.2024-11-21T17-21-54Z"
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
            name       = "etc-path"
            mount_path = "/etc/minio/mc"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "minio-configuration"
            mount_path = "/config"
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name    = "minio-make-user"
          image   = "quay.io/minio/mc:RELEASE.2024-11-21T17-21-54Z"
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
            name       = "etc-path"
            mount_path = "/etc/minio/mc"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "minio-configuration"
            mount_path = "/config"
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy       = "OnFailure"
        service_account_name = "minio-sa"
      }
    }
  }
}

resource "kubernetes_job" "release_name_mimir_smoke_test" {
  metadata {
    name      = "release-name-mimir-smoke-test"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "smoke-test"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }

    annotations = {
      "helm.sh/hook" = "test"
    }
  }

  spec {
    parallelism   = 1
    completions   = 1
    backoff_limit = 5

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component"  = "smoke-test"
          "app.kubernetes.io/instance"   = "release-name"
          "app.kubernetes.io/managed-by" = "Helm"
          "app.kubernetes.io/name"       = "mimir"
          "app.kubernetes.io/version"    = "3.0.0"
          "helm.sh/chart"                = "mimir-distributed-6.0.3"
        }
      }

      spec {
        container {
          name              = "smoke-test"
          image             = "grafana/mimir:3.0.0"
          args              = ["-target=continuous-test", "-activity-tracker.filepath=", "-tests.smoke-test", "-tests.write-endpoint=http://release-name-mimir-gateway.mimir.svc:80", "-tests.read-endpoint=http://release-name-mimir-gateway.mimir.svc:80/prometheus", "-tests.tenant-id=", "-tests.write-read-series-test.num-series=1000", "-tests.write-read-series-test.max-query-age=48h", "-server.http-listen-port=8080"]
          image_pull_policy = "IfNotPresent"
        }

        restart_policy       = "OnFailure"
        service_account_name = "release-name-mimir"

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
  }
}

