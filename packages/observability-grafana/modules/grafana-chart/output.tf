resource "kubernetes_pod_disruption_budget" "release_name_grafana" {
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

  spec {
    min_available = "1"

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "grafana"
      }
    }

    max_unavailable = "50%"
  }
}

resource "kubernetes_service_account" "release_name_grafana" {
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

resource "kubernetes_secret" "release_name_grafana_config_secret" {
  metadata {
    name      = "release-name-grafana-config-secret"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  data = {
    "contactpoints.yaml" = "apiVersion: 1\ncontactPoints:\n- name: cp_1\n  orgId: 1\n  receivers:\n  - settings:\n      class: ping failure\n      component: Grafana\n      group: app-stack\n      integrationKey: XXX\n      severity: critical\n      summary: |\n        {{ include \"default.message\" . }}\n    type: pagerduty\n    uid: first_uid\n"
  }
}

resource "kubernetes_config_map" "release_name_grafana" {
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

  data = {
    "dashboardproviders.yaml" = "apiVersion: 1\nproviders:\n- disableDeletion: false\n  editable: true\n  folder: \"\"\n  name: default\n  options:\n    path: /var/lib/grafana/dashboards/default\n  orgId: 1\n  type: file\n"
    "datasources.yaml"        = "apiVersion: 1\ndatasources:\n- access: proxy\n  isDefault: true\n  name: Prometheus\n  type: prometheus\n  url: http://prometheus-prometheus-server\n"
    "download_dashboards.sh"  = "#!/usr/bin/env sh\nset -euf\nmkdir -p /var/lib/grafana/dashboards/default\n"
    "grafana.ini"             = "[analytics]\ncheck_for_updates = true\n[grafana_net]\nurl = https://grafana.net\n[log]\nmode = console\n[paths]\ndata = /var/lib/grafana/\nlogs = /var/log/grafana\nplugins = /var/lib/grafana/plugins\nprovisioning = /etc/grafana/provisioning\n[server]\ndomain = ''\n"
    "mutetimes.yaml"          = "apiVersion: 1\nmuteTimes:\n- name: mti_1\n  orgId: 1\n  time_intervals: {}\n"
    "notifiers.yaml"          = "delete_notifiers: null\nnotifiers:\n- is_default: true\n  name: email-notifier\n  org_id: 1\n  org_name: Main Org.\n  settings:\n    addresses: an_email_address@example.com\n  type: email\n  uid: email1\n"
    "policies.yaml"           = "apiVersion: 1\npolicies:\n- orgId: 1\n  receiver: first_uid\n"
    "rules.yaml"              = "apiVersion: 1\ngroups:\n- folder: my_first_folder\n  interval: 60s\n  name: 'grafana_my_rule_group'\n  orgId: 1\n  rules:\n  - annotations:\n      some_key: some_value\n    condition: A\n    dashboardUid: my_dashboard\n    data:\n    - datasourceUid: \"-100\"\n      model:\n        conditions:\n        - evaluator:\n            params:\n            - 3\n            type: gt\n          operator:\n            type: and\n          query:\n            params:\n            - A\n          reducer:\n            type: last\n          type: query\n        datasource:\n          type: __expr__\n          uid: \"-100\"\n        expression: 1==0\n        intervalMs: 1000\n        maxDataPoints: 43200\n        refId: A\n        type: math\n      refId: A\n    for: 60s\n    labels:\n      team: sre_team_1\n    noDataState: Alerting\n    panelId: 123\n    title: my_first_rule\n    uid: my_id_1\n"
    "templates.yaml"          = "apiVersion: 1\ntemplates:\n- name: my_first_template\n  orgId: 1\n  template: |\n    \n    {{ define \"my_first_template\" }}\n    Custom notification message\n    {{ end }}\n    \n"
  }
}

resource "kubernetes_config_map" "release_name_grafana_dashboards_default" {
  metadata {
    name      = "release-name-grafana-dashboards-default"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      dashboard-provider           = "default"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  data = {
    "some-dashboard.json" = "{}"
  }
}

resource "kubernetes_persistent_volume_claim" "release_name_grafana" {
  metadata {
    name      = "release-name-grafana"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }

    finalizers = ["kubernetes.io/pvc-protection"]
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

resource "kubernetes_service" "release_name_grafana" {
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

  spec {
    port {
      name        = "service"
      protocol    = "TCP"
      port        = 80
      target_port = "grafana"
    }

    selector = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "release_name_grafana" {
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

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "grafana"
          "app.kubernetes.io/version"  = "12.2.1"
          "helm.sh/chart"              = "grafana-10.1.4"
        }

        annotations = {
          "checksum/config"                         = "c5eaae11aac698b0a43a4362bbdc79a8df073893c0274037f872b75568f9fe07"
          "checksum/dashboards-json-config"         = "aea989c253e9bc7a5b90bf31698731ac344483fcaac0fd7a396dcacbd3a43347"
          "checksum/sc-dashboard-provider-config"   = "e70bf6a851099d385178a76de9757bb0bef8299da6d8443602590e44f05fdf24"
          "kubectl.kubernetes.io/default-container" = "grafana"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-grafana"
          }
        }

        volume {
          name = "config-secret"

          secret {
            secret_name = "release-name-grafana-config-secret"
          }
        }

        volume {
          name = "dashboards-default"

          config_map {
            name = "release-name-grafana-dashboards-default"
          }
        }

        volume {
          name = "storage"

          persistent_volume_claim {
            claim_name = "release-name-grafana"
          }
        }

        volume {
          name = "secret-files"

          secret {
            secret_name = "grafana-secret-files"
          }
        }

        init_container {
          name    = "init-chown-data"
          image   = "docker.io/library/busybox:1.31.1"
          command = ["chown", "-R", "472:472", "/var/lib/grafana"]

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/grafana"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["CHOWN"]
              drop = ["ALL"]
            }

            run_as_user = 0

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        init_container {
          name    = "download-dashboards"
          image   = "docker.io/curlimages/curl:8.9.1"
          command = ["/bin/sh"]
          args    = ["-c", "mkdir -p /var/lib/grafana/dashboards/default && /bin/sh -x /etc/grafana/download_dashboards.sh"]

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/download_dashboards.sh"
            sub_path   = "download_dashboards.sh"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "secret-files"
            read_only  = true
            mount_path = "/etc/secrets"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "grafana"
          image = "docker.io/grafana/grafana:12.2.1"

          port {
            name           = "grafana"
            container_port = 3000
            protocol       = "TCP"
          }

          port {
            name           = "gossip-tcp"
            container_port = 9094
            protocol       = "TCP"
          }

          port {
            name           = "gossip-udp"
            container_port = 9094
            protocol       = "UDP"
          }

          port {
            name           = "profiling"
            container_port = 6060
            protocol       = "TCP"
          }

          env {
            name = "POD_IP"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "GF_SECURITY_ADMIN_USER"

            value_from {
              secret_key_ref {
                name = "grafana-admin-secret"
                key  = "admin-user"
              }
            }
          }

          env {
            name = "GF_SECURITY_ADMIN_PASSWORD"

            value_from {
              secret_key_ref {
                name = "grafana-admin-secret"
                key  = "admin-password"
              }
            }
          }

          env {
            name  = "GF_PATHS_DATA"
            value = "/var/lib/grafana/"
          }

          env {
            name  = "GF_PATHS_LOGS"
            value = "/var/log/grafana"
          }

          env {
            name  = "GF_PATHS_PLUGINS"
            value = "/var/lib/grafana/plugins"
          }

          env {
            name  = "GF_PATHS_PROVISIONING"
            value = "/etc/grafana/provisioning"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/grafana.ini"
            sub_path   = "grafana.ini"
          }

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "dashboards-default"
            mount_path = "/var/lib/grafana/dashboards/default/some-dashboard.json"
            sub_path   = "some-dashboard.json"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/datasources/datasources.yaml"
            sub_path   = "datasources.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/notifiers/notifiers.yaml"
            sub_path   = "notifiers.yaml"
          }

          volume_mount {
            name       = "config-secret"
            mount_path = "/etc/grafana/provisioning/alerting/contactpoints.yaml"
            sub_path   = "contactpoints.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/mutetimes.yaml"
            sub_path   = "mutetimes.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/policies.yaml"
            sub_path   = "policies.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/rules.yaml"
            sub_path   = "rules.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/alerting/templates.yaml"
            sub_path   = "templates.yaml"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/dashboards/dashboardproviders.yaml"
            sub_path   = "dashboardproviders.yaml"
          }

          volume_mount {
            name       = "secret-files"
            read_only  = true
            mount_path = "/etc/secrets"
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = "3000"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 30
            failure_threshold     = 10
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = "3000"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        service_account_name            = "release-name-grafana"
        automount_service_account_token = true

        security_context {
          run_as_user     = 472
          run_as_group    = 472
          run_as_non_root = true
          fs_group        = 472
        }

        enable_service_links = true
      }
    }

    strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_grafana" {
  metadata {
    name      = "release-name-grafana"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-grafana"
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 5

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

resource "kubernetes_service_account" "release_name_grafana_test" {
  metadata {
    name      = "release-name-grafana-test"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }

    annotations = {
      "helm.sh/hook"               = "test"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }
}

resource "kubernetes_config_map" "release_name_grafana_test" {
  metadata {
    name      = "release-name-grafana-test"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }

    annotations = {
      "helm.sh/hook"               = "test"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  data = {
    "run.sh" = "@test \"Test Health\" {\n  url=\"http://release-name-grafana/api/health\"\n\n  code=$(wget --server-response --spider --timeout 90 --tries 10 $${url} 2>&1 | awk '/^  HTTP/{print $2}')\n  [ \"$code\" == \"200\" ]\n}"
  }
}

resource "kubernetes_pod" "release_name_grafana_test" {
  metadata {
    name      = "release-name-grafana-test"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }

    annotations = {
      "helm.sh/hook"               = "test"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  spec {
    volume {
      name = "tests"

      config_map {
        name = "release-name-grafana-test"
      }
    }

    container {
      name    = "release-name-test"
      image   = "docker.io/bats/bats:v1.4.1"
      command = ["/opt/bats/bin/bats", "-t", "/tests/run.sh"]

      volume_mount {
        name       = "tests"
        read_only  = true
        mount_path = "/tests"
      }

      image_pull_policy = "IfNotPresent"
    }

    restart_policy       = "Never"
    service_account_name = "release-name-grafana-test"
  }
}

