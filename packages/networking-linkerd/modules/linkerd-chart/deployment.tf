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


resource "kubernetes_deployment" "linkerd_identity" {
  metadata {
    name      = "linkerd-identity"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "identity"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "linkerd.io/control-plane-component" = "identity"
        "linkerd.io/control-plane-ns"        = "linkerd"
        "linkerd.io/proxy-deployment"        = "linkerd-identity"
      }
    }

    template {
      metadata {
        labels = {
          "linkerd.io/control-plane-component" = "identity"
          "linkerd.io/control-plane-ns"        = "linkerd"
          "linkerd.io/proxy-deployment"        = "linkerd-identity"
          "linkerd.io/workload-ns"             = "linkerd"
        }

        annotations = {
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true"
          "config.linkerd.io/default-inbound-policy"       = "all-unauthenticated"
          "linkerd.io/created-by"                          = "linkerd/cli edge-25.8.5"
          "linkerd.io/proxy-version"                       = "edge-25.8.5"
          "linkerd.io/trust-root-sha256"                   = "8ed6f788dd7a1b21b02b80d69712e94d600b840f4633b50979208e057954e943"
        }
      }

      spec {
        volume {
          name = "identity-issuer"

          secret {
            secret_name = "linkerd-identity-issuer"
          }
        }

        volume {
          name = "trust-roots"

          config_map {
            name = "linkerd-identity-trust-roots"
          }
        }

        volume {
          name = "kube-api-access"

          projected {
            sources {
              service_account_token {
                expiration_seconds = 3607
                path               = "token"
              }
            }

            sources {
              config_map {
                name = "kube-root-ca.crt"

                items {
                  key  = "ca.crt"
                  path = "ca.crt"
                }
              }
            }

            sources {
              downward_api {
                items {
                  path = "namespace"

                  field_ref {
                    api_version = "v1"
                    field_path  = "metadata.namespace"
                  }
                }
              }
            }

            default_mode = "0644"
          }
        }

        volume {
          name      = "linkerd-proxy-init-xtables-lock"
          empty_dir = {}
        }

        volume {
          name = "linkerd-identity-token"

          projected {
            sources {
              service_account_token {
                audience           = "identity.l5d.io"
                expiration_seconds = 86400
                path               = "linkerd-identity-token"
              }
            }
          }
        }

        volume {
          name = "linkerd-identity-end-entity"

          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name  = "linkerd-init"
          image = "cr.l5d.io/linkerd/proxy-init:v2.4.3"
          args  = ["--firewall-bin-path", "iptables-nft", "--firewall-save-bin-path", "iptables-nft-save", "--ipv6=false", "--incoming-proxy-port", "4143", "--outgoing-proxy-port", "4140", "--proxy-uid", "2102", "--inbound-ports-to-ignore", "4190,4191,4567,4568", "--outbound-ports-to-ignore", "443,6443"]

          volume_mount {
            name       = "linkerd-proxy-init-xtables-lock"
            mount_path = "/run"
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW"]
            }

            run_as_user               = 65534
            run_as_group              = 65534
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "identity"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["identity", "-log-level=info", "-log-format=plain", "-controller-namespace=linkerd", "-identity-trust-domain=sumicare.local", "-identity-issuance-lifetime=24h0m0s", "-identity-clock-skew-allowance=20s", "-identity-scheme=linkerd.io/tls", "-enable-pprof=false", "-kube-apiclient-qps=100", "-kube-apiclient-burst=200"]

          port {
            name           = "ident-grpc"
            container_port = 8080
          }

          port {
            name           = "ident-admin"
            container_port = 9990
          }

          env {
            name  = "LINKERD_DISABLED"
            value = "linkerd-await cannot block the identity controller"
          }

          volume_mount {
            name       = "identity-issuer"
            mount_path = "/var/run/linkerd/identity/issuer"
          }

          volume_mount {
            name       = "trust-roots"
            mount_path = "/var/run/linkerd/identity/trust-roots/"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9990"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9990"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "linkerd-proxy"
          image = "cr.l5d.io/linkerd/proxy:edge-25.8.5"

          port {
            name           = "linkerd-proxy"
            container_port = 4143
          }

          port {
            name           = "linkerd-admin"
            container_port = 4191
          }

          env {
            name = "_pod_name"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "_pod_ns"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "_pod_uid"

            value_from {
              field_ref {
                field_path = "metadata.uid"
              }
            }
          }

          env {
            name = "_pod_ip"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "_pod_nodeName"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "_pod_containerName"
            value = "linkerd-proxy"
          }

          env {
            name  = "LINKERD2_PROXY_CORES"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_CORES_MIN"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_REQUIRE_TLS"
            value = "8080"
          }

          env {
            name  = "LINKERD2_PROXY_SHUTDOWN_ENDPOINT_ENABLED"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_LOG"
            value = "warn,linkerd=info,hickory=error,[{headers}]=off,[{request}]=off"
          }

          env {
            name  = "LINKERD2_PROXY_LOG_FORMAT"
            value = "plain"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_ADDR"
            value = "linkerd-dst-headless.linkerd.svc.cluster.local.:8086"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_ADDR"
            value = "linkerd-policy.linkerd.svc.cluster.local.:8090"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_WORKLOAD"
            value = "{\"ns\":\"$(_pod_ns)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DEFAULT_POLICY"
            value = "all-unauthenticated"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_CLUSTER_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_INITIAL_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_IDLE_TIMEOUT"
            value = "5m"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_LIFETIME"
            value = "1h"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_CONNECT_TIMEOUT"
            value = "100ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_TIMEOUT"
            value = "1000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "5s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "90s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_LISTEN_ADDR"
            value = "0.0.0.0:4190"
          }

          env {
            name  = "LINKERD2_PROXY_ADMIN_LISTEN_ADDR"
            value = "0.0.0.0:4191"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDR"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDRS"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_LISTEN_ADDR"
            value = "0.0.0.0:4143"
          }

          env {
            name = "LINKERD2_PROXY_INBOUND_IPS"

            value_from {
              field_ref {
                field_path = "status.podIPs"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS"
            value = "8080,9990"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_SUFFIXES"
            value = "svc.cluster.local."
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_METRICS_HOSTNAME_LABELS"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_DISABLE_PROTOCOL_DETECTION"
            value = "25,587,3306,4444,5432,6379,9300,11211"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_CONTEXT"
            value = "{\"ns\":\"$(_pod_ns)\", \"nodeName\":\"$(_pod_nodeName)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name = "_pod_sa"

            value_from {
              field_ref {
                field_path = "spec.serviceAccountName"
              }
            }
          }

          env {
            name  = "_l5d_ns"
            value = "linkerd"
          }

          env {
            name  = "_l5d_trustdomain"
            value = "sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_DIR"
            value = "/var/run/linkerd/identity/end-entity"
          }

          env {
            name = "LINKERD2_PROXY_IDENTITY_TRUST_ANCHORS"

            value_from {
              config_map_key_ref {
                name = "linkerd-identity-trust-roots"
                key  = "ca-bundle.crt"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_TOKEN_FILE"
            value = "/var/run/secrets/tokens/linkerd-identity-token"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_ADDR"
            value = "localhost.:8080"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_LOCAL_NAME"
            value = "$(_pod_sa).$(_pod_ns).serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_NAME"
            value = "linkerd-identity.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          volume_mount {
            name       = "linkerd-identity-end-entity"
            mount_path = "/var/run/linkerd/identity/end-entity"
          }

          volume_mount {
            name       = "linkerd-identity-token"
            mount_path = "/var/run/secrets/tokens"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "4191"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "4191"
            }

            initial_delay_seconds = 2
            timeout_seconds       = 1
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2102
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "linkerd-identity"

        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "linkerd_destination" {
  metadata {
    name      = "linkerd-destination"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "destination"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "linkerd.io/control-plane-component" = "destination"
        "linkerd.io/control-plane-ns"        = "linkerd"
        "linkerd.io/proxy-deployment"        = "linkerd-destination"
      }
    }

    template {
      metadata {
        labels = {
          "linkerd.io/control-plane-component" = "destination"
          "linkerd.io/control-plane-ns"        = "linkerd"
          "linkerd.io/proxy-deployment"        = "linkerd-destination"
          "linkerd.io/workload-ns"             = "linkerd"
        }

        annotations = {
          "checksum/config"                                = "ee072d8649691d597d0c68bbf5e65073d6b371c3192d416097a0eaf1cabbbf2a"
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true"
          "config.linkerd.io/default-inbound-policy"       = "all-unauthenticated"
          "linkerd.io/created-by"                          = "linkerd/cli edge-25.8.5"
          "linkerd.io/proxy-version"                       = "edge-25.8.5"
          "linkerd.io/trust-root-sha256"                   = "8ed6f788dd7a1b21b02b80d69712e94d600b840f4633b50979208e057954e943"
        }
      }

      spec {
        volume {
          name = "sp-tls"

          secret {
            secret_name = "linkerd-sp-validator-k8s-tls"
          }
        }

        volume {
          name = "policy-tls"

          secret {
            secret_name = "linkerd-policy-validator-k8s-tls"
          }
        }

        volume {
          name = "kube-api-access"

          projected {
            sources {
              service_account_token {
                expiration_seconds = 3607
                path               = "token"
              }
            }

            sources {
              config_map {
                name = "kube-root-ca.crt"

                items {
                  key  = "ca.crt"
                  path = "ca.crt"
                }
              }
            }

            sources {
              downward_api {
                items {
                  path = "namespace"

                  field_ref {
                    api_version = "v1"
                    field_path  = "metadata.namespace"
                  }
                }
              }
            }

            default_mode = "0644"
          }
        }

        volume {
          name      = "linkerd-proxy-init-xtables-lock"
          empty_dir = {}
        }

        volume {
          name = "linkerd-identity-token"

          projected {
            sources {
              service_account_token {
                audience           = "identity.l5d.io"
                expiration_seconds = 86400
                path               = "linkerd-identity-token"
              }
            }
          }
        }

        volume {
          name = "linkerd-identity-end-entity"

          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name  = "linkerd-init"
          image = "cr.l5d.io/linkerd/proxy-init:v2.4.3"
          args  = ["--firewall-bin-path", "iptables-nft", "--firewall-save-bin-path", "iptables-nft-save", "--ipv6=false", "--incoming-proxy-port", "4143", "--outgoing-proxy-port", "4140", "--proxy-uid", "2102", "--inbound-ports-to-ignore", "4190,4191,4567,4568", "--outbound-ports-to-ignore", "443,6443"]

          volume_mount {
            name       = "linkerd-proxy-init-xtables-lock"
            mount_path = "/run"
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW"]
            }

            run_as_user               = 65534
            run_as_group              = 65534
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "linkerd-proxy"
          image = "cr.l5d.io/linkerd/proxy:edge-25.8.5"

          port {
            name           = "linkerd-proxy"
            container_port = 4143
          }

          port {
            name           = "linkerd-admin"
            container_port = 4191
          }

          env {
            name = "_pod_name"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "_pod_ns"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "_pod_uid"

            value_from {
              field_ref {
                field_path = "metadata.uid"
              }
            }
          }

          env {
            name = "_pod_ip"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "_pod_nodeName"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "_pod_containerName"
            value = "linkerd-proxy"
          }

          env {
            name  = "LINKERD2_PROXY_CORES"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_CORES_MIN"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_SHUTDOWN_ENDPOINT_ENABLED"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_LOG"
            value = "warn,linkerd=info,hickory=error,[{headers}]=off,[{request}]=off"
          }

          env {
            name  = "LINKERD2_PROXY_LOG_FORMAT"
            value = "plain"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_ADDR"
            value = "localhost.:8086"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_ADDR"
            value = "localhost.:8090"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_WORKLOAD"
            value = "{\"ns\":\"$(_pod_ns)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DEFAULT_POLICY"
            value = "all-unauthenticated"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_CLUSTER_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_INITIAL_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_IDLE_TIMEOUT"
            value = "5m"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_LIFETIME"
            value = "1h"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_CONNECT_TIMEOUT"
            value = "100ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_TIMEOUT"
            value = "1000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "5s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "90s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_LISTEN_ADDR"
            value = "0.0.0.0:4190"
          }

          env {
            name  = "LINKERD2_PROXY_ADMIN_LISTEN_ADDR"
            value = "0.0.0.0:4191"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDR"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDRS"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_LISTEN_ADDR"
            value = "0.0.0.0:4143"
          }

          env {
            name = "LINKERD2_PROXY_INBOUND_IPS"

            value_from {
              field_ref {
                field_path = "status.podIPs"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS"
            value = "8086,8090,8443,9443,9990,9996,9997"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_SUFFIXES"
            value = "svc.cluster.local."
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_METRICS_HOSTNAME_LABELS"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_DISABLE_PROTOCOL_DETECTION"
            value = "25,587,3306,4444,5432,6379,9300,11211"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_CONTEXT"
            value = "{\"ns\":\"$(_pod_ns)\", \"nodeName\":\"$(_pod_nodeName)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name = "_pod_sa"

            value_from {
              field_ref {
                field_path = "spec.serviceAccountName"
              }
            }
          }

          env {
            name  = "_l5d_ns"
            value = "linkerd"
          }

          env {
            name  = "_l5d_trustdomain"
            value = "sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_DIR"
            value = "/var/run/linkerd/identity/end-entity"
          }

          env {
            name = "LINKERD2_PROXY_IDENTITY_TRUST_ANCHORS"

            value_from {
              config_map_key_ref {
                name = "linkerd-identity-trust-roots"
                key  = "ca-bundle.crt"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_TOKEN_FILE"
            value = "/var/run/secrets/tokens/linkerd-identity-token"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_ADDR"
            value = "linkerd-identity-headless.linkerd.svc.cluster.local.:8080"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_LOCAL_NAME"
            value = "$(_pod_sa).$(_pod_ns).serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_NAME"
            value = "linkerd-identity.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          volume_mount {
            name       = "linkerd-identity-end-entity"
            mount_path = "/var/run/linkerd/identity/end-entity"
          }

          volume_mount {
            name       = "linkerd-identity-token"
            mount_path = "/var/run/secrets/tokens"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "4191"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "4191"
            }

            initial_delay_seconds = 2
            timeout_seconds       = 1
          }

          lifecycle {
            post_start {
              exec {
                command = ["/usr/lib/linkerd/linkerd-await", "--timeout=2m", "--port=4191"]
              }
            }
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2102
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "destination"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["destination", "-addr=:8086", "-controller-namespace=linkerd", "-outbound-transport-mode=transport-header", "-enable-h2-upgrade=true", "-log-level=info", "-log-format=plain", "-enable-endpoint-slices=true", "-cluster-domain=cluster.local", "-identity-trust-domain=sumicare.local", "-default-opaque-ports=25,587,3306,4444,5432,6379,9300,11211", "-enable-ipv6=false", "-enable-pprof=false", "--meshed-http2-client-params={\"keep_alive\":{\"interval\":{\"seconds\":10},\"timeout\":{\"seconds\":3},\"while_idle\":true}}"]

          port {
            name           = "dest-grpc"
            container_port = 8086
          }

          port {
            name           = "dest-admin"
            container_port = 9996
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9996"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9996"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "sp-validator"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["sp-validator", "-log-level=info", "-log-format=plain", "-enable-pprof=false"]

          port {
            name           = "sp-validator"
            container_port = 8443
          }

          port {
            name           = "spval-admin"
            container_port = 9997
          }

          volume_mount {
            name       = "sp-tls"
            read_only  = true
            mount_path = "/var/run/linkerd/tls"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9997"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9997"
            }

            timeout_seconds   = 1
            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name    = "policy"
          image   = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          command = ["/linkerd-policy-controller"]
          args    = ["--admin-addr=0.0.0.0:9990", "--control-plane-namespace=linkerd", "--grpc-addr=0.0.0.0:8090", "--server-addr=0.0.0.0:9443", "--server-tls-key=/var/run/linkerd/tls/tls.key", "--server-tls-certs=/var/run/linkerd/tls/tls.crt", "--cluster-networks=10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8", "--identity-domain=sumicare.local", "--cluster-domain=cluster.local", "--default-policy=all-unauthenticated", "--log-level=info", "--log-format=plain", "--default-opaque-ports=25,587,3306,4444,5432,6379,9300,11211", "--global-egress-network-namespace=linkerd-egress", "--probe-networks=0.0.0.0/0,::/0"]

          port {
            name           = "policy-grpc"
            container_port = 8090
          }

          port {
            name           = "policy-admin"
            container_port = 9990
          }

          port {
            name           = "policy-https"
            container_port = 9443
          }

          volume_mount {
            name       = "policy-tls"
            read_only  = true
            mount_path = "/var/run/linkerd/tls"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "policy-admin"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "policy-admin"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "linkerd-destination"

        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "linkerd_proxy_injector" {
  metadata {
    name      = "linkerd-proxy-injector"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "proxy-injector"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "linkerd.io/control-plane-component" = "proxy-injector"
      }
    }

    template {
      metadata {
        labels = {
          "linkerd.io/control-plane-component" = "proxy-injector"
          "linkerd.io/control-plane-ns"        = "linkerd"
          "linkerd.io/proxy-deployment"        = "linkerd-proxy-injector"
          "linkerd.io/workload-ns"             = "linkerd"
        }

        annotations = {
          "checksum/config"                                = "03de1737c6d16354996e4d3115f40b59efc332c2dcac3e2ffdc442b4e7ba6c2c"
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true"
          "config.linkerd.io/default-inbound-policy"       = "all-unauthenticated"
          "config.linkerd.io/opaque-ports"                 = "8443"
          "linkerd.io/created-by"                          = "linkerd/cli edge-25.8.5"
          "linkerd.io/proxy-version"                       = "edge-25.8.5"
          "linkerd.io/trust-root-sha256"                   = "8ed6f788dd7a1b21b02b80d69712e94d600b840f4633b50979208e057954e943"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "linkerd-config"
          }
        }

        volume {
          name = "trust-roots"

          config_map {
            name = "linkerd-identity-trust-roots"
          }
        }

        volume {
          name = "tls"

          secret {
            secret_name = "linkerd-proxy-injector-k8s-tls"
          }
        }

        volume {
          name = "kube-api-access"

          projected {
            sources {
              service_account_token {
                expiration_seconds = 3607
                path               = "token"
              }
            }

            sources {
              config_map {
                name = "kube-root-ca.crt"

                items {
                  key  = "ca.crt"
                  path = "ca.crt"
                }
              }
            }

            sources {
              downward_api {
                items {
                  path = "namespace"

                  field_ref {
                    api_version = "v1"
                    field_path  = "metadata.namespace"
                  }
                }
              }
            }

            default_mode = "0644"
          }
        }

        volume {
          name      = "linkerd-proxy-init-xtables-lock"
          empty_dir = {}
        }

        volume {
          name = "linkerd-identity-token"

          projected {
            sources {
              service_account_token {
                audience           = "identity.l5d.io"
                expiration_seconds = 86400
                path               = "linkerd-identity-token"
              }
            }
          }
        }

        volume {
          name = "linkerd-identity-end-entity"

          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name  = "linkerd-init"
          image = "cr.l5d.io/linkerd/proxy-init:v2.4.3"
          args  = ["--firewall-bin-path", "iptables-nft", "--firewall-save-bin-path", "iptables-nft-save", "--ipv6=false", "--incoming-proxy-port", "4143", "--outgoing-proxy-port", "4140", "--proxy-uid", "2102", "--inbound-ports-to-ignore", "4190,4191,4567,4568", "--outbound-ports-to-ignore", "443,6443"]

          volume_mount {
            name       = "linkerd-proxy-init-xtables-lock"
            mount_path = "/run"
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW"]
            }

            run_as_user               = 65534
            run_as_group              = 65534
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "linkerd-proxy"
          image = "cr.l5d.io/linkerd/proxy:edge-25.8.5"

          port {
            name           = "linkerd-proxy"
            container_port = 4143
          }

          port {
            name           = "linkerd-admin"
            container_port = 4191
          }

          env {
            name = "_pod_name"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "_pod_ns"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "_pod_uid"

            value_from {
              field_ref {
                field_path = "metadata.uid"
              }
            }
          }

          env {
            name = "_pod_ip"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "_pod_nodeName"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "_pod_containerName"
            value = "linkerd-proxy"
          }

          env {
            name  = "LINKERD2_PROXY_CORES"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_CORES_MIN"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_SHUTDOWN_ENDPOINT_ENABLED"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_LOG"
            value = "warn,linkerd=info,hickory=error,[{headers}]=off,[{request}]=off"
          }

          env {
            name  = "LINKERD2_PROXY_LOG_FORMAT"
            value = "plain"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_ADDR"
            value = "linkerd-dst-headless.linkerd.svc.cluster.local.:8086"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_ADDR"
            value = "linkerd-policy.linkerd.svc.cluster.local.:8090"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_WORKLOAD"
            value = "{\"ns\":\"$(_pod_ns)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DEFAULT_POLICY"
            value = "all-unauthenticated"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_CLUSTER_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_INITIAL_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_IDLE_TIMEOUT"
            value = "5m"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_LIFETIME"
            value = "1h"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_CONNECT_TIMEOUT"
            value = "100ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_TIMEOUT"
            value = "1000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "5s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "90s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_LISTEN_ADDR"
            value = "0.0.0.0:4190"
          }

          env {
            name  = "LINKERD2_PROXY_ADMIN_LISTEN_ADDR"
            value = "0.0.0.0:4191"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDR"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDRS"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_LISTEN_ADDR"
            value = "0.0.0.0:4143"
          }

          env {
            name = "LINKERD2_PROXY_INBOUND_IPS"

            value_from {
              field_ref {
                field_path = "status.podIPs"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS"
            value = "8443,9995"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_SUFFIXES"
            value = "svc.cluster.local."
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_METRICS_HOSTNAME_LABELS"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_DISABLE_PROTOCOL_DETECTION"
            value = "25,587,3306,4444,5432,6379,9300,11211"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_CONTEXT"
            value = "{\"ns\":\"$(_pod_ns)\", \"nodeName\":\"$(_pod_nodeName)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name = "_pod_sa"

            value_from {
              field_ref {
                field_path = "spec.serviceAccountName"
              }
            }
          }

          env {
            name  = "_l5d_ns"
            value = "linkerd"
          }

          env {
            name  = "_l5d_trustdomain"
            value = "sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_DIR"
            value = "/var/run/linkerd/identity/end-entity"
          }

          env {
            name = "LINKERD2_PROXY_IDENTITY_TRUST_ANCHORS"

            value_from {
              config_map_key_ref {
                name = "linkerd-identity-trust-roots"
                key  = "ca-bundle.crt"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_TOKEN_FILE"
            value = "/var/run/secrets/tokens/linkerd-identity-token"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_ADDR"
            value = "linkerd-identity-headless.linkerd.svc.cluster.local.:8080"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_LOCAL_NAME"
            value = "$(_pod_sa).$(_pod_ns).serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_NAME"
            value = "linkerd-identity.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          volume_mount {
            name       = "linkerd-identity-end-entity"
            mount_path = "/var/run/linkerd/identity/end-entity"
          }

          volume_mount {
            name       = "linkerd-identity-token"
            mount_path = "/var/run/secrets/tokens"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "4191"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "4191"
            }

            initial_delay_seconds = 2
            timeout_seconds       = 1
          }

          lifecycle {
            post_start {
              exec {
                command = ["/usr/lib/linkerd/linkerd-await", "--timeout=2m", "--port=4191"]
              }
            }
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2102
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "proxy-injector"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["proxy-injector", "-log-level=info", "-log-format=plain", "-linkerd-namespace=linkerd", "-enable-pprof=false"]

          port {
            name           = "proxy-injector"
            container_port = 8443
          }

          port {
            name           = "injector-admin"
            container_port = 9995
          }

          volume_mount {
            name       = "config"
            mount_path = "/var/run/linkerd/config"
          }

          volume_mount {
            name       = "trust-roots"
            mount_path = "/var/run/linkerd/identity/trust-roots"
          }

          volume_mount {
            name       = "tls"
            read_only  = true
            mount_path = "/var/run/linkerd/tls"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9995"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9995"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "linkerd-proxy-injector"

        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit = 10
  }
}

