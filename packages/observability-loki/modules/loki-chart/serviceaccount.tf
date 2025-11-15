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

