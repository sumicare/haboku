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


resource "kubernetes_job" "release_name_admission_init" {
  metadata {
    name      = "release-name-admission-init"
    namespace = "volcano"

    labels = {
      app = "volcano-admission-init"
    }

    annotations = {
      "helm.sh/hook"               = "pre-install,pre-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
      "helm.sh/hook-weight"        = "5"
    }
  }

  spec {
    backoff_limit = 3

    template {
      metadata {}

      spec {
        container {
          name              = "main"
          image             = "docker.io/volcanosh/vc-webhook-manager:v1.13.0"
          command           = ["./gen-admission-secret.sh", "--service", "release-name-admission-service", "--namespace", "volcano", "--secret", "volcano-admission-secret"]
          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["DAC_OVERRIDE"]
              drop = ["ALL"]
            }

            run_as_user     = 1000
            run_as_non_root = true
          }
        }

        restart_policy       = "Never"
        service_account_name = "release-name-admission-init"

        security_context {
          se_linux_option {
            level = "s0:c123,c456"
          }

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        priority_class_name = "system-cluster-critical"
      }
    }
  }
}

