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


resource "kubernetes_secret" "release_name_minio" {
  metadata {
    name = "release-name-minio"

    labels = {
      app      = "minio"
      chart    = "minio-5.4.0"
      heritage = "Helm"
      release  = "release-name"
    }
  }

  data = {
    rootPassword = "supersecret"
    rootUser     = "grafana-mimir"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "release_name_mimir_logs_instance_usernames" {
  metadata {
    name      = "release-name-mimir-logs-instance-usernames"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }
}

resource "kubernetes_secret" "release_name_mimir_metrics_instance_usernames" {
  metadata {
    name      = "release-name-mimir-metrics-instance-usernames"
    namespace = "mimir"

    labels = {
      "app.kubernetes.io/component"  = "meta-monitoring"
      "app.kubernetes.io/instance"   = "release-name"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "mimir"
      "app.kubernetes.io/version"    = "3.0.0"
      "helm.sh/chart"                = "mimir-distributed-6.0.3"
    }
  }
}

