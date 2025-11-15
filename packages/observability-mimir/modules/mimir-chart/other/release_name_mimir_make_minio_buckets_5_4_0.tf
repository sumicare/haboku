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

