resource "kubernetes_network_policy" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/component"  = "networking"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "alloy"
      }
    }

    policy_types = ["Ingress", "Egress"]
  }
}

resource "kubernetes_pod_disruption_budget" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "alloy"
      }
    }

    max_unavailable = "50%"
  }
}

resource "kubernetes_service_account" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/component"  = "rbac"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_secret" "grafana_cloud" {
  metadata {
    name = "grafana-cloud"
  }

  data = {
    PROMETHEUS_HOST     = "https://prometheus-us-central1.grafana.net/api/prom/push"
    PROMETHEUS_USERNAME = "123456"
  }
}

resource "kubernetes_config_map" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/component"  = "config"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  data = {
    "config.alloy" = "logging {\n\tlevel  = \"info\"\n\tformat = \"logfmt\"\n}\n\ndiscovery.kubernetes \"pods\" {\n\trole = \"pod\"\n}\n\ndiscovery.kubernetes \"nodes\" {\n\trole = \"node\"\n}\n\ndiscovery.kubernetes \"services\" {\n\trole = \"service\"\n}\n\ndiscovery.kubernetes \"endpoints\" {\n\trole = \"endpoints\"\n}\n\ndiscovery.kubernetes \"endpointslices\" {\n\trole = \"endpointslice\"\n}\n\ndiscovery.kubernetes \"ingresses\" {\n\trole = \"ingress\"\n}"
  }
}

resource "kubernetes_cluster_role" "release_name_alloy" {
  metadata {
    name = "release-name-alloy"

    labels = {
      "app.kubernetes.io/component"  = "rbac"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["", "discovery.k8s.io", "networking.k8s.io"]
    resources  = ["endpoints", "endpointslices", "ingresses", "pods", "services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods", "pods/log", "namespaces"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["monitoring.grafana.com"]
    resources  = ["podlogs"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["monitoring.coreos.com"]
    resources  = ["prometheusrules"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["monitoring.coreos.com"]
    resources  = ["podmonitors", "servicemonitors", "probes", "scrapeconfigs"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "secrets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apps", "extensions"]
    resources  = ["replicasets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_alloy" {
  metadata {
    name = "release-name-alloy"

    labels = {
      "app.kubernetes.io/component"  = "rbac"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-alloy"
    namespace = "alloy"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-alloy"
  }
}

resource "kubernetes_service" "release_name_alloy_cluster" {
  metadata {
    name      = "release-name-alloy-cluster"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/component"  = "networking"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 12345
      target_port = "12345"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "alloy"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/component"  = "networking"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 12345
      target_port = "12345"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "alloy"
    }

    type                    = "ClusterIP"
    internal_traffic_policy = "Cluster"
  }
}

resource "kubernetes_deployment" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "alloy"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "alloy"
        }

        annotations = {
          "kubectl.kubernetes.io/default-container" = "alloy"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-alloy"
          }
        }

        container {
          name  = "alloy"
          image = "docker.io/grafana/alloy:v1.11.3"
          args  = ["run", "/etc/alloy/config.alloy", "--storage.path=/tmp/alloy", "--server.http.listen-addr=0.0.0.0:12345", "--server.http.ui-path-prefix=/", "--cluster.enabled=true", "--cluster.join-addresses=release-name-alloy-cluster", "--stability.level=generally-available"]

          port {
            name           = "http-metrics"
            container_port = 12345
          }

          env {
            name  = "ALLOY_DEPLOY_MODE"
            value = "helm"
          }

          env {
            name = "HOSTNAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }

            requests = {
              cpu    = "10m"
              memory = "50Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/alloy"
          }

          readiness_probe {
            http_get {
              path   = "/-/ready"
              port   = "12345"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "config-reloader"
          image = "quay.io/prometheus-operator/prometheus-config-reloader:v0.81.0"
          args  = ["--watched-dir=/etc/alloy", "--reload-url=http://localhost:12345/-/reload"]

          resources {
            requests = {
              cpu    = "10m"
              memory = "50Mi"
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/alloy"
          }
        }

        dns_policy           = "ClusterFirst"
        service_account_name = "release-name-alloy"
      }
    }

    min_ready_seconds = 10
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_alloy" {
  metadata {
    name      = "release-name-alloy"
    namespace = "alloy"

    labels = {
      "app.kubernetes.io/component"  = "availability"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "alloy"
      "app.kubernetes.io/part-of"    = "alloy"
      "app.kubernetes.io/version"    = "v1.11.3"
      "helm.sh/chart"                = "alloy-1.4.0"
    }
  }

  spec {
    scale_target_ref {
      kind        = "deployment"
      name        = "release-name-alloy"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 5

    metric {
      type = "Resource"

      resource {
        name = "memory"

        target {
          type                = "Utilization"
          average_utilization = 80
        }
      }
    }

    behavior {
      scale_down {
        stabilization_window_seconds = 300
      }
    }
  }
}

