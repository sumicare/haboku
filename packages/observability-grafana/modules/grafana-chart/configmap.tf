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


resource "kubernetes_config_map" "release_name_grafana" {
  metadata {
    name      = "release-name-grafana"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  data = {
    "dashboardproviders.yaml" = "apiVersion: 1\nproviders:\n- disableDeletion: false\n  editable: true\n  folder: \"\"\n  name: default\n  options:\n    path: /var/lib/grafana/dashboards/default\n  orgId: 1\n  type: file\n"
    "datasources.yaml"        = "apiVersion: 1\ndatasources:\n- access: proxy\n  isDefault: true\n  name: Prometheus\n  type: prometheus\n  url: http://prometheus-prometheus-server\n"
    "download_dashboards.sh"  = "#!/usr/bin/env sh\nset -euf\nmkdir -p /var/lib/grafana/dashboards/default\n"
    "grafana.ini"             = "[analytics]\ncheck_for_updates = true\n[grafana_net]\nurl = https://grafana.net\n[log]\nmode = console\n[paths]\ndata = /var/lib/grafana/\nlogs = /var/log/grafana\nplugins = /var/lib/grafana/plugins\nprovisioning = /etc/grafana/provisioning\n[server]\ndomain = ''\n"
    "mutetimes.yaml"          = "apiVersion: 1\nmuteTimes:\n- name: mti_1\n  orgId: 1\n  time_intervals: {}\n"
    "notifiers.yaml"          = "delete_notifiers: null\nnotifiers:\n- is_default: true\n  name: email-notifier\n  org_id: 1\n  org_name: Main Org.\n  settings:\n    addresses: an_email_address@example.com\n  type: email\n  uid: email1\n"
    "policies.yaml"           = "apiVersion: 1\npolicies:\n- orgId: 1\n  receiver: first_uid\n"
    "rules.yaml"              = "apiVersion: 1\ngroups:\n- folder: my_first_folder\n  interval: 60s\n  name: 'grafana_my_rule_group'\n  orgId: 1\n  rules:\n  - annotations:\n      some_key: some_value\n    condition: A\n    dashboardUid: my_dashboard\n    data:\n    - datasourceUid: \"-100\"\n      model:\n        conditions:\n        - evaluator:\n            params:\n            - 3\n            type: gt\n          operator:\n            type: and\n          query:\n            params:\n            - A\n          reducer:\n            type: last\n          type: query\n        datasource:\n          type: __expr__\n          uid: \"-100\"\n        expression: 1==0\n        intervalMs: 1000\n        maxDataPoints: 43200\n        refId: A\n        type: math\n      refId: A\n    for: 60s\n    labels:\n      team: sre_team_1\n    noDataState: Alerting\n    panelId: 123\n    title: my_first_rule\n    uid: my_id_1\n"
    "templates.yaml"          = "apiVersion: 1\ntemplates:\n- name: my_first_template\n  orgId: 1\n  template: |\n    \n    {{ define \"my_first_template\" }}\n    Custom notification message\n    {{ end }}\n    \n"
  }
}

resource "kubernetes_config_map" "release_name_grafana_dashboards_default" {
  metadata {
    name      = "release-name-grafana-dashboards-default"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      dashboard-provider           = "default"
      "helm.sh/chart"              = "grafana-10.1.4"
    }
  }

  data = {
    "some-dashboard.json" = "{}"
  }
}

resource "kubernetes_config_map" "release_name_grafana_test" {
  metadata {
    name      = "release-name-grafana-test"
    namespace = "grafana"

    labels = {
      "app.kubernetes.io/instance" = "release-name"
      "app.kubernetes.io/name"     = "grafana"
      "app.kubernetes.io/version"  = "12.2.1"
      "helm.sh/chart"              = "grafana-10.1.4"
    }

    annotations = {
      "helm.sh/hook"               = "test"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  data = {
    "run.sh" = "@test \"Test Health\" {\n  url=\"http://release-name-grafana/api/health\"\n\n  code=$(wget --server-response --spider --timeout 90 --tries 10 $${url} 2>&1 | awk '/^  HTTP/{print $2}')\n  [ \"$code\" == \"200\" ]\n}"
  }
}

