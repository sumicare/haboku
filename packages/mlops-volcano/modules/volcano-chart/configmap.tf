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


resource "kubernetes_config_map" "release_name_admission_configmap" {
  metadata {
    name      = "release-name-admission-configmap"
    namespace = "volcano"
  }

  data = {
    "volcano-admission.conf" = file("${path.module}/conf/volcano-admission.conf")
  }
}

resource "kubernetes_config_map" "release_name_controller_configmap" {
  metadata {
    name      = "release-name-controller-configmap"
    namespace = "volcano"
  }

  data = {
    "volcano-controller.conf" = file("${path.module}/conf/volcano-controller.conf")
  }
}

resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = "volcano"
  }

  data = {
    "prometheus.yaml" = file("${path.module}/conf/prometheus.yaml")
  }
}

resource "kubernetes_config_map" "grafana_release_name_dashboard_config" {
  metadata {
    name      = "grafana-release-name-dashboard-config"
    namespace = "volcano"
  }

  data = {
    "dashboard.yaml" = file("${path.module}/conf/dashboard.yaml")
  }
}

resource "kubernetes_config_map" "grafana_release_name_dashboard" {
  metadata {
    name      = "grafana-release-name-dashboard"
    namespace = "volcano"
  }

  data = {
    "volcano-global-overview-dashboard.json"    = file("${path.module}/conf/volcano-global-overview-dashboard.json")
    "volcano-namespace-overview-dashboard.json" = file("${path.module}/conf/volcano-namespace-overview-dashboard.json")
    "volcano-queue-overview-dashboard.json"     = file("${path.module}/conf/volcano-queue-overview-dashboard.json")
  }
}

resource "kubernetes_config_map" "prometheus_server_conf" {
  metadata {
    name      = "prometheus-server-conf"
    namespace = "volcano"

    labels = {
      name = "prometheus-server-conf"
    }
  }

  data = {
    "prometheus.yml" = file("${path.module}/conf/prometheus.yml")
  }
}

resource "kubernetes_config_map" "release_name_scheduler_configmap" {
  metadata {
    name      = "release-name-scheduler-configmap"
    namespace = "volcano"
  }

  data = {
    "volcano-scheduler.conf" = file("${path.module}/conf/volcano-scheduler.conf")
  }
}
