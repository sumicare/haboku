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


resource "kubernetes_service" "ballista_scheduler" {
  metadata {
    name = "ballista-scheduler"

    labels = {
      app = "ballista-scheduler"
    }
  }

  spec {
    port {
      name = "scheduler"
      port = 50050
    }

    port {
      name = "scheduler-ui"
      port = 80
    }

    selector = {
      app = "ballista-scheduler"
    }
  }
}

resource "kubernetes_service" "ballista_executor" {
  metadata {
    name = "ballista-executor"

    labels = {
      app = "ballista-executor"
    }
  }

  spec {
    port {
      name = "executor"
      port = 50051
    }

    selector = {
      app = "ballista-executor"
    }
  }
}
