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

resource "kubernetes_service_account" "release_name_rollout_operator" {
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
}

resource "kubernetes_service_account" "release_name_loki" {
  metadata {
    name      = "release-name-loki"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  automount_service_account_token = true
}

resource "kubernetes_secret" "loki_distributed_basic_auth" {
  metadata {
    name = "loki-distributed-basic-auth"
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "loki" {
  metadata {
    name      = "loki"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  data = {
    "config.yaml" = "\nauth_enabled: true\nbloom_build:\n  builder:\n    planner_address: loki-backend-headless.loki.svc.Sumicare:9095\n  enabled: true\nbloom_gateway:\n  client:\n    addresses: dnssrvnoa+_grpc._tcp.loki-backend-headless.loki.svc.Sumicare\n  enabled: true\nchunk_store_config:\n  chunk_cache_config:\n    background:\n      writeback_buffer: 500000\n      writeback_goroutines: 1\n      writeback_size_limit: 500MB\n    default_validity: 0s\n    memcached:\n      batch_size: 4\n      parallelism: 5\n    memcached_client:\n      addresses: dnssrvnoa+_memcached-client._tcp.release-name-loki-chunks-cache.loki.svc.Sumicare\n      consistent_hash: true\n      max_idle_conns: 72\n      timeout: 2000ms\ncommon:\n  compactor_grpc_address: 'release-name-loki-compactor.loki.svc.Sumicare:9095'\n  path_prefix: /var/loki\n  replication_factor: 3\n  storage:\n    s3:\n      bucketnames: sumicare-loki-chunks\n      insecure: false\n      s3forcepathstyle: false\nfrontend:\n  scheduler_address: release-name-loki-query-scheduler.loki.svc.Sumicare:9095\n  tail_proxy_url: http://release-name-loki-querier.loki.svc.Sumicare:3100\nfrontend_worker:\n  scheduler_address: release-name-loki-query-scheduler.loki.svc.Sumicare:9095\nindex_gateway:\n  mode: simple\nlimits_config:\n  max_cache_freshness_per_query: 10m\n  query_timeout: 300s\n  reject_old_samples: true\n  reject_old_samples_max_age: 168h\n  split_queries_by_interval: 15m\n  volume_enabled: true\nmemberlist:\n  join_members:\n  - release-name-loki-memberlist.loki.svc.Sumicare\npattern_ingester:\n  enabled: false\nquery_range:\n  align_queries_with_step: true\n  cache_results: true\n  results_cache:\n    cache:\n      background:\n        writeback_buffer: 500000\n        writeback_goroutines: 1\n        writeback_size_limit: 500MB\n      default_validity: 12h\n      memcached_client:\n        addresses: dnssrvnoa+_memcached-client._tcp.release-name-loki-results-cache.loki.svc.Sumicare\n        consistent_hash: true\n        timeout: 500ms\n        update_interval: 1m\nruler:\n  storage:\n    s3:\n      bucketnames: sumicare-loki-ruler\n      insecure: false\n      s3forcepathstyle: false\n    type: s3\n  wal:\n    dir: /var/loki/ruler-wal\nruntime_config:\n  file: /etc/loki/runtime-config/runtime-config.yaml\nschema_config:\n  configs:\n  - from: \"2024-04-01\"\n    index:\n      period: 24h\n      prefix: index_\n    object_store: s3\n    schema: v13\n    store: tsdb\nserver:\n  grpc_listen_port: 9095\n  http_listen_port: 3100\n  http_server_read_timeout: 600s\n  http_server_write_timeout: 600s\nstorage_config:\n  bloom_shipper:\n    working_directory: /var/loki/data/bloomshipper\n  boltdb_shipper:\n    index_gateway_client:\n      server_address: dns+loki-backend-headless.loki.svc.Sumicare:9095\n  hedging:\n    at: 250ms\n    max_per_second: 20\n    up_to: 3\n  tsdb_shipper:\n    index_gateway_client:\n      server_address: dns+loki-backend-headless.loki.svc.Sumicare:9095\n  use_thanos_objstore: false\ntracing:\n  enabled: true\nui:\n  enabled: true\n"
  }
}

resource "kubernetes_config_map" "loki_alerting_rules" {
  metadata {
    name = "loki-alerting-rules"
  }

  data = {
    "loki-alerting-rules.yaml" = "groups:\n  - name: example\n    rules:\n    - alert: example\n      expr: |\n        sum(count_over_time({app=\"loki\"} |~ \"error\")) > 0\n      for: 3m\n      labels:\n        severity: warning\n        category: logs\n      annotations:\n        message: \"loki has encountered errors\""
  }
}

resource "kubernetes_config_map" "release_name_loki_gateway" {
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

  data = {
    "nginx.conf" = "worker_processes  5;  ## Default: 1\nerror_log  /dev/stderr;\npid        /tmp/nginx.pid;\nworker_rlimit_nofile 8192;\n\nevents {\n  worker_connections  4096;  ## Default: 1024\n}\n\nhttp {\n  client_body_temp_path /tmp/client_temp;\n  proxy_temp_path       /tmp/proxy_temp_path;\n  fastcgi_temp_path     /tmp/fastcgi_temp;\n  uwsgi_temp_path       /tmp/uwsgi_temp;\n  scgi_temp_path        /tmp/scgi_temp;\n\n  client_max_body_size  4M;\n\n  proxy_read_timeout    600; ## 10 minutes\n  proxy_send_timeout    600;\n  proxy_connect_timeout 600;\n\n  proxy_http_version    1.1;\n\n  default_type application/octet-stream;\n  log_format   main '$remote_addr - $remote_user [$time_local]  $status '\n        '\"$request\" $body_bytes_sent \"$http_referer\" '\n        '\"$http_user_agent\" \"$http_x_forwarded_for\"';\n  access_log   /dev/stderr  main;\n\n  sendfile     on;\n  tcp_nopush   on;\n  resolver kube-dns.kube-system.svc.Sumicare.;\n\n  # if the X-Query-Tags header is empty, set a noop= without a value as empty values are not logged\n  map $http_x_query_tags $query_tags {\n    \"\"        \"noop=\";            # When header is empty, set noop=\n    default   $http_x_query_tags; # Otherwise, preserve the original value\n  }\n\n  server {\n    listen             8080;\n    listen             [::]:8080;\n    auth_basic           \"Loki\";\n    auth_basic_user_file /etc/nginx/secrets/.htpasswd;\n\n    location = / {\n      \n      return 200 'OK';\n      auth_basic off;\n    }\n\n    ########################################################\n    # Configure backend targets\n    location ^~ /ui {\n      \n      proxy_pass       http://loki-read.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # Distributor\n    location = /api/prom/push {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /loki/api/v1/push {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /distributor/ring {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /otlp/v1/logs {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # Ingester\n    location = /flush {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n    location ^~ /ingester/ {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /ingester {\n      \n      internal;        # to suppress 301\n    }\n\n    # Ring\n    location = /ring {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # MemberListKV\n    location = /memberlist {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # Ruler\n    location = /ruler/ring {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /api/prom/rules {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location ^~ /api/prom/rules/ {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /loki/api/v1/rules {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location ^~ /loki/api/v1/rules/ {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /prometheus/api/v1/alerts {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /prometheus/api/v1/rules {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # Compactor\n    location = /compactor/ring {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /loki/api/v1/delete {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /loki/api/v1/cache/generation_numbers {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # IndexGateway\n    location = /indexgateway/ring {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # QueryScheduler\n    location = /scheduler/ring {\n      \n      proxy_pass       http://loki-backend.loki.svc.Sumicare:3100$request_uri;\n    }\n\n    # Config\n    location = /config {\n      \n      proxy_pass       http://loki-write.loki.svc.Sumicare:3100$request_uri;\n    }\n\n\n    # QueryFrontend, Querier\n    location = /api/prom/tail {\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n      \n      proxy_pass       http://loki-read.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /loki/api/v1/tail {\n      proxy_set_header Upgrade $http_upgrade;\n      proxy_set_header Connection \"upgrade\";\n      \n      proxy_pass       http://loki-read.loki.svc.Sumicare:3100$request_uri;\n    }\n    location ^~ /api/prom/ {\n      \n      proxy_pass       http://loki-read.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /api/prom {\n      \n      internal;        # to suppress 301\n    }\n    location ^~ /loki/api/v1/ {\n      # pass custom headers set by Grafana as X-Query-Tags which are logged as key/value pairs in metrics.go log messages\n      proxy_set_header X-Query-Tags \"$${query_tags},user=$${http_x_grafana_user},dashboard_id=$${http_x_dashboard_uid},dashboard_title=$${http_x_dashboard_title},panel_id=$${http_x_panel_id},panel_title=$${http_x_panel_title},source_rule_uid=$${http_x_rule_uid},rule_name=$${http_x_rule_name},rule_folder=$${http_x_rule_folder},rule_version=$${http_x_rule_version},rule_source=$${http_x_rule_source},rule_type=$${http_x_rule_type}\";\n      \n      proxy_pass       http://loki-read.loki.svc.Sumicare:3100$request_uri;\n    }\n    location = /loki/api/v1 {\n      \n      internal;        # to suppress 301\n    }\n  }\n}\n"
  }
}

resource "kubernetes_config_map" "loki_dashboards_1" {
  metadata {
    name      = "loki-dashboards-1"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      grafana_dashboard            = "1"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  data = {
    "loki-chunks.json"                = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"refresh\":\"10s\",\"rows\":[{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":1,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(loki_ingester_memory_chunks{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"series\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Series\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":2,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(loki_ingester_memory_chunks{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}) / sum(loki_ingester_memory_streams{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"chunks\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Chunks per series\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Active Series / Chunks\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":3,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_ingester_chunk_utilization_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) by (le)) * 1\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_ingester_chunk_utilization_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) by (le)) * 1\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"sum(rate(loki_ingester_chunk_utilization_sum{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) * 1 / sum(rate(loki_ingester_chunk_utilization_count{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Utilization\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"percentunit\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_ingester_chunk_age_seconds_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_ingester_chunk_age_seconds_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"sum(rate(loki_ingester_chunk_age_seconds_sum{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) * 1e3 / sum(rate(loki_ingester_chunk_age_seconds_count{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Age\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"ms\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Flush Stats\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":5,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_ingester_chunk_entries_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) by (le)) * 1\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_ingester_chunk_entries_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) by (le)) * 1\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"sum(rate(loki_ingester_chunk_entries_sum{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) * 1 / sum(rate(loki_ingester_chunk_entries_count{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Log Entries Per Chunk\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":6,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_chunk_store_index_entries_per_chunk_sum{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[5m])) / sum(rate(loki_chunk_store_index_entries_per_chunk_count{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[5m]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Index Entries\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Index Entries Per Chunk\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Flush Stats\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":7,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"loki_ingester_flush_queue_length{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"} or cortex_ingester_flush_queue_length{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Queue Length\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{\"1xx\":\"#EAB839\",\"2xx\":\"#7EB26D\",\"3xx\":\"#6ED0E0\",\"4xx\":\"#EF843C\",\"5xx\":\"#E24D42\",\"error\":\"#E24D42\",\"success\":\"#7EB26D\"},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":8,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status) (\\n  label_replace(label_replace(rate(loki_ingester_chunk_age_seconds_count{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval]),\\n  \\\"status\\\", \\\"$${1}xx\\\", \\\"status_code\\\", \\\"([0-9])..\\\"),\\n  \\\"status\\\", \\\"$${1}\\\", \\\"status_code\\\", \\\"([a-z]+)\\\"))\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{status}}\",\"refId\":\"A\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Flush Rate\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Flush Stats\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":9,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_ingester_chunks_flushed_total{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Chunks Flushed/Second\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":10,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (reason) (rate(loki_ingester_chunks_flushed_total{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) / ignoring(reason) group_left sum(rate(loki_ingester_chunks_flushed_total{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{reason}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Chunk Flush Reason\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":1,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":1,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Flush Stats\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"cards\":{\"cardPadding\":null,\"cardRound\":null},\"color\":{\"cardColor\":\"#b4ff00\",\"colorScale\":\"sqrt\",\"colorScheme\":\"interpolateSpectral\",\"exponent\":0.5,\"mode\":\"spectrum\"},\"dataFormat\":\"tsbuckets\",\"datasource\":\"$datasource\",\"heatmap\":{},\"hideZeroBuckets\":false,\"highlightCards\":true,\"id\":11,\"legend\":{\"show\":true},\"span\":12,\"targets\":[{\"expr\":\"sum by (le) (rate(loki_ingester_chunk_utilization_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval]))\",\"format\":\"heatmap\",\"intervalFactor\":2,\"legendFormat\":\"{{le}}\",\"refId\":\"A\"}],\"title\":\"Chunk Utilization\",\"tooltip\":{\"show\":true,\"showHistogram\":true},\"type\":\"heatmap\",\"xAxis\":{\"show\":true},\"xBucketNumber\":null,\"xBucketSize\":null,\"yAxis\":{\"decimals\":0,\"format\":\"percentunit\",\"show\":true,\"splitFactor\":null},\"yBucketBound\":\"auto\"}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Utilization\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"cards\":{\"cardPadding\":null,\"cardRound\":null},\"color\":{\"cardColor\":\"#b4ff00\",\"colorScale\":\"sqrt\",\"colorScheme\":\"interpolateSpectral\",\"exponent\":0.5,\"mode\":\"spectrum\"},\"dataFormat\":\"tsbuckets\",\"datasource\":\"$datasource\",\"heatmap\":{},\"hideZeroBuckets\":false,\"highlightCards\":true,\"id\":12,\"legend\":{\"show\":true},\"span\":12,\"targets\":[{\"expr\":\"sum(rate(loki_ingester_chunk_size_bytes_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[$__rate_interval])) by (le)\",\"format\":\"heatmap\",\"intervalFactor\":2,\"legendFormat\":\"{{le}}\",\"refId\":\"A\"}],\"title\":\"Chunk Size Bytes\",\"tooltip\":{\"show\":true,\"showHistogram\":true},\"type\":\"heatmap\",\"xAxis\":{\"show\":true},\"xBucketNumber\":null,\"xBucketSize\":null,\"yAxis\":{\"decimals\":0,\"format\":\"bytes\",\"show\":true,\"splitFactor\":null},\"yBucketBound\":\"auto\"}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Utilization\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":13,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":12,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_ingester_chunk_size_bytes_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[1m])) by (le))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"p99\",\"legendLink\":null,\"step\":10},{\"expr\":\"histogram_quantile(0.90, sum(rate(loki_ingester_chunk_size_bytes_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[1m])) by (le))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"p90\",\"legendLink\":null,\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_ingester_chunk_size_bytes_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[1m])) by (le))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"p50\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Chunk Size Quantiles\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Utilization\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":14,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":12,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.5, sum(rate(loki_ingester_chunk_bounds_hours_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[5m])) by (le))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"p50\",\"legendLink\":null,\"step\":10},{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_ingester_chunk_bounds_hours_bucket{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[5m])) by (le))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"p99\",\"legendLink\":null,\"step\":10},{\"expr\":\"sum(rate(loki_ingester_chunk_bounds_hours_sum{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[5m])) / sum(rate(loki_ingester_chunk_bounds_hours_count{cluster=\\\"$cluster\\\", job=~\\\"$namespace/(loki|enterprise-logs)-write\\\"}[5m]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"avg\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Chunk Duration hours (end-start)\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Duration\",\"titleSize\":\"h6\"}],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Chunks\",\"uid\":\"chunks\",\"version\":0}\n"
    "loki-deletion.json"              = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"refresh\":\"10s\",\"rows\":[{\"collapse\":false,\"height\":\"100px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"format\":\"none\",\"id\":1,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(loki_compactor_pending_delete_requests_count{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"})\",\"format\":\"time_series\",\"instant\":true,\"intervalFactor\":2,\"refId\":\"A\"}],\"thresholds\":\"70,80\",\"timeFrom\":null,\"timeShift\":null,\"title\":\"Number of Pending Requests\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"singlestat\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"format\":\"dtdurations\",\"id\":2,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"max(loki_compactor_oldest_pending_delete_request_age_seconds{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"})\",\"format\":\"time_series\",\"instant\":true,\"intervalFactor\":2,\"refId\":\"A\"}],\"thresholds\":\"70,80\",\"timeFrom\":null,\"timeShift\":null,\"title\":\"Oldest Pending Request Age\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"singlestat\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":false,\"title\":\"Headlines\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":3,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(increase(loki_compactor_delete_requests_received_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[1d]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"received\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Delete Requests Received / Day\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(increase(loki_compactor_delete_requests_processed_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[1d]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"processed\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Delete Requests Processed / Day\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Churn\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":5,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":12,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(increase(loki_compactor_load_pending_requests_attempts_total{status=\\\"fail\\\", cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[1h]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"failures\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Failures in Loading Delete Requests / Hour\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Failures\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":6,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":12,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_compactor_deleted_lines{cluster=~\\\"$cluster\\\",job=~\\\"$namespace/(loki|enterprise-logs)-read\\\"}[$__rate_interval])) by (user)\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{user}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Lines Deleted / Sec\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Deleted lines\",\"titleSize\":\"h6\"}],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Deletion\",\"uid\":\"deletion\",\"version\":0}\n"
    "loki-logs.json"                  = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"id\":8,\"iteration\":1583185057230,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":0,\"y\":0},\"hiddenSeries\":false,\"id\":35,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(go_goroutines{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\"})\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"goroutines\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":3,\"y\":0},\"hiddenSeries\":false,\"id\":41,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(go_gc_duration_seconds{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\"}) by (quantile)\",\"legendFormat\":\"{{quantile}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"gc duration\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":6,\"y\":0},\"hiddenSeries\":false,\"id\":36,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(container_cpu_usage_seconds_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\", container=~\\\"$container\\\"}[5m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"cpu\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":9,\"y\":0},\"hiddenSeries\":false,\"id\":40,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(container_memory_working_set_bytes{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\", container=~\\\"$container\\\"})\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"working set\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":12,\"y\":0},\"hiddenSeries\":false,\"id\":38,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(container_network_transmit_bytes_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\"}[5m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"tx\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":15,\"y\":0},\"hiddenSeries\":false,\"id\":39,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(container_network_receive_bytes_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\"}[5m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"rx\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"decbytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":18,\"y\":0},\"hiddenSeries\":false,\"id\":37,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"increase(kube_pod_container_status_last_terminated_reason{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\", container=~\\\"$container\\\"}[30m]) \> 0\",\"legendFormat\":\"{{reason}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"restarts\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":3,\"x\":21,\"y\":0},\"hiddenSeries\":false,\"id\":42,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(promtail_custom_bad_words_total{cluster=\\\"$cluster\\\", exported_namespace=\\\"$namespace\\\", exported_pod=~\\\"$deployment.*\\\", exported_pod=~\\\"$pod\\\", container=~\\\"$container\\\"}[5m])) by (level)\",\"legendFormat\":\"{{level}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"bad words\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$logs\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":24,\"x\":0,\"y\":4},\"hiddenSeries\":false,\"id\":31,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"warn\",\"color\":\"#FF780A\"},{\"alias\":\"error\",\"color\":\"#E02F44\"},{\"alias\":\"info\",\"color\":\"#56A64B\"},{\"alias\":\"debug\",\"color\":\"#3274D9\"}],\"spaceLength\":10,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate({cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\", container=~\\\"$container\\\" } |logfmt| level=~\\\"$level\\\" |= \\\"$filter\\\" [5m])) by (level)\",\"intervalFactor\":3,\"legendFormat\":\"{{level}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Log Rate\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"timeseries\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":false,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"datasource\":\"$logs\",\"gridPos\":{\"h\":19,\"w\":24,\"x\":0,\"y\":6},\"id\":29,\"maxDataPoints\":\"\",\"options\":{\"showLabels\":false,\"showTime\":true,\"sortOrder\":\"Descending\",\"wrapLogMessage\":true},\"targets\":[{\"expr\":\"{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\", pod=~\\\"$pod\\\", container=~\\\"$container\\\"} | logfmt | level=~\\\"$level\\\" |= \\\"$filter\\\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Logs\",\"type\":\"logs\"}],\"refresh\":\"10s\",\"rows\":[],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"hide\":0,\"label\":null,\"name\":\"logs\",\"options\":[],\"query\":\"loki\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":null,\"multi\":false,\"name\":\"deployment\",\"options\":[],\"query\":\"label_values(kube_deployment_created{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}, deployment)\",\"refresh\":0,\"regex\":\"\",\"sort\":1,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":null,\"multi\":false,\"name\":\"pod\",\"options\":[],\"query\":\"label_values(kube_pod_container_info{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$deployment.*\\\"}, pod)\",\"refresh\":0,\"regex\":\"\",\"sort\":1,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":null,\"multi\":false,\"name\":\"container\",\"options\":[],\"query\":\"label_values(kube_pod_container_info{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"$pod\\\", pod=~\\\"$deployment.*\\\"}, container)\",\"refresh\":0,\"regex\":\"\",\"sort\":1,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"selected\":true,\"text\":\"\",\"value\":\"\"},\"hide\":0,\"includeAll\":false,\"label\":\"\",\"multi\":true,\"name\":\"level\",\"options\":[{\"selected\":false,\"text\":\"debug\",\"value\":\"debug\"},{\"selected\":false,\"text\":\"info\",\"value\":\"info\"},{\"selected\":false,\"text\":\"warn\",\"value\":\"warn\"},{\"selected\":false,\"text\":\"error\",\"value\":\"error\"}],\"query\":\"debug,info,warn,error\",\"refresh\":0,\"type\":\"custom\"},{\"current\":{\"selected\":false,\"text\":\"\",\"value\":\"\"},\"label\":\"LogQL Filter\",\"name\":\"filter\",\"query\":\"\",\"type\":\"textbox\"}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Logs\",\"uid\":\"logs\",\"version\":0}\n"
    "loki-mixin-recording-rules.json" = "{\"annotations\":{\"list\":[{\"builtIn\":1,\"datasource\":\"-- Grafana --\",\"enable\":true,\"hide\":true,\"iconColor\":\"rgba(0, 211, 255, 1)\",\"name\":\"Annotations \& Alerts\",\"target\":{\"limit\":100,\"matchAny\":false,\"tags\":[],\"type\":\"dashboard\"},\"type\":\"dashboard\"},{\"datasource\":\"$${datasource}\",\"enable\":false,\"expr\":\"sum by (tenant) (changes(loki_ruler_wal_prometheus_tsdb_wal_truncations_total{tenant=~\\\"$${tenant}\\\"}[$__rate_interval]))\",\"iconColor\":\"red\",\"name\":\"WAL Truncations\",\"target\":{\"queryType\":\"Azure Monitor\",\"refId\":\"Anno\"},\"titleFormat\":\"{{tenant}}\"}]},\"editable\":true,\"fiscalYearStartMonth\":0,\"gnetId\":null,\"graphTooltip\":0,\"iteration\":1635347545534,\"links\":[],\"liveNow\":false,\"panels\":[{\"datasource\":\"$${datasource}\",\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"thresholds\"},\"mappings\":[],\"noValue\":\"0\",\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":1}]}},\"overrides\":[]},\"gridPos\":{\"h\":10,\"w\":2,\"x\":0,\"y\":0},\"id\":2,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"8.3.0-38205pre\",\"targets\":[{\"datasource\":\"$${datasource}\",\"exemplar\":false,\"expr\":\"sum(loki_ruler_wal_appender_ready) by (pod, tenant) == 0\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"title\":\"Appenders Not Ready\",\"type\":\"stat\"},{\"datasource\":\"$${datasource}\",\"description\":\"\",\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"palette-classic\"},\"custom\":{\"axisLabel\":\"\",\"axisPlacement\":\"auto\",\"barAlignment\":0,\"drawStyle\":\"line\",\"fillOpacity\":0,\"gradientMode\":\"none\",\"hideFrom\":{\"legend\":false,\"tooltip\":false,\"viz\":false},\"lineInterpolation\":\"linear\",\"lineWidth\":1,\"pointSize\":5,\"scaleDistribution\":{\"type\":\"linear\"},\"showPoints\":\"auto\",\"spanNulls\":false,\"stacking\":{\"group\":\"A\",\"mode\":\"none\"},\"thresholdsStyle\":{\"mode\":\"off\"}},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":10,\"w\":11,\"x\":2,\"y\":0},\"id\":4,\"options\":{\"legend\":{\"calcs\":[],\"displayMode\":\"list\",\"placement\":\"bottom\"},\"tooltip\":{\"mode\":\"single\"}},\"targets\":[{\"datasource\":\"$${datasource}\",\"exemplar\":true,\"expr\":\"sum(rate(loki_ruler_wal_samples_appended_total{tenant=~\\\"$${tenant}\\\"}[$__rate_interval])) by (tenant) \> 0\",\"interval\":\"\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"title\":\"Samples Appended to WAL per Second\",\"type\":\"timeseries\"},{\"datasource\":\"$${datasource}\",\"description\":\"Series are unique combinations of labels\",\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"palette-classic\"},\"custom\":{\"axisLabel\":\"\",\"axisPlacement\":\"auto\",\"barAlignment\":0,\"drawStyle\":\"line\",\"fillOpacity\":0,\"gradientMode\":\"none\",\"hideFrom\":{\"legend\":false,\"tooltip\":false,\"viz\":false},\"lineInterpolation\":\"linear\",\"lineWidth\":1,\"pointSize\":5,\"scaleDistribution\":{\"type\":\"linear\"},\"showPoints\":\"auto\",\"spanNulls\":false,\"stacking\":{\"group\":\"A\",\"mode\":\"none\"},\"thresholdsStyle\":{\"mode\":\"off\"}},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":10,\"w\":11,\"x\":13,\"y\":0},\"id\":5,\"options\":{\"legend\":{\"calcs\":[],\"displayMode\":\"list\",\"placement\":\"bottom\"},\"tooltip\":{\"mode\":\"single\"}},\"targets\":[{\"datasource\":\"$${datasource}\",\"exemplar\":true,\"expr\":\"sum(rate(loki_ruler_wal_storage_created_series_total{tenant=~\\\"$${tenant}\\\"}[$__rate_interval])) by (tenant) \> 0\",\"interval\":\"\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"title\":\"Series Created per Second\",\"type\":\"timeseries\"},{\"datasource\":\"$${datasource}\",\"description\":\"Difference between highest timestamp appended to WAL and highest timestamp successfully written to remote storage\",\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"palette-classic\"},\"custom\":{\"axisLabel\":\"\",\"axisPlacement\":\"auto\",\"barAlignment\":0,\"drawStyle\":\"line\",\"fillOpacity\":0,\"gradientMode\":\"none\",\"hideFrom\":{\"legend\":false,\"tooltip\":false,\"viz\":false},\"lineInterpolation\":\"linear\",\"lineWidth\":1,\"pointSize\":5,\"scaleDistribution\":{\"type\":\"linear\"},\"showPoints\":\"auto\",\"spanNulls\":false,\"stacking\":{\"group\":\"A\",\"mode\":\"none\"},\"thresholdsStyle\":{\"mode\":\"off\"}},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":10,\"w\":12,\"x\":0,\"y\":10},\"id\":6,\"options\":{\"legend\":{\"calcs\":[],\"displayMode\":\"list\",\"placement\":\"bottom\"},\"tooltip\":{\"mode\":\"single\"}},\"targets\":[{\"datasource\":\"$${datasource}\",\"exemplar\":true,\"expr\":\"loki_ruler_wal_prometheus_remote_storage_highest_timestamp_in_seconds{tenant=~\\\"$${tenant}\\\"}\\n- on (tenant)\\n  (\\n    loki_ruler_wal_prometheus_remote_storage_queue_highest_sent_timestamp_seconds{tenant=~\\\"$${tenant}\\\"}\\n    or vector(0)\\n  )\",\"interval\":\"\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"title\":\"Write Behind\",\"type\":\"timeseries\"},{\"datasource\":\"$${datasource}\",\"description\":\"\",\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"palette-classic\"},\"custom\":{\"axisLabel\":\"\",\"axisPlacement\":\"auto\",\"barAlignment\":0,\"drawStyle\":\"line\",\"fillOpacity\":0,\"gradientMode\":\"none\",\"hideFrom\":{\"legend\":false,\"tooltip\":false,\"viz\":false},\"lineInterpolation\":\"linear\",\"lineWidth\":1,\"pointSize\":5,\"scaleDistribution\":{\"type\":\"linear\"},\"showPoints\":\"auto\",\"spanNulls\":false,\"stacking\":{\"group\":\"A\",\"mode\":\"none\"},\"thresholdsStyle\":{\"mode\":\"off\"}},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":10,\"w\":12,\"x\":12,\"y\":10},\"id\":7,\"options\":{\"legend\":{\"calcs\":[],\"displayMode\":\"list\",\"placement\":\"bottom\"},\"tooltip\":{\"mode\":\"single\"}},\"targets\":[{\"datasource\":\"$${datasource}\",\"exemplar\":true,\"expr\":\"sum(rate(loki_ruler_wal_prometheus_remote_storage_samples_total{tenant=~\\\"$${tenant}\\\"}[$__rate_interval])) by (tenant) \> 0\",\"interval\":\"\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"title\":\"Samples Sent per Second\",\"type\":\"timeseries\"},{\"datasource\":\"$${datasource}\",\"description\":\"\\n\",\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"palette-classic\"},\"custom\":{\"axisLabel\":\"\",\"axisPlacement\":\"auto\",\"barAlignment\":0,\"drawStyle\":\"line\",\"fillOpacity\":0,\"gradientMode\":\"none\",\"hideFrom\":{\"legend\":false,\"tooltip\":false,\"viz\":false},\"lineInterpolation\":\"linear\",\"lineWidth\":1,\"pointSize\":5,\"scaleDistribution\":{\"type\":\"linear\"},\"showPoints\":\"auto\",\"spanNulls\":false,\"stacking\":{\"group\":\"A\",\"mode\":\"none\"},\"thresholdsStyle\":{\"mode\":\"off\"}},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"bytes\"},\"overrides\":[]},\"gridPos\":{\"h\":10,\"w\":12,\"x\":0,\"y\":20},\"id\":8,\"options\":{\"legend\":{\"calcs\":[],\"displayMode\":\"list\",\"placement\":\"bottom\"},\"tooltip\":{\"mode\":\"single\"}},\"targets\":[{\"datasource\":\"$${datasource}\",\"exemplar\":true,\"expr\":\"sum by (tenant) (loki_ruler_wal_disk_size{tenant=~\\\"$${tenant}\\\"})\",\"interval\":\"\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"title\":\"WAL Disk Size\",\"type\":\"timeseries\"},{\"datasource\":\"$${datasource}\",\"description\":\"Some number of pending samples is expected, but if remote-write is failing this value will remain high\",\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"palette-classic\"},\"custom\":{\"axisLabel\":\"\",\"axisPlacement\":\"auto\",\"barAlignment\":0,\"drawStyle\":\"line\",\"fillOpacity\":0,\"gradientMode\":\"none\",\"hideFrom\":{\"legend\":false,\"tooltip\":false,\"viz\":false},\"lineInterpolation\":\"linear\",\"lineWidth\":1,\"pointSize\":5,\"scaleDistribution\":{\"type\":\"linear\"},\"showPoints\":\"auto\",\"spanNulls\":false,\"stacking\":{\"group\":\"A\",\"mode\":\"none\"},\"thresholdsStyle\":{\"mode\":\"off\"}},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":10,\"w\":12,\"x\":12,\"y\":20},\"id\":9,\"options\":{\"legend\":{\"calcs\":[],\"displayMode\":\"list\",\"placement\":\"bottom\"},\"tooltip\":{\"mode\":\"single\"}},\"targets\":[{\"datasource\":\"$${datasource}\",\"exemplar\":true,\"expr\":\"max(loki_ruler_wal_prometheus_remote_storage_samples_pending{tenant=~\\\"$${tenant}\\\"}) by (tenant,pod) \> 0\",\"interval\":\"\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"title\":\"Pending Samples\",\"type\":\"timeseries\"}],\"schemaVersion\":31,\"style\":\"dark\",\"tags\":[],\"templating\":{\"list\":[{\"description\":null,\"error\":null,\"hide\":0,\"includeAll\":false,\"label\":\"Datasource\",\"multi\":false,\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"queryValue\":\"\",\"refresh\":1,\"regex\":\"\",\"skipUrlSync\":false,\"type\":\"datasource\"},{\"allValue\":null,\"datasource\":\"$${datasource}\",\"definition\":\"label_values(loki_ruler_wal_samples_appended_total, tenant)\",\"description\":null,\"error\":null,\"hide\":0,\"includeAll\":true,\"label\":\"Tenant\",\"multi\":true,\"name\":\"tenant\",\"options\":[],\"query\":{\"query\":\"label_values(loki_ruler_wal_samples_appended_total, tenant)\",\"refId\":\"StandardVariableQuery\"},\"refresh\":2,\"regex\":\"\",\"skipUrlSync\":false,\"sort\":0,\"type\":\"query\"}]},\"time\":{\"from\":\"now-6h\",\"to\":\"now\"},\"timepicker\":{},\"timezone\":\"\",\"title\":\"Recording Rules\",\"uid\":\"2xKA_ZK7k\",\"version\":9,\"weekStart\":\"\"}\n"
    "loki-operational.json"           = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"id\":68,\"iteration\":1588704280892,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"panels\":[{\"collapsed\":false,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":0},\"id\":17,\"panels\":[],\"targets\":[],\"title\":\"Main\",\"type\":\"row\"},{\"aliasColors\":{\"5xx\":\"red\"},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":4,\"x\":0,\"y\":1},\"hiddenSeries\":false,\"id\":6,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status) (\\nlabel_replace(\\n  label_replace(\\n        rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"api_prom_query|api_prom_label|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_label|loki_api_v1_label_name_values\\\"}[5m]),\\n  \\\"status\\\", \\\"$${1}xx\\\", \\\"status_code\\\", \\\"([0-9])..\\\"),\\n\\\"status\\\", \\\"$${1}\\\", \\\"status_code\\\", \\\"([a-z]+)\\\")\\n)\",\"legendFormat\":\"{{status}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Queries/Second\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":10,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{\"5xx\":\"red\"},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":4,\"x\":4,\"y\":1},\"hiddenSeries\":false,\"id\":7,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status) (\\nlabel_replace(\\n  label_replace(\\n          rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"api_prom_push|loki_api_v1_push\\\"}[5m]),\\n   \\\"status\\\", \\\"$${1}xx\\\", \\\"status_code\\\", \\\"([0-9])..\\\"),\\n\\\"status\\\", \\\"$${1}\\\", \\\"status_code\\\", \\\"([a-z]+)\\\"))\",\"legendFormat\":\"{{status}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Pushes/Second\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":10,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":4,\"x\":12,\"y\":1},\"hiddenSeries\":false,\"id\":2,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"topk(10, sum(rate(loki_distributor_lines_received_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (tenant))\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Lines Per Tenant (top 10)\",\"tooltip\":{\"shared\":false,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":4,\"x\":16,\"y\":1},\"hiddenSeries\":false,\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"hideEmpty\":true,\"hideZero\":true,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"topk(10, sum(rate(loki_distributor_bytes_received_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (tenant)) / 1024 / 1024\",\"legendFormat\":\"{{tenant}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"MBs Per Tenant (Top 10)\",\"tooltip\":{\"shared\":false,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":4,\"x\":20,\"y\":1},\"hiddenSeries\":false,\"id\":24,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"increase(kube_pod_container_status_restarts_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[10m]) \> 0\",\"hide\":false,\"interval\":\"\",\"legendFormat\":\"{{container}}-{{pod}}\",\"refId\":\"B\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Container Restarts\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":10,\"w\":12,\"x\":0,\"y\":6},\"hiddenSeries\":false,\"id\":9,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"api_prom_push|loki_api_v1_push\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".99\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(0.75, sum by (le) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"api_prom_push|loki_api_v1_push\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".9\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(0.5, sum by (le) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"api_prom_push|loki_api_v1_push\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".5\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Push Latency\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":12,\"y\":6},\"hiddenSeries\":false,\"id\":12,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le) (job:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".99\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(0.9, sum by (le) (job:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".9\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(0.5, sum by (le) (job:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".5\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Distributor Latency\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":0,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":18,\"y\":6},\"hiddenSeries\":false,\"id\":71,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", status_code!~\\\"5[0-9]{2}\\\"}[5m])) by (route)\\n/\\nsum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[5m])) by (route)\",\"interval\":\"\",\"legendFormat\":\"{{route}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Distributor Success Rate\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"decimals\":null,\"format\":\"percentunit\",\"label\":\"\",\"logBase\":1,\"max\":\"1\",\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":12,\"y\":11},\"hiddenSeries\":false,\"id\":13,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=\\\"/logproto.Pusher/Push\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".99\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(0.9, sum by (le) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=\\\"/logproto.Pusher/Push\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"hide\":false,\"legendFormat\":\".9\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(0.5, sum by (le) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=\\\"/logproto.Pusher/Push\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"hide\":false,\"legendFormat\":\".5\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Ingester Latency Write\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":0,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":18,\"y\":11},\"hiddenSeries\":false,\"id\":72,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", status_code!~\\\"5[0-9]{2}\\\", route=\\\"/logproto.Pusher/Push\\\"}[5m])) by (route)\\n/\\nsum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=\\\"/logproto.Pusher/Push\\\"}[5m])) by (route)\",\"interval\":\"\",\"legendFormat\":\"{{route}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Ingester Success Rate Write\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"decimals\":null,\"format\":\"percentunit\",\"label\":\"\",\"logBase\":1,\"max\":\"1\",\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":10,\"w\":12,\"x\":0,\"y\":16},\"hiddenSeries\":false,\"id\":10,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"hideEmpty\":true,\"hideZero\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"api_prom_query|api_prom_labels|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_label|loki_api_v1_label_name_values\\\", cluster=\\\"$cluster\\\"}))\",\"legendFormat\":\"{{route}}-.99\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(0.9, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"api_prom_query|api_prom_labels|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_label|loki_api_v1_label_name_values\\\", cluster=\\\"$cluster\\\"}))\",\"legendFormat\":\"{{route}}-.9\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(0.5, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"api_prom_query|api_prom_labels|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_label|loki_api_v1_label_name_values\\\", cluster=\\\"$cluster\\\"}))\",\"legendFormat\":\"{{route}}-.5\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Query Latency\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":12,\"y\":16},\"hiddenSeries\":false,\"id\":14,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"api_prom_query|api_prom_labels|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_label|loki_api_v1_label_name_values\\\", cluster=\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".99-{{route}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(0.9, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"api_prom_query|api_prom_labels|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_label|loki_api_v1_label_name_values\\\", cluster=\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".9-{{route}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(0.5, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"api_prom_query|api_prom_labels|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_label|loki_api_v1_label_name_values\\\", cluster=\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".5-{{route}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Querier Latency\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":0,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":18,\"y\":16},\"hiddenSeries\":false,\"id\":73,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", status_code!~\\\"5[0-9]{2}\\\"}[5m])) by (route)\\n/\\nsum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\"}[5m])) by (route)\",\"interval\":\"\",\"legendFormat\":\"{{route}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Querier Success Rate\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"decimals\":null,\"format\":\"percentunit\",\"label\":\"\",\"logBase\":1,\"max\":\"1\",\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"description\":\"\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":12,\"y\":21},\"hiddenSeries\":false,\"id\":15,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"/logproto.Querier/Query|/logproto.Querier/Label|/logproto.Querier/Series|/logproto.Querier/QuerySample|/logproto.Querier/GetChunkIDs\\\", cluster=\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".99-{{route}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(0.9, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"/logproto.Querier/Query|/logproto.Querier/Label|/logproto.Querier/Series|/logproto.Querier/QuerySample|/logproto.Querier/GetChunkIDs\\\", cluster=\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".9-{{route}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(0.5, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"/logproto.Querier/Query|/logproto.Querier/Label|/logproto.Querier/Series|/logproto.Querier/QuerySample|/logproto.Querier/GetChunkIDs\\\", cluster=\\\"$cluster\\\"})) * 1e3\",\"legendFormat\":\".5-{{route}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Ingester Latency Read\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":0,\"fillGradient\":0,\"gridPos\":{\"h\":5,\"w\":6,\"x\":18,\"y\":21},\"hiddenSeries\":false,\"id\":74,\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", status_code!~\\\"5[0-9]{2}\\\", route=~\\\"/logproto.Querier/Query|/logproto.Querier/Label|/logproto.Querier/Series|/logproto.Querier/QuerySample|/logproto.Querier/GetChunkIDs\\\"}[5m])) by (route)\\n/\\nsum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"/logproto.Querier/Query|/logproto.Querier/Label|/logproto.Querier/Series|/logproto.Querier/QuerySample|/logproto.Querier/GetChunkIDs\\\"}[5m])) by (route)\",\"interval\":\"\",\"legendFormat\":\"{{route}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Ingester Success Rate Read\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"decimals\":null,\"format\":\"percentunit\",\"label\":\"\",\"logBase\":1,\"max\":\"1\",\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":26},\"id\":110,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":0,\"y\":27},\"hiddenSeries\":false,\"id\":112,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"topk(10,sum by (tenant, reason) (rate(loki_discarded_samples_total{cluster=\\\"$cluster\\\",namespace=\\\"$namespace\\\"}[1m])))\",\"interval\":\"\",\"legendFormat\":\"{{ tenant }} - {{ reason }}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Discarded Lines\",\"tooltip\":{\"shared\":false,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"columns\":[],\"datasource\":\"$datasource\",\"fontSize\":\"100%\",\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":27},\"id\":113,\"pageSize\":null,\"panels\":[],\"showHeader\":true,\"sort\":{\"col\":3,\"desc\":true},\"styles\":[{\"alias\":\"Time\",\"align\":\"auto\",\"dateFormat\":\"YYYY-MM-DD HH:mm:ss\",\"pattern\":\"Time\",\"type\":\"hidden\"},{\"alias\":\"\",\"align\":\"auto\",\"colorMode\":null,\"colors\":[\"rgba(245, 54, 54, 0.9)\",\"rgba(237, 129, 40, 0.89)\",\"rgba(50, 172, 45, 0.97)\"],\"dateFormat\":\"YYYY-MM-DD HH:mm:ss\",\"decimals\":2,\"mappingType\":1,\"pattern\":\"tenant\",\"thresholds\":[],\"type\":\"string\",\"unit\":\"short\"},{\"alias\":\"\",\"align\":\"auto\",\"colorMode\":null,\"colors\":[\"rgba(245, 54, 54, 0.9)\",\"rgba(237, 129, 40, 0.89)\",\"rgba(50, 172, 45, 0.97)\"],\"dateFormat\":\"YYYY-MM-DD HH:mm:ss\",\"decimals\":2,\"mappingType\":1,\"pattern\":\"reason\",\"thresholds\":[],\"type\":\"number\",\"unit\":\"short\"},{\"alias\":\"\",\"align\":\"right\",\"colorMode\":null,\"colors\":[\"rgba(245, 54, 54, 0.9)\",\"rgba(237, 129, 40, 0.89)\",\"rgba(50, 172, 45, 0.97)\"],\"decimals\":2,\"pattern\":\"/.*/\",\"thresholds\":[],\"type\":\"number\",\"unit\":\"short\"}],\"targets\":[{\"expr\":\"topk(10, sum by (tenant, reason) (sum_over_time(increase(loki_discarded_samples_total{cluster=\\\"$cluster\\\",namespace=\\\"$namespace\\\"}[1m])[$__range:1m])))\",\"format\":\"table\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"{{ tenant }} - {{ reason }}\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Discarded Lines Per Interval\",\"transform\":\"table\",\"type\":\"table-old\"}],\"targets\":[],\"title\":\"Limits\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":27},\"id\":23,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":28},\"hiddenSeries\":false,\"id\":26,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":false,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":true,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"}\",\"intervalFactor\":3,\"legendFormat\":\"{{pod}}-{{container}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"CPU Usage\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":6,\"y\":28},\"hiddenSeries\":false,\"id\":27,\"legend\":{\"avg\":false,\"current\":false,\"hideEmpty\":false,\"hideZero\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":false,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":true,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"go_memstats_heap_inuse_bytes{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"}\",\"instant\":false,\"intervalFactor\":3,\"legendFormat\":\"{{pod}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Memory Usage\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":true,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$logs\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":4,\"w\":12,\"x\":12,\"y\":28},\"hiddenSeries\":false,\"id\":31,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":false,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"{}\",\"color\":\"#C4162A\"}],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate({cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"} | logfmt | level=\\\"error\\\"[1m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Error Log Rate\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":false,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"datasource\":\"$logs\",\"gridPos\":{\"h\":18,\"w\":12,\"x\":12,\"y\":32},\"id\":29,\"options\":{\"showLabels\":false,\"showTime\":false,\"sortOrder\":\"Descending\",\"wrapLogMessage\":true},\"panels\":[],\"targets\":[{\"expr\":\"{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"} | logfmt | level=\\\"error\\\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Logs\",\"type\":\"logs\"},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":0,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":35},\"hiddenSeries\":false,\"id\":33,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", status_code!~\\\"5[0-9]{2}\\\"}[5m])) by (route)\\n/\\nsum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[5m])) by (route)\",\"interval\":\"\",\"intervalFactor\":1,\"legendFormat\":\"{{route}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Success Rate\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":6,\"y\":35},\"hiddenSeries\":false,\"id\":32,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_distributor_ingester_append_failures_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (ingester)\",\"intervalFactor\":1,\"legendFormat\":\"{{ingester}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Append Failures By Ingester\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":42},\"hiddenSeries\":false,\"id\":34,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_distributor_bytes_received_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (pod)\",\"intervalFactor\":1,\"legendFormat\":\"{{pod}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Bytes Received/Second\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":6,\"y\":42},\"hiddenSeries\":false,\"id\":35,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_distributor_lines_received_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (pod)\",\"intervalFactor\":1,\"legendFormat\":\"{{pod}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Lines Received/Second\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Write Path\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":29},\"id\":104,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":0,\"y\":30},\"hiddenSeries\":false,\"id\":106,\"legend\":{\"avg\":false,\"current\":false,\"hideEmpty\":true,\"hideZero\":true,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"topk(10,sum by (tenant) (loki_ingester_memory_streams{cluster=\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}))\",\"interval\":\"\",\"legendFormat\":\"{{ tenant }}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Active Streams\",\"tooltip\":{\"shared\":false,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":30},\"hiddenSeries\":false,\"id\":108,\"legend\":{\"avg\":false,\"current\":false,\"hideEmpty\":true,\"hideZero\":true,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"topk(10, sum by (tenant) (rate(loki_ingester_streams_created_total{cluster=\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[1m]) \> 0))\",\"interval\":\"\",\"legendFormat\":\"{{ tenant }}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Streams Created/Sec\",\"tooltip\":{\"shared\":false,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Streams\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":30},\"id\":94,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":0,\"y\":31},\"hiddenSeries\":false,\"id\":102,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"De-Dupe Ratio\",\"yaxis\":2}],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_ingester_chunks_flushed_total{cluster=\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[1m]))\",\"interval\":\"\",\"legendFormat\":\"Chunks\",\"refId\":\"A\"},{\"expr\":\"sum(increase(loki_chunk_store_deduped_chunks_total{cluster=\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[1m]))/sum(increase(loki_ingester_chunks_flushed_total{cluster=\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[1m])) \< 1\",\"interval\":\"\",\"legendFormat\":\"De-Dupe Ratio\",\"refId\":\"B\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Chunks Flushed/Sec\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"cards\":{\"cardPadding\":null,\"cardRound\":null},\"color\":{\"cardColor\":\"#b4ff00\",\"colorScale\":\"sqrt\",\"colorScheme\":\"interpolateSpectral\",\"exponent\":0.5,\"mode\":\"spectrum\"},\"dataFormat\":\"tsbuckets\",\"datasource\":\"$datasource\",\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":31},\"heatmap\":{},\"hideZeroBuckets\":false,\"highlightCards\":true,\"id\":100,\"legend\":{\"show\":true},\"panels\":[],\"reverseYBuckets\":false,\"targets\":[{\"expr\":\"sum(rate(loki_ingester_chunk_size_bytes_bucket{cluster=\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[1m])) by (le)\",\"format\":\"heatmap\",\"instant\":false,\"interval\":\"\",\"legendFormat\":\"{{ le }}\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Chunk Size Bytes\",\"tooltip\":{\"show\":true,\"showHistogram\":false},\"type\":\"heatmap\",\"xAxis\":{\"show\":true},\"xBucketNumber\":null,\"xBucketSize\":null,\"yAxis\":{\"decimals\":0,\"format\":\"bytes\",\"logBase\":1,\"max\":null,\"min\":null,\"show\":true,\"splitFactor\":null},\"yBucketBound\":\"auto\",\"yBucketNumber\":null,\"yBucketSize\":null},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":7,\"fillGradient\":0,\"gridPos\":{\"h\":9,\"w\":12,\"x\":0,\"y\":39},\"hiddenSeries\":false,\"id\":96,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(reason) (rate(loki_ingester_chunks_flushed_total{cluster=~\\\"$cluster\\\",job=~\\\"$namespace/ingester\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) / ignoring(reason) group_left sum(rate(loki_ingester_chunks_flushed_total{cluster=~\\\"$cluster\\\",job=~\\\"$namespace/ingester\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval]))\",\"interval\":\"\",\"legendFormat\":\"{{ reason }}\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Chunk Flush Reason %\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"percentunit\",\"label\":null,\"logBase\":1,\"max\":\"1\",\"min\":\"0\",\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"cards\":{\"cardPadding\":null,\"cardRound\":null},\"color\":{\"cardColor\":\"#b4ff00\",\"colorScale\":\"sqrt\",\"colorScheme\":\"interpolateSpectral\",\"exponent\":0.5,\"max\":null,\"min\":null,\"mode\":\"spectrum\"},\"dataFormat\":\"tsbuckets\",\"datasource\":\"$datasource\",\"gridPos\":{\"h\":9,\"w\":12,\"x\":12,\"y\":39},\"heatmap\":{},\"hideZeroBuckets\":true,\"highlightCards\":true,\"id\":98,\"legend\":{\"show\":true},\"panels\":[],\"reverseYBuckets\":false,\"targets\":[{\"expr\":\"sum by (le) (rate(loki_ingester_chunk_utilization_bucket{cluster=\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"}[1m]))\",\"format\":\"heatmap\",\"instant\":false,\"interval\":\"\",\"legendFormat\":\"{{ le }}\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Chunk Utilization\",\"tooltip\":{\"show\":true,\"showHistogram\":false},\"type\":\"heatmap\",\"xAxis\":{\"show\":true},\"xBucketNumber\":null,\"xBucketSize\":null,\"yAxis\":{\"decimals\":0,\"format\":\"percentunit\",\"logBase\":1,\"max\":null,\"min\":null,\"show\":true,\"splitFactor\":null},\"yBucketBound\":\"auto\",\"yBucketNumber\":null,\"yBucketSize\":null}],\"targets\":[],\"title\":\"Chunks\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":31},\"id\":64,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":32},\"hiddenSeries\":false,\"id\":68,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":false,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":true,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"}\",\"intervalFactor\":3,\"legendFormat\":\"{{pod}}-{{container}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"CPU Usage\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":39},\"hiddenSeries\":false,\"id\":69,\"legend\":{\"avg\":false,\"current\":false,\"hideEmpty\":false,\"hideZero\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":false,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":true,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"go_memstats_heap_inuse_bytes{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"}\",\"instant\":false,\"intervalFactor\":3,\"legendFormat\":\"{{pod}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Memory Usage\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":true,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$logs\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":3,\"w\":18,\"x\":12,\"y\":32},\"hiddenSeries\":false,\"id\":65,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":false,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"{}\",\"color\":\"#F2495C\"}],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate({cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\"} | logfmt |  level=\\\"error\\\"[1m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Error Log Rate\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":false,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"datasource\":\"$logs\",\"gridPos\":{\"h\":18,\"w\":18,\"x\":12,\"y\":35},\"id\":66,\"options\":{\"showLabels\":false,\"showTime\":false,\"sortOrder\":\"Descending\",\"wrapLogMessage\":true},\"panels\":[],\"targets\":[{\"expr\":\"{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\"} | logfmt | level=\\\"error\\\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Logs\",\"type\":\"logs\"},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":0,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":46},\"hiddenSeries\":false,\"id\":70,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", status_code!~\\\"5[0-9]{2}\\\"}[1m])) by (route)\\n/\\nsum(rate(loki_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\"}[1m])) by (route)\",\"interval\":\"\",\"intervalFactor\":1,\"legendFormat\":\"{{route}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Success Rate\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Read Path\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":32},\"id\":52,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":30},\"hiddenSeries\":false,\"id\":53,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_memcache_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (method, name, le, container))\",\"intervalFactor\":1,\"legendFormat\":\"{{container}}: .99-{{method}}-{{name}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_memcache_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (method, name, le, container))\",\"hide\":false,\"legendFormat\":\"{{container}}: .9-{{method}}-{{name}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_memcache_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (method, name, le, container))\",\"hide\":false,\"legendFormat\":\"{{container}}: .5-{{method}}-{{name}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Latency By Method\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":38},\"hiddenSeries\":false,\"id\":54,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_memcache_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (status_code, method, name, container)\",\"intervalFactor\":1,\"legendFormat\":\"{{container}}: {{status_code}}-{{method}}-{{name}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Status By Method\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Memcached\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":33},\"id\":57,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":31},\"hiddenSeries\":false,\"id\":55,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_consul_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".99-{{operation}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_consul_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".9-{{operation}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_consul_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".5-{{operation}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Latency By Operation\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":39},\"hiddenSeries\":false,\"id\":58,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_consul_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, status_code, method)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}-{{operation}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Status By Operation\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Consul\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":34},\"id\":43,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":9},\"hiddenSeries\":false,\"id\":41,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/MutateRows\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".9\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/MutateRows\\\"}[5m])) by (operation, le))\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/MutateRows\\\"}[5m])) by (operation, le))\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"MutateRows Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":6,\"y\":9},\"hiddenSeries\":false,\"id\":46,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/ReadRows\\\"}[5m])) by (operation, le))\",\"interval\":\"\",\"intervalFactor\":1,\"legendFormat\":\"99%\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/ReadRows\\\"}[5m])) by (operation, le))\",\"interval\":\"\",\"legendFormat\":\"90%\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/ReadRows\\\"}[5m])) by (operation, le))\",\"interval\":\"\",\"legendFormat\":\"50%\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"ReadRows Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":12,\"y\":9},\"hiddenSeries\":false,\"id\":44,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/GetTable\\\"}[5m])) by (operation, le))\",\"interval\":\"\",\"intervalFactor\":1,\"legendFormat\":\"99%\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/GetTable\\\"}[5m])) by (operation, le))\",\"interval\":\"\",\"legendFormat\":\"90%\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/GetTable\\\"}[5m])) by (operation, le))\",\"interval\":\"\",\"legendFormat\":\"50%\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"GetTable Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":18,\"y\":9},\"hiddenSeries\":false,\"id\":45,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/ListTables\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".9\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/ListTables\\\"}[5m])) by (operation, le))\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_bigtable_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/ListTables\\\"}[5m])) by (operation, le))\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"ListTables Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":0,\"y\":16},\"hiddenSeries\":false,\"id\":47,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_bigtable_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/MutateRows\\\"}[5m])) by (status_code)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"MutateRows Status\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":6,\"y\":16},\"hiddenSeries\":false,\"id\":50,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_bigtable_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.v2.Bigtable/ReadRows\\\"}[5m])) by (status_code)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"ReadRows Status\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":12,\"y\":16},\"hiddenSeries\":false,\"id\":48,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_bigtable_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/GetTable\\\"}[5m])) by (status_code)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"GetTable Status\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":6,\"x\":18,\"y\":16},\"hiddenSeries\":false,\"id\":49,\"interval\":\"\",\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":false,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_bigtable_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\", operation=\\\"/google.bigtable.admin.v2.BigtableTableAdmin/ListTables\\\"}[5m])) by (status_code)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"ListTables Status\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Big Table\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":35},\"id\":60,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":33},\"hiddenSeries\":false,\"id\":61,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_gcs_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".99-{{operation}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_gcs_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".9-{{operation}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_gcs_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".5-{{operation}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Latency By Operation\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":41},\"hiddenSeries\":false,\"id\":62,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_gcs_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (status_code, operation)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}-{{operation}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Status By Method\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"GCS\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":36},\"id\":76,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":6,\"w\":6,\"x\":0,\"y\":9},\"id\":82,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(cortex_dynamo_failures_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Failure Rate\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":6,\"w\":6,\"x\":6,\"y\":9},\"id\":83,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(cortex_dynamo_consumed_capacity_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Consumed Capacity Rate\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":6,\"w\":6,\"x\":12,\"y\":9},\"id\":84,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(cortex_dynamo_throttled_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Throttled Rate\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":6,\"w\":6,\"x\":18,\"y\":9},\"id\":85,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(cortex_dynamo_dropped_requests_total{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m]))\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Dropped Rate\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":6,\"w\":6,\"x\":0,\"y\":15},\"id\":86,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(cortex_dynamo_query_pages_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])))\",\"legendFormat\":\".99\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(cortex_dynamo_query_pages_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])))\",\"legendFormat\":\".9\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(cortex_dynamo_query_pages_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])))\",\"legendFormat\":\".5\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Query Pages\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":6,\"w\":9,\"x\":6,\"y\":15},\"id\":87,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(cortex_dynamo_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".99-{{operation}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(cortex_dynamo_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".9-{{operation}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(cortex_dynamo_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".5-{{operation}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Latency By Operation\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":6,\"w\":9,\"x\":15,\"y\":15},\"id\":88,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(cortex_dynamo_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (status_code, operation)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}-{{operation}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Status By Method\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Dynamo\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":37},\"id\":78,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":10},\"id\":79,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_s3_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".99-{{operation}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_s3_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".9-{{operation}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_s3_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".5-{{operation}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Latency By Operation\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":18},\"id\":80,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_s3_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (status_code, operation)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}-{{operation}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Status By Method\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"S3\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":37},\"id\":78,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":10},\"id\":79,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_azure_blob_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".99-{{operation}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_azure_blob_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".9-{{operation}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_azure_blob_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".5-{{operation}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Latency By Operation\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":18},\"id\":80,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_azure_blob_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (status_code, operation)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}-{{operation}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Status By Method\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"Azure Blob\",\"type\":\"row\"},{\"collapsed\":true,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":37},\"id\":114,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":10},\"id\":115,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(.99, sum(rate(loki_boltdb_shipper_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"intervalFactor\":1,\"legendFormat\":\".99-{{operation}}\",\"refId\":\"A\"},{\"expr\":\"histogram_quantile(.9, sum(rate(loki_boltdb_shipper_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".9-{{operation}}\",\"refId\":\"B\"},{\"expr\":\"histogram_quantile(.5, sum(rate(loki_boltdb_shipper_request_duration_seconds_bucket{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (operation, le))\",\"hide\":false,\"legendFormat\":\".5-{{operation}}\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Latency By Operation\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":24,\"x\":0,\"y\":18},\"id\":116,\"interval\":\"\",\"legend\":{\"alignAsTable\":true,\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"rightSide\":true,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"dataLinks\":[]},\"panels\":[],\"percentage\":false,\"pointradius\":1,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(rate(loki_boltdb_shipper_request_duration_seconds_count{cluster=\\\"$cluster\\\", namespace=\\\"$namespace\\\"}[5m])) by (status_code, operation)\",\"intervalFactor\":1,\"legendFormat\":\"{{status_code}}-{{operation}}\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Status By Method\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"targets\":[],\"title\":\"BoltDB Shipper\",\"type\":\"row\"}],\"refresh\":\"10s\",\"rows\":[],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"hide\":0,\"label\":null,\"name\":\"logs\",\"options\":[],\"query\":\"loki\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Operational\",\"uid\":\"operational\",\"version\":0}\n"
  }
}

resource "kubernetes_config_map" "loki_dashboards_2" {
  metadata {
    name      = "loki-dashboards-2"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      grafana_dashboard            = "1"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  data = {
    "loki-reads-resources.json"  = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"refresh\":\"10s\",\"rows\":[{\"collapse\":false,\"collapsed\":false,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":1,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (rate(container_cpu_usage_seconds_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_cpu_quota{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"} / container_spec_cpu_period{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"CPU\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":2,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"max by(pod) (container_memory_working_set_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_memory_limit_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"} \> 0)\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (workingset)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":3,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (go_memstats_heap_inuse_bytes{cluster=~\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (go heap inuse)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"gridPos\":{},\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(instance, pod, device) (rate(node_disk_written_bytes_total[$__rate_interval])) + ignoring(pod) group_right() (label_replace(count by(instance, pod, device) (container_fs_writes_bytes_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\", device!~\\\".*sda.*\\\"}), \\\"device\\\", \\\"$1\\\", \\\"device\\\", \\\"/dev/(.*)\\\") * 0)\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}} - {{device}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Disk Writes\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"Bps\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"gridPos\":{},\"id\":5,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(instance, pod, device) (rate(node_disk_read_bytes_total[$__rate_interval])) + ignoring(pod) group_right() (label_replace(count by(instance, pod, device) (container_fs_writes_bytes_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\", device!~\\\".*sda.*\\\"}), \\\"device\\\", \\\"$1\\\", \\\"device\\\", \\\"/dev/(.*)\\\") * 0)\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}} - {{device}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Disk Reads\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"Bps\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":6,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"max by(persistentvolumeclaim) (kubelet_volume_stats_used_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"} / kubelet_volume_stats_capacity_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}) and count by(persistentvolumeclaim) (kube_persistentvolumeclaim_labels{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\",label_name=~\\\"(loki|enterprise-logs)-read.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{persistentvolumeclaim}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Disk Space Utilization\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"percentunit\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":7,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"loki_boltdb_shipper_query_readiness_duration_seconds{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"duration\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Query Readiness Duration\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"s\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Read path\",\"titleSize\":\"h6\",\"type\":\"row\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":8,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (rate(container_cpu_usage_seconds_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_cpu_quota{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"} / container_spec_cpu_period{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"CPU\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":9,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"max by(pod) (container_memory_working_set_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_memory_limit_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"} \> 0)\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (workingset)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":10,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (go_memstats_heap_inuse_bytes{cluster=~\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (go heap inuse)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Ingester\",\"titleSize\":\"h6\"}],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Reads Resources\",\"uid\":\"reads-resources\",\"version\":0}\n"
    "loki-reads.json"            = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"refresh\":\"10s\",\"rows\":[{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{\"1xx\":\"#EAB839\",\"2xx\":\"#7EB26D\",\"3xx\":\"#6ED0E0\",\"4xx\":\"#EF843C\",\"5xx\":\"#E24D42\",\"error\":\"#E24D42\",\"success\":\"#7EB26D\"},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":1,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status) (\\n  label_replace(label_replace(rate(loki_request_duration_seconds_count{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"loki_api_v1_series|api_prom_series|api_prom_query|api_prom_label|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_labels|loki_api_v1_label_name_values\\\"}[$__rate_interval]),\\n  \\\"status\\\", \\\"$${1}xx\\\", \\\"status_code\\\", \\\"([0-9])..\\\"),\\n  \\\"status\\\", \\\"$${1}\\\", \\\"status_code\\\", \\\"([a-z]+)\\\"))\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{status}}\",\"refId\":\"A\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"QPS\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":2,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"loki_api_v1_series|api_prom_series|api_prom_query|api_prom_label|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_labels|loki_api_v1_label_name_values\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{ route }} 99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum by (le,route) (job_route:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"loki_api_v1_series|api_prom_series|api_prom_query|api_prom_label|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_labels|loki_api_v1_label_name_values\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{ route }} 50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"1e3 * sum(job_route:loki_request_duration_seconds_sum:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"loki_api_v1_series|api_prom_series|api_prom_query|api_prom_label|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_labels|loki_api_v1_label_name_values\\\", cluster=~\\\"$cluster\\\"}) by (route)  / sum(job_route:loki_request_duration_seconds_count:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", route=~\\\"loki_api_v1_series|api_prom_series|api_prom_query|api_prom_label|api_prom_label_name_values|loki_api_v1_query|loki_api_v1_query_range|loki_api_v1_labels|loki_api_v1_label_name_values\\\", cluster=~\\\"$cluster\\\"}) by (route) \",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{ route }} Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"ms\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Read Path\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{\"1xx\":\"#EAB839\",\"2xx\":\"#7EB26D\",\"3xx\":\"#6ED0E0\",\"4xx\":\"#EF843C\",\"5xx\":\"#E24D42\",\"error\":\"#E24D42\",\"success\":\"#7EB26D\"},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":3,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status) (\\n  label_replace(label_replace(rate(loki_boltdb_shipper_request_duration_seconds_count{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", operation=\\\"Shipper.Query\\\"}[$__rate_interval]),\\n  \\\"status\\\", \\\"$${1}xx\\\", \\\"status_code\\\", \\\"([0-9])..\\\"),\\n  \\\"status\\\", \\\"$${1}\\\", \\\"status_code\\\", \\\"([a-z]+)\\\"))\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{status}}\",\"refId\":\"A\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"QPS\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_boltdb_shipper_request_duration_seconds_bucket{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", operation=\\\"Shipper.Query\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_boltdb_shipper_request_duration_seconds_bucket{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", operation=\\\"Shipper.Query\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"sum(rate(loki_boltdb_shipper_request_duration_seconds_sum{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", operation=\\\"Shipper.Query\\\"}[$__rate_interval])) * 1e3 / sum(rate(loki_boltdb_shipper_request_duration_seconds_count{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\", operation=\\\"Shipper.Query\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"ms\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"BoltDB Shipper\",\"titleSize\":\"h6\"}],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Reads\",\"uid\":\"reads\",\"version\":0}\n"
    "loki-retention.json"        = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"refresh\":\"10s\",\"rows\":[{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":1,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (rate(container_cpu_usage_seconds_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_cpu_quota{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"} / container_spec_cpu_period{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"CPU\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":2,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"max by(pod) (container_memory_working_set_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_memory_limit_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-read.*\\\"} \> 0)\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (workingset)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":3,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (go_memstats_heap_inuse_bytes{cluster=~\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (go heap inuse)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Resource Usage\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fieldConfig\":{\"defaults\":{\"color\":{\"fixedColor\":\"blue\",\"mode\":\"fixed\"},\"custom\":{},\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null}]},\"unit\":\"dateTimeFromNow\"}},\"fill\":1,\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"text\":{},\"textMode\":\"auto\"},\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"loki_boltdb_shipper_compact_tables_operation_last_successful_run_timestamp_seconds{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"} * 1e3\",\"format\":\"time_series\",\"instant\":true,\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Last Compact and Mark Operation Success\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"stat\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":5,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"loki_boltdb_shipper_compact_tables_operation_duration_seconds{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"duration\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Compact and Mark Operations Duration\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"s\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":6,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status)(rate(loki_boltdb_shipper_compact_tables_operation_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{success}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Compact and Mark Operations Per Status\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Compact and Mark\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":7,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"count by(action)(loki_boltdb_shipper_retention_marker_table_processed_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{action}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Processed Tables Per Action\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":8,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"count by(table,action)(loki_boltdb_shipper_retention_marker_table_processed_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\" , action=~\\\"modified|deleted\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{table}}-{{action}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Modified Tables\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":9,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (table)(rate(loki_boltdb_shipper_retention_marker_count_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) \>0\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{table}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Marks Creation Rate Per Table\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Per Table Marker\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"format\":\"short\",\"id\":10,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum (increase(loki_boltdb_shipper_retention_marker_count_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[24h]))\",\"format\":\"time_series\",\"instant\":true,\"intervalFactor\":2,\"refId\":\"A\"}],\"thresholds\":\"70,80\",\"timeFrom\":null,\"timeShift\":null,\"title\":\"Marked Chunks (24h)\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"singlestat\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":11,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_boltdb_shipper_retention_marker_table_processed_duration_seconds_bucket{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_boltdb_shipper_retention_marker_table_processed_duration_seconds_bucket{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"sum(rate(loki_boltdb_shipper_retention_marker_table_processed_duration_seconds_sum{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) * 1e3 / sum(rate(loki_boltdb_shipper_retention_marker_table_processed_duration_seconds_count{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Mark Table Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"ms\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"format\":\"short\",\"id\":12,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum (increase(loki_boltdb_shipper_retention_sweeper_chunk_deleted_duration_seconds_count{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[24h]))\",\"format\":\"time_series\",\"instant\":true,\"intervalFactor\":2,\"refId\":\"A\"}],\"thresholds\":\"70,80\",\"timeFrom\":null,\"timeShift\":null,\"title\":\"Delete Chunks (24h)\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"singlestat\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":13,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_boltdb_shipper_retention_sweeper_chunk_deleted_duration_seconds_bucket{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_boltdb_shipper_retention_sweeper_chunk_deleted_duration_seconds_bucket{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"sum(rate(loki_boltdb_shipper_retention_sweeper_chunk_deleted_duration_seconds_sum{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval])) * 1e3 / sum(rate(loki_boltdb_shipper_retention_sweeper_chunk_deleted_duration_seconds_count{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Delete Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"ms\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Sweeper\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":14,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"time() - (loki_boltdb_shipper_retention_sweeper_marker_file_processing_current_time{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"} \> 0)\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"lag\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Sweeper Lag\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"s\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":15,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(loki_boltdb_shipper_retention_sweeper_marker_files_current{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"count\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Marks Files to Process\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":16,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":4,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status)(rate(loki_boltdb_shipper_retention_sweeper_chunk_deleted_duration_seconds_count{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{status}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Delete Rate Per Status\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"datasource\":\"$logs\",\"id\":17,\"span\":12,\"targets\":[{\"expr\":\"{cluster=~\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-read\\\"}\",\"refId\":\"A\"}],\"title\":\"Compactor Logs\",\"type\":\"logs\"}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Logs\",\"titleSize\":\"h6\"}],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"hide\":0,\"label\":null,\"name\":\"logs\",\"options\":[],\"query\":\"loki\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Retention\",\"uid\":\"retention\",\"version\":0}\n"
    "loki-writes-resources.json" = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"refresh\":\"10s\",\"rows\":[{\"collapse\":false,\"collapsed\":false,\"panels\":[{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":1,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (loki_ingester_memory_streams{cluster=~\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"In-memory streams\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":2,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (rate(container_cpu_usage_seconds_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_cpu_quota{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"} / container_spec_cpu_period{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"CPU\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":3,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[{\"alias\":\"limit\",\"color\":\"#E02F44\",\"fill\":0}],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"max by(pod) (container_memory_working_set_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10},{\"expr\":\"min(container_spec_memory_limit_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\"} \> 0)\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"limit\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (workingset)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(pod) (go_memstats_heap_inuse_bytes{cluster=~\\\"$cluster\\\", job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Memory (go heap inuse)\",\"tooltip\":{\"sort\":2},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"gridPos\":{},\"id\":5,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(instance, pod, device) (rate(node_disk_written_bytes_total[$__rate_interval])) + ignoring(pod) group_right() (label_replace(count by(instance, pod, device) (container_fs_writes_bytes_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\", device!~\\\".*sda.*\\\"}), \\\"device\\\", \\\"$1\\\", \\\"device\\\", \\\"/dev/(.*)\\\") * 0)\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}} - {{device}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Disk Writes\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"Bps\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"gridPos\":{},\"id\":6,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by(instance, pod, device) (rate(node_disk_read_bytes_total[$__rate_interval])) + ignoring(pod) group_right() (label_replace(count by(instance, pod, device) (container_fs_writes_bytes_total{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\", container=\\\"loki\\\", pod=~\\\"(loki|enterprise-logs)-write.*\\\", device!~\\\".*sda.*\\\"}), \\\"device\\\", \\\"$1\\\", \\\"device\\\", \\\"/dev/(.*)\\\") * 0)\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{pod}} - {{device}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Disk Reads\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"Bps\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"gridPos\":{},\"id\":7,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"max by(persistentvolumeclaim) (kubelet_volume_stats_used_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"} / kubelet_volume_stats_capacity_bytes{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\"}) and count by(persistentvolumeclaim) (kube_persistentvolumeclaim_labels{cluster=~\\\"$cluster\\\", namespace=~\\\"$namespace\\\",label_name=~\\\"(loki|enterprise-logs)-write.*\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{persistentvolumeclaim}}\",\"legendLink\":null,\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Disk Space Utilization\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"percentunit\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Write path\",\"titleSize\":\"h6\",\"type\":\"row\"}],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Writes Resources\",\"uid\":\"writes-resources\",\"version\":0}\n"
    "loki-writes.json"           = "{\"annotations\":{\"list\":[]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"hideControls\":false,\"links\":[{\"asDropdown\":true,\"icon\":\"external link\",\"includeVars\":true,\"keepTime\":true,\"tags\":[\"loki\"],\"targetBlank\":false,\"title\":\"Loki Dashboards\",\"type\":\"dashboards\"}],\"refresh\":\"10s\",\"rows\":[{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{\"1xx\":\"#EAB839\",\"2xx\":\"#7EB26D\",\"3xx\":\"#6ED0E0\",\"4xx\":\"#EF843C\",\"5xx\":\"#E24D42\",\"error\":\"#E24D42\",\"success\":\"#7EB26D\"},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":1,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status) (\\n  label_replace(label_replace(rate(loki_request_duration_seconds_count{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", route=~\\\"api_prom_push|loki_api_v1_push|/httpgrpc.HTTP/Handle\\\"}[$__rate_interval]),\\n  \\\"status\\\", \\\"$${1}xx\\\", \\\"status_code\\\", \\\"([0-9])..\\\"),\\n  \\\"status\\\", \\\"$${1}\\\", \\\"status_code\\\", \\\"([a-z]+)\\\"))\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{status}}\",\"refId\":\"A\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"QPS\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":2,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum by (le) (job:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum by (le) (job:loki_request_duration_seconds_bucket:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", cluster=~\\\"$cluster\\\"})) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"1e3 * sum(job:loki_request_duration_seconds_sum:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", cluster=~\\\"$cluster\\\"}) / sum(job:loki_request_duration_seconds_count:sum_rate{job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", cluster=~\\\"$cluster\\\"})\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"ms\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"Write Path\",\"titleSize\":\"h6\"},{\"collapse\":false,\"height\":\"250px\",\"panels\":[{\"aliasColors\":{\"1xx\":\"#EAB839\",\"2xx\":\"#7EB26D\",\"3xx\":\"#6ED0E0\",\"4xx\":\"#EF843C\",\"5xx\":\"#E24D42\",\"error\":\"#E24D42\",\"success\":\"#7EB26D\"},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":10,\"id\":3,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":0,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":true,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum by (status) (\\n  label_replace(label_replace(rate(loki_boltdb_shipper_request_duration_seconds_count{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", operation=\\\"WRITE\\\"}[$__rate_interval]),\\n  \\\"status\\\", \\\"$${1}xx\\\", \\\"status_code\\\", \\\"([0-9])..\\\"),\\n  \\\"status\\\", \\\"$${1}\\\", \\\"status_code\\\", \\\"([a-z]+)\\\"))\\n\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"{{status}}\",\"refId\":\"A\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"QPS\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":\"$datasource\",\"fill\":1,\"id\":4,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null as zero\",\"percentage\":false,\"pointradius\":5,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"span\":6,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"histogram_quantile(0.99, sum(rate(loki_boltdb_shipper_request_duration_seconds_bucket{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", operation=\\\"WRITE\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"99th Percentile\",\"refId\":\"A\",\"step\":10},{\"expr\":\"histogram_quantile(0.50, sum(rate(loki_boltdb_shipper_request_duration_seconds_bucket{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", operation=\\\"WRITE\\\"}[$__rate_interval])) by (le)) * 1e3\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"50th Percentile\",\"refId\":\"B\",\"step\":10},{\"expr\":\"sum(rate(loki_boltdb_shipper_request_duration_seconds_sum{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", operation=\\\"WRITE\\\"}[$__rate_interval])) * 1e3 / sum(rate(loki_boltdb_shipper_request_duration_seconds_count{cluster=~\\\"$cluster\\\",job=~\\\"($namespace)/(loki|enterprise-logs)-write\\\", operation=\\\"WRITE\\\"}[$__rate_interval]))\",\"format\":\"time_series\",\"intervalFactor\":2,\"legendFormat\":\"Average\",\"refId\":\"C\",\"step\":10}],\"thresholds\":[],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Latency\",\"tooltip\":{\"shared\":true,\"sort\":2,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"ms\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":0,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":false}]}],\"repeat\":null,\"repeatIteration\":null,\"repeatRowId\":null,\"showTitle\":true,\"title\":\"BoltDB Shipper\",\"titleSize\":\"h6\"}],\"schemaVersion\":14,\"style\":\"dark\",\"tags\":[\"loki\"],\"templating\":{\"list\":[{\"current\":{\"text\":\"default\",\"value\":\"default\"},\"hide\":0,\"label\":\"Data Source\",\"name\":\"datasource\",\"options\":[],\"query\":\"prometheus\",\"refresh\":1,\"regex\":\"\",\"type\":\"datasource\"},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"cluster\",\"multi\":false,\"name\":\"cluster\",\"options\":[],\"query\":\"label_values(loki_build_info, cluster)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false},{\"allValue\":null,\"current\":{\"text\":\"prod\",\"value\":\"prod\"},\"datasource\":\"$datasource\",\"hide\":0,\"includeAll\":false,\"label\":\"namespace\",\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(loki_build_info{cluster=~\\\"$cluster\\\"}, namespace)\",\"refresh\":1,\"regex\":\"\",\"sort\":2,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-1h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"utc\",\"title\":\"Loki / Writes\",\"uid\":\"writes\",\"version\":0}\n"
  }
}

resource "kubernetes_config_map" "loki_runtime" {
  metadata {
    name      = "loki-runtime"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  data = {
    "runtime-config.yaml" = "{}\n"
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

resource "kubernetes_cluster_role" "release_name_loki_clusterrole" {
  metadata {
    name = "release-name-loki-clusterrole"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = [""]
    resources  = ["configmaps", "secrets"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_rollout_operator_webhook_clusterrolebinding" {
  metadata {
    name = "release-name-rollout-operator-webhook-clusterrolebinding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "loki"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-rollout-operator-webhook-clusterrole"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_loki_clusterrolebinding" {
  metadata {
    name = "release-name-loki-clusterrolebinding"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "loki"
      "app.kubernetes.io/version"  = "3.5.7"
      "helm.sh/chart"              = "loki-6.46.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-loki"
    namespace = "loki"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-loki-clusterrole"
  }
}

resource "kubernetes_role" "release_name_rollout_operator" {
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
    namespace = "loki"
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
    namespace = "loki"

    labels = {
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "rollout-operator"
      "app.kubernetes.io/version"    = "v0.29.0"
      "helm.sh/chart"                = "rollout-operator-0.33.2"
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
    namespace = "loki"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-rollout-operator"
    namespace = "loki"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-rollout-operator-webhook-role"
  }
}

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

resource "kubernetes_deployment" "release_name_rollout_operator" {
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
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name"     = "rollout-operator"
      }
    }

    template {
      metadata {
        namespace = "loki"

        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name"     = "rollout-operator"
        }
      }

      spec {
        container {
          name  = "rollout-operator"
          image = "grafana/rollout-operator:v0.29.0"
          args  = ["-kubernetes.namespace=loki", "-server-tls.enabled=true", "-server-tls.self-signed-cert.secret-name=certificate"]

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

resource "kubernetes_deployment" "release_name_loki_bloom_builder" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "bloom-builder"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "bloom-builder"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name      = "data"
          empty_dir = {}
        }

        container {
          name  = "bloom-builder"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=bloom-builder"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "bloom-builder"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_distributor" {
  metadata {
    name      = "release-name-loki-distributor"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "distributor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
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

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "distributor"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "distributor"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=distributor", "-distributor.zone-awareness-enabled=true"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "distributor"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_gateway" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "gateway"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
        }

        annotations = {
          "checksum/config" = "9ff0679f9eeb9729dcc7fe1b027cc62e00d69fe1fa5cb48d62a7cf47341968d9"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-loki-gateway"
          }
        }

        volume {
          name = "auth"

          secret {
            secret_name = "loki-gateway-auth-secret"
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
          image = "docker.io/nginxinc/nginx-unprivileged:1.29-alpine"

          port {
            name           = "http-metrics"
            container_port = 8080
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

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 101
          run_as_group    = 101
          run_as_non_root = true
          fs_group        = 101
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "gateway"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
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

resource "kubernetes_deployment" "release_name_loki_querier" {
  metadata {
    name      = "release-name-loki-querier"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "querier"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
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

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "querier"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        volume {
          name      = "data"
          empty_dir = {}
        }

        container {
          name  = "querier"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=querier,ui", "-distributor.zone-awareness-enabled=true"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "querier"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
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
              "app.kubernetes.io/name"      = "loki"
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

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_query_frontend" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-frontend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "query-frontend"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "query-frontend"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=query-frontend"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "query-frontend"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_loki_query_scheduler" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "query-scheduler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "query-scheduler"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "query-scheduler"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=query-scheduler"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "query-scheduler"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "loki_read" {
  metadata {
    name      = "loki-read"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "read"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "read"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "read"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name      = "data"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "loki"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=read,ui", "-legacy-read-mode=false", "-common.compactor-grpc-address=loki-backend.loki.svc.Sumicare:9095"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"
        automount_service_account_token  = true

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "read"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    revision_history_limit = 10
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "release_name_loki_distributor" {
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
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-loki-distributor"
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

resource "kubernetes_horizontal_pod_autoscaler" "release_name_loki_querier" {
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
    scale_target_ref {
      kind        = "Deployment"
      name        = "release-name-loki-querier"
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

resource "kubernetes_stateful_set" "loki_backend" {
  metadata {
    name      = "loki-backend"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "backend"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "backend"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "backend"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config"                         = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
          "kubectl.kubernetes.io/default-container" = "loki"
        }
      }

      spec {
        volume {
          name      = "tmp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        volume {
          name      = "sc-rules-volume"
          empty_dir = {}
        }

        container {
          name  = "loki"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=backend", "-legacy-read-mode=false"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          volume_mount {
            name       = "sc-rules-volume"
            mount_path = "/rules"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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

        container {
          name  = "loki-sc-rules"
          image = "docker.io/kiwigrid/k8s-sidecar:1.30.10"

          env {
            name  = "METHOD"
            value = "WATCH"
          }

          env {
            name  = "LABEL"
            value = "loki_rule"
          }

          env {
            name  = "FOLDER"
            value = "/rules"
          }

          env {
            name  = "RESOURCE"
            value = "both"
          }

          env {
            name  = "WATCH_SERVER_TIMEOUT"
            value = "60"
          }

          env {
            name  = "WATCH_CLIENT_TIMEOUT"
            value = "60"
          }

          env {
            name  = "LOG_LEVEL"
            value = "INFO"
          }

          volume_mount {
            name       = "sc-rules-volume"
            mount_path = "/rules"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"
        automount_service_account_token  = true

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "backend"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    service_name           = "loki-backend-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10

    persistent_volume_claim_retention_policy {
      when_deleted = "Delete"
      when_scaled  = "Delete"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_loki_bloom_gateway" {
  metadata {
    name      = "release-name-loki-bloom-gateway"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-gateway"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "bloom-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "bloom-gateway"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "bloom-gateway"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=bloom-gateway"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "bloom-gateway"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    service_name           = "release-name-loki-bloom-gateway-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_bloom_planner" {
  metadata {
    name      = "release-name-loki-bloom-planner"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "bloom-planner"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "bloom-planner"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "bloom-planner"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "bloom-planner"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=bloom-planner"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "bloom-planner"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    service_name           = "release-name-loki-bloom-planner-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_chunks_cache" {
  metadata {
    name      = "release-name-loki-chunks-cache"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "memcached-chunks-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "memcached-chunks-cache"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "memcached-chunks-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "memcached-chunks-cache"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "memcached-chunks-cache"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          name                          = "memcached-chunks-cache"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 8192", "--extended=modern,track_sizes,ext_path=/data/file:9G,ext_wbuf_size=16", "-I 5m", "-c 16384", "-v", "-u 11211"]

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

          volume_mount {
            name       = "data"
            mount_path = "/data"
          }

          liveness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            failure_threshold     = 6
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

          liveness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
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

        termination_grace_period_seconds = 60
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 11211
          run_as_group    = 11211
          run_as_non_root = true
          fs_group        = 11211
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
            storage = "10G"
          }
        }
      }
    }

    service_name          = "release-name-loki-chunks-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_loki_compactor" {
  metadata {
    name      = "release-name-loki-compactor"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "compactor"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "compactor"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "compactor"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "compactor"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=compactor"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "compactor"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    service_name           = "release-name-loki-compactor-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_index_gateway" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "index-gateway"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "index-gateway"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "index-gateway"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=index-gateway"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "index-gateway"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    service_name = "release-name-loki-index-gateway-headless"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ingester_zone_a" {
  metadata {
    name      = "release-name-loki-ingester-zone-a"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "ingester-zone-a"
      rollout-group                 = "ingester"
    }

    annotations = {
      rollout-max-unavailable = "1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "ingester-zone-a"
        rollout-group                 = "ingester"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
          name                          = "ingester-zone-a"
          rollout-group                 = "ingester"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-ingester.availability-zone=zone-a", "-ingester.unregister-on-shutdown=false", "-ingester.tokens-file-path=/var/loki/ring-tokens", "-target=ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "rollout-group"
                  operator = "In"
                  values   = ["ingester"]
                }

                match_expressions {
                  key      = "name"
                  operator = "NotIn"
                  values   = ["ingester-zone-a"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
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
              "app.kubernetes.io/name"      = "loki"
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

    service_name          = "release-name-loki-ingester-zone-a-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ingester_zone_b" {
  metadata {
    name      = "release-name-loki-ingester-zone-b"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "ingester-zone-b"
      rollout-group                 = "ingester"
    }

    annotations = {
      rollout-max-unavailable = "1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "ingester-zone-b"
        rollout-group                 = "ingester"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
          name                          = "ingester-zone-b"
          rollout-group                 = "ingester"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-ingester.availability-zone=zone-b", "-ingester.unregister-on-shutdown=false", "-ingester.tokens-file-path=/var/loki/ring-tokens", "-target=ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "rollout-group"
                  operator = "In"
                  values   = ["ingester"]
                }

                match_expressions {
                  key      = "name"
                  operator = "NotIn"
                  values   = ["ingester-zone-b"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
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
              "app.kubernetes.io/name"      = "loki"
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

    service_name          = "release-name-loki-ingester-zone-b-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ingester_zone_c" {
  metadata {
    name      = "release-name-loki-ingester-zone-c"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ingester"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "ingester-zone-c"
      rollout-group                 = "ingester"
    }

    annotations = {
      rollout-max-unavailable = "1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "ingester-zone-c"
        rollout-group                 = "ingester"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
          name                          = "ingester-zone-c"
          rollout-group                 = "ingester"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-ingester.availability-zone=zone-c", "-ingester.unregister-on-shutdown=false", "-ingester.tokens-file-path=/var/loki/ring-tokens", "-target=ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "rollout-group"
                  operator = "In"
                  values   = ["ingester"]
                }

                match_expressions {
                  key      = "name"
                  operator = "NotIn"
                  values   = ["ingester-zone-c"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
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
              "app.kubernetes.io/name"      = "loki"
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

    service_name          = "release-name-loki-ingester-zone-c-headless"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_pattern_ingester" {
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
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "pattern-ingester"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "pattern-ingester"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name      = "temp"
          empty_dir = {}
        }

        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "pattern-ingester"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=pattern-ingester"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "temp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "pattern-ingester"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    service_name           = "release-name-loki-pattern-ingester-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "release_name_loki_results_cache" {
  metadata {
    name      = "release-name-loki-results-cache"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "memcached-results-cache"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
      name                          = "memcached-results-cache"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "memcached-results-cache"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
        name                          = "memcached-results-cache"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "memcached-results-cache"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          name                          = "memcached-results-cache"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.39-alpine"
          args  = ["-m 1024", "--extended=modern,track_sizes,ext_path=/data/file:9G,ext_wbuf_size=16", "-I 5m", "-c 16384", "-v", "-u 11211"]

          port {
            name           = "client"
            container_port = 11211
          }

          resources {
            limits = {
              memory = "1229Mi"
            }

            requests = {
              cpu    = "500m"
              memory = "1229Mi"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/data"
          }

          liveness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = "client"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 5
            failure_threshold     = 6
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

          liveness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/metrics"
              port = "http-metrics"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
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

        termination_grace_period_seconds = 60
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 11211
          run_as_group    = 11211
          run_as_non_root = true
          fs_group        = 11211
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
            storage = "10G"
          }
        }
      }
    }

    service_name          = "release-name-loki-results-cache"
    pod_management_policy = "Parallel"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "release_name_loki_ruler" {
  metadata {
    name      = "release-name-loki-ruler"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "ruler"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "ruler"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "ruler"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config"                         = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
          "kubectl.kubernetes.io/default-container" = "ruler"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        volume {
          name      = "tmp"
          empty_dir = {}
        }

        container {
          name  = "ruler"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=ruler"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "ruler"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
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

    service_name           = "release-name-loki-ruler"
    revision_history_limit = 10
  }
}

resource "kubernetes_stateful_set" "loki_write" {
  metadata {
    name      = "loki-write"
    namespace = "loki"

    labels = {
      "app.kubernetes.io/component" = "write"
      "app.kubernetes.io/instance"  = "release-name"
      "app.kubernetes.io/name"      = "loki"
      "app.kubernetes.io/part-of"   = "memberlist"
      "app.kubernetes.io/version"   = "3.5.7"
      "helm.sh/chart"               = "loki-6.46.0"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "write"
        "app.kubernetes.io/instance"  = "release-name"
        "app.kubernetes.io/name"      = "loki"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "write"
          "app.kubernetes.io/instance"  = "release-name"
          "app.kubernetes.io/name"      = "loki"
          "app.kubernetes.io/part-of"   = "memberlist"
          "app.kubernetes.io/version"   = "3.5.7"
          "helm.sh/chart"               = "loki-6.46.0"
        }

        annotations = {
          "checksum/config" = "cfd029565c57a4614f92ac75dd1459408dc26c746d21629655a0613f1ea81226"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "loki"

            items {
              key  = "config.yaml"
              path = "config.yaml"
            }
          }
        }

        volume {
          name = "runtime-config"

          config_map {
            name = "loki-runtime"
          }
        }

        container {
          name  = "loki"
          image = "docker.io/grafana/loki:3.5.7"
          args  = ["-config.file=/etc/loki/config/config.yaml", "-target=write"]

          port {
            name           = "http-metrics"
            container_port = 3100
            protocol       = "TCP"
          }

          port {
            name           = "grpc"
            container_port = 9095
            protocol       = "TCP"
          }

          port {
            name           = "http-memberlist"
            container_port = 7946
            protocol       = "TCP"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/loki/config"
          }

          volume_mount {
            name       = "runtime-config"
            mount_path = "/etc/loki/runtime-config"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/loki"
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "http-metrics"
            }

            initial_delay_seconds = 15
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
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

        termination_grace_period_seconds = 300
        service_account_name             = "release-name-loki"
        automount_service_account_token  = true

        security_context {
          run_as_user     = 10001
          run_as_group    = 10001
          run_as_non_root = true
          fs_group        = 10001
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/component" = "write"
                  "app.kubernetes.io/instance"  = "release-name"
                  "app.kubernetes.io/name"      = "loki"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        enable_service_links = true
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

    service_name           = "loki-write-headless"
    pod_management_policy  = "Parallel"
    revision_history_limit = 10
  }
}

