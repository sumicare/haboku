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


resource "kubernetes_daemonset" "release_name_agent" {
  metadata {
    name      = "release-name-agent"
    namespace = "volcano"
  }

  spec {
    selector {
      match_labels = {
        name = "volcano-agent"
      }
    }

    template {
      metadata {
        name = "volcano-agent"

        labels = {
          name = "volcano-agent"
        }

        annotations = {
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/port"   = "3300"
          "prometheus.io/scheme" = "http"
          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        volume {
          name = "bwm-dir"

          host_path {
            path = "/usr/share/bwmcli/"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "cni-plugin-dir"

          host_path {
            path = "/opt/cni/bin"
            type = "Directory"
          }
        }

        volume {
          name = "host-etc"

          host_path {
            path = "/etc"
            type = "Directory"
          }
        }

        volume {
          name = "host-sys-fs"

          host_path {
            path = "/sys/fs"
            type = "Directory"
          }
        }

        volume {
          name = "host-proc-sys"

          host_path {
            path = "/proc/sys"
            type = "Directory"
          }
        }

        volume {
          name = "log"

          host_path {
            path = "/var/log/volcano/agent"
          }
        }

        volume {
          name = "localtime"

          host_path {
            path = "/etc/localtime"
          }
        }

        volume {
          name = "kubelet-cpu-manager-policy"

          host_path {
            path = "/var/lib/kubelet/"
          }
        }

        volume {
          name = "proc-stat"

          host_path {
            path = "/proc/stat"
            type = "File"
          }
        }

        init_container {
          name    = "volcano-agent-init"
          image   = "docker.io/volcanosh/vc-agent:v1.13.0"
          command = ["/bin/sh", "-c", "/usr/local/bin/install.sh"]

          volume_mount {
            name       = "bwm-dir"
            mount_path = "/usr/share/bwmcli"
          }

          volume_mount {
            name       = "cni-plugin-dir"
            mount_path = "/opt/cni/bin"
          }

          volume_mount {
            name       = "host-etc"
            mount_path = "/host/etc"
          }

          volume_mount {
            name       = "log"
            mount_path = "/var/log/volcano/agent"
          }

          volume_mount {
            name       = "host-proc-sys"
            mount_path = "/host/proc/sys"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["CHOWN", "DAC_OVERRIDE", "FOWNER"]
              drop = ["ALL"]
            }

            run_as_user = 0
          }
        }

        container {
          name    = "volcano-agent"
          image   = "docker.io/volcanosh/vc-agent:v1.13.0"
          command = ["/bin/sh", "-c", "/vc-agent \\\n--v=2 1>> /var/log/volcano/agent/volcano-agent.log 2>&1\n"]

          env {
            name  = "SYS_FS_PATH"
            value = "/host/sys/fs"
          }

          env {
            name  = "CNI_CONF_FILE_PATH"
            value = "/host/etc/cni/net.d/cni.conflist"
          }

          env {
            name = "KUBE_NODE_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "spec.nodeName"
              }
            }
          }

          env {
            name = "KUBE_POD_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }

          env {
            name = "KUBE_POD_NAMESPACE"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          volume_mount {
            name       = "bwm-dir"
            mount_path = "/usr/share/bwmcli"
          }

          volume_mount {
            name       = "cni-plugin-dir"
            mount_path = "/opt/cni/bin"
          }

          volume_mount {
            name       = "host-etc"
            mount_path = "/host/etc"
          }

          volume_mount {
            name       = "log"
            mount_path = "/var/log/volcano/agent"
          }

          volume_mount {
            name              = "host-sys-fs"
            mount_path        = "/host/sys/fs"
            mount_propagation = "HostToContainer"
          }

          volume_mount {
            name       = "host-proc-sys"
            mount_path = "/host/proc/sys"
          }

          volume_mount {
            name       = "localtime"
            read_only  = true
            mount_path = "/etc/localtime"
          }

          volume_mount {
            name       = "kubelet-cpu-manager-policy"
            read_only  = true
            mount_path = "/var/lib/kubelet"
          }

          volume_mount {
            name       = "proc-stat"
            read_only  = true
            mount_path = "/host/proc/stat"
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "3300"
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 5
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["DAC_OVERRIDE", "SETUID", "SETGID", "SETFCAP", "BPF"]
              drop = ["ALL"]
            }

            run_as_user     = 1000
            run_as_non_root = true
          }
        }

        restart_policy       = "Always"
        dns_policy           = "Default"
        service_account_name = "release-name-agent"
        host_network         = true

        security_context {
          se_linux_option {
            level = "s0:c123,c456"
          }

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        toleration {
          key      = "volcano.sh/offline-job-evicting"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        priority_class_name = "system-node-critical"
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "10%"
      }
    }

    revision_history_limit = 10
  }
}

