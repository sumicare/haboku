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


resource "kubernetes_service_account" "release_name_admission" {
  metadata {
    name      = "release-name-admission"
    namespace = "volcano"
  }
}

resource "kubernetes_service_account" "release_name_agent" {
  metadata {
    name      = "release-name-agent"
    namespace = "volcano"

    labels = {
      app = "volcano-agent"
    }
  }
}

resource "kubernetes_service_account" "release_name_controllers" {
  metadata {
    name      = "release-name-controllers"
    namespace = "volcano"
  }
}

resource "kubernetes_service_account" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "volcano"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }
  }
}

resource "kubernetes_service_account" "release_name_scheduler" {
  metadata {
    name      = "release-name-scheduler"
    namespace = "volcano"
  }
}

resource "kubernetes_service_account" "release_name_admission_init" {
  metadata {
    name      = "release-name-admission-init"
    namespace = "volcano"

    annotations = {
      "helm.sh/hook"               = "pre-install,pre-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
      "helm.sh/hook-weight"        = "0"
    }
  }
}

