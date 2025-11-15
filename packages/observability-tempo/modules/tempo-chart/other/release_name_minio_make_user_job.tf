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

