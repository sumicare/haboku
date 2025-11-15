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


resource "kubernetes_deployment" "ballista_executor" {
  metadata {
    name = "ballista-executor"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "ballista-executor"
      }
    }

    template {
      metadata {
        labels = {
          app              = "ballista-executor"
          ballista-cluster = "ballista"
        }
      }

      spec {
        volume {
          name = "data"

          host_path {
            path = "/mnt"
            type = "DirectoryOrCreate"
          }
        }

        container {
          name  = "ballista-executor"
          image = "${var.executor_image}:${var.ballista_version}"
          args  = ["--bind-port=50051", "--scheduler-host=ballista-scheduler", "--scheduler-port=50050"]

          port {
            name           = "flight"
            container_port = 50051
          }

          volume_mount {
            name       = "data"
            mount_path = "/mnt"
          }
        }
      }
    }
  }
}

