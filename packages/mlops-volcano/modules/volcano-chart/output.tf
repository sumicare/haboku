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

resource "kubernetes_config_map" "release_name_admission_configmap" {
  metadata {
    name      = "release-name-admission-configmap"
    namespace = "volcano"
  }

  data = {
    "volcano-admission.conf" = "#resourceGroups:\n#- resourceGroup: management                    # set the resource group name\n#  object:\n#    key: namespace                             # set the field and the value to be matched\n#    value:\n#    - mng-ns-1\n#  schedulerName: default-scheduler             # set the scheduler for patching\n#  tolerations:                                 # set the tolerations for patching\n#  - effect: NoSchedule\n#    key: taint\n#    operator: Exists\n#  labels:\n#    volcano.sh/nodetype: management           # set the nodeSelector for patching\n#- resourceGroup: cpu\n#  object:\n#    key: annotation\n#    value:\n#    - \"volcano.sh/resource-group: cpu\"\n#  schedulerName: volcano\n#  labels:\n#    volcano.sh/nodetype: cpu\n#- resourceGroup: gpu                          # if the object is unsetted, default is:  the key is annotation,\n#  schedulerName: volcano                      # the annotation key is fixed and is \"volcano.sh/resource-group\", The corresponding value is the resourceGroup field\n#  labels:\n#    volcano.sh/nodetype: gpu\n"
  }
}

resource "kubernetes_config_map" "release_name_controller_configmap" {
  metadata {
    name      = "release-name-controller-configmap"
    namespace = "volcano"
  }

  data = {
    "volcano-controller.conf" = "\n|\n  networkTopologyDiscovery:\n   - source: ufm\n     enabled: true\n     interval: 10m\n     credentials:\n       secretRef:\n         name: ufm-credentials\n         namespace: volcano-system\n     config:\n       endpoint: https://ufm-server:8080\n       insecureSkipVerify: true\n   - source: label\n     enabled: true\n     config:\n       networkTopologyTypes:\n         topologyA2:\n           - nodeLabel: \"volcano.sh/tor\"\n           - nodeLabel: \"kubernetes.io/hostname\"\n         topologyA3:\n           - nodeLabel: \"volcano.sh/hypercluster\"\n           - nodeLabel: \"volcano.sh/hypernode\"\n           - nodeLabel: \"kubernetes.io/hostname\"\n"
  }
}

resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = "volcano"
  }

  data = {
    "prometheus.yaml" = "{\n    \"apiVersion\": 1,\n    \"datasources\": [\n        {\n           \"access\":\"proxy\",\n           \"editable\": true,\n           \"isDefault\": true,\n           \"name\": \"prometheus\",\n           \"orgId\": 1,\n           \"type\": \"prometheus\",\n           \"url\": \"http://prometheus-service.volcano.svc:8080\",\n           \"version\": 1\n        }\n    ]\n}"
  }
}

resource "kubernetes_config_map" "grafana_release_name_dashboard_config" {
  metadata {
    name      = "grafana-release-name-dashboard-config"
    namespace = "volcano"
  }

  data = {
    "dashboard.yaml" = "apiVersion: 1\nproviders:\n- name: dashboards\n  type: file\n  updateIntervalSeconds: 30\n  options:\n    path: /var/lib/grafana/dashboards \n    foldersFromFilesStructure: true"
  }
}

resource "kubernetes_config_map" "grafana_release_name_dashboard" {
  metadata {
    name      = "grafana-release-name-dashboard"
    namespace = "volcano"
  }

  data = {
    "volcano-global-overview-dashboard.json"    = "{\"annotations\":{\"list\":[{\"builtIn\":1,\"datasource\":\"prometheus\",\"enable\":true,\"hide\":true,\"iconColor\":\"rgba(0, 211, 255, 1)\",\"name\":\"Annotations & Alerts\",\"type\":\"dashboard\"}]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"id\":2,\"links\":[],\"panels\":[{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"palette-classic\"},\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":0,\"y\":0},\"id\":20,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"count(max_over_time(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\"}[1h]) != 0)\",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"TPH –Schedule Task In 1 Hour\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":3,\"y\":0},\"id\":21,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(kube_node_info{job=\\\"kube-state-metrics\\\"})\",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Node\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":6,\"y\":0},\"id\":23,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"kube_node_status_capacity{resource=\\\"nvidia_com_gpu\\\",job=\\\"kube-state-metrics\\\"}\",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano GPU\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"bytes\"},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":9,\"y\":0},\"id\":24,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(kube_node_status_capacity{job=\\\"kube-state-metrics\\\", resource=\\\"memory\\\"})\",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Memory\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":12,\"y\":0},\"id\":22,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(kube_node_status_capacity{job=\\\"kube-state-metrics\\\", resource=\\\"cpu\\\"})\",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano CPU\",\"type\":\"stat\"},{\"cards\":{\"cardPadding\":null,\"cardRound\":null},\"color\":{\"cardColor\":\"#b4ff00\",\"colorScale\":\"sqrt\",\"colorScheme\":\"interpolateOranges\",\"exponent\":0.5,\"mode\":\"spectrum\"},\"dataFormat\":\"timeseries\",\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":50}]},\"unit\":\"none\"},\"overrides\":[]},\"gridPos\":{\"h\":8,\"w\":16,\"x\":0,\"y\":5},\"heatmap\":{},\"hideZeroBuckets\":false,\"highlightCards\":true,\"id\":18,\"legend\":{\"show\":false},\"pluginVersion\":\"7.3.4\",\"reverseYBuckets\":false,\"targets\":[{\"expr\":\"increase(volcano_e2e_job_scheduling_latency_milliseconds_bucket[1h])\",\"format\":\"heatmap\",\"instant\":false,\"interval\":\"\",\"legendFormat\":\"{{le}} ms\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Legency Heatmap\",\"tooltip\":{\"show\":true,\"showHistogram\":false},\"transformations\":[],\"type\":\"heatmap\",\"xAxis\":{\"show\":true},\"xBucketNumber\":null,\"xBucketSize\":null,\"yAxis\":{\"decimals\":null,\"format\":\"ms\",\"logBase\":2,\"max\":\"500000\",\"min\":null,\"show\":true,\"splitFactor\":null},\"yBucketBound\":\"auto\",\"yBucketNumber\":null,\"yBucketSize\":null},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":50}]},\"unit\":\"ms\"},\"overrides\":[]},\"gridPos\":{\"h\":7,\"w\":16,\"x\":0,\"y\":13},\"id\":26,\"options\":{\"displayMode\":\"lcd\",\"orientation\":\"horizontal\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"showUnfilled\":true},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"avg(volcano_e2e_job_scheduling_duration{}) by (queue)\",\"interval\":\"\",\"legendFormat\":\"{{queue}}\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Job Scheduling Avg Duration By Queue In 24H\",\"type\":\"bargauge\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{\"align\":null,\"filterable\":false},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"ms\"},\"overrides\":[{\"matcher\":{\"id\":\"byName\",\"options\":\"Value\"},\"properties\":[{\"id\":\"custom.displayMode\",\"value\":\"lcd-gauge\"},{\"id\":\"unit\",\"value\":\"ms\"}]},{\"matcher\":{\"id\":\"byName\",\"options\":\"job_namespace\"},\"properties\":[{\"id\":\"custom.width\",\"value\":279}]}]},\"gridPos\":{\"h\":7,\"w\":16,\"x\":0,\"y\":20},\"id\":27,\"options\":{\"showHeader\":true,\"sortBy\":[{\"desc\":true,\"displayName\":\"Value\"}]},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"avg(volcano_e2e_job_scheduling_duration{}) by (job_namespace)\",\"format\":\"table\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"Namespace: {{job_namespace}}\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Job Avg Scheduling Duration By Namespace In 24H\",\"transformations\":[{\"id\":\"organize\",\"options\":{\"excludeByName\":{\"Time\":true},\"indexByName\":{},\"renameByName\":{}}}],\"type\":\"table\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{\"align\":null,\"filterable\":false},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[{\"matcher\":{\"id\":\"byName\",\"options\":\"Value\"},\"properties\":[{\"id\":\"custom.displayMode\",\"value\":\"lcd-gauge\"},{\"id\":\"unit\",\"value\":\"bytes\"}]}]},\"gridPos\":{\"h\":8,\"w\":16,\"x\":0,\"y\":27},\"id\":29,\"options\":{\"showHeader\":true},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(kube_pod_volcano_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\",job=\\\"kube-state-metrics\\\",queue!=\\\"\\\"}) by (queue)\",\"format\":\"table\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"{{queue}}\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Resource Usage Sort By Queue In 24H\",\"transformations\":[{\"id\":\"organize\",\"options\":{\"excludeByName\":{\"Time\":true},\"indexByName\":{},\"renameByName\":{}}}],\"type\":\"table\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{\"align\":null,\"filterable\":false},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"bytes\"},\"overrides\":[{\"matcher\":{\"id\":\"byName\",\"options\":\"Value\"},\"properties\":[{\"id\":\"custom.displayMode\",\"value\":\"lcd-gauge\"}]}]},\"gridPos\":{\"h\":8,\"w\":16,\"x\":0,\"y\":35},\"id\":30,\"options\":{\"showHeader\":true,\"sortBy\":[{\"desc\":true,\"displayName\":\"Value\"}]},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(kube_pod_volcano_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\",job=\\\"kube-state-metrics\\\"}) by (volcano_namespace)\",\"format\":\"table\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"Namespace : {{volcano_namespace}}\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Resource Usage Sort By Namespace In 24H\",\"transformations\":[{\"id\":\"organize\",\"options\":{\"excludeByName\":{\"Time\":true},\"indexByName\":{},\"renameByName\":{}}}],\"type\":\"table\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"color\":{\"mode\":\"thresholds\"},\"custom\":{\"align\":null,\"filterable\":false},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[{\"matcher\":{\"id\":\"byName\",\"options\":\"Value\"},\"properties\":[{\"id\":\"custom.width\",\"value\":651},{\"id\":\"custom.displayMode\",\"value\":\"lcd-gauge\"},{\"id\":\"unit\",\"value\":\"ms\"},{\"id\":\"thresholds\",\"value\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}}]},{\"matcher\":{\"id\":\"byName\",\"options\":\"job_name\"},\"properties\":[{\"id\":\"custom.width\",\"value\":361}]},{\"matcher\":{\"id\":\"byName\",\"options\":\"Volcano Job\"},\"properties\":[{\"id\":\"custom.width\",\"value\":228}]}]},\"gridPos\":{\"h\":13,\"w\":16,\"x\":0,\"y\":43},\"id\":16,\"options\":{\"frameIndex\":1,\"showHeader\":true,\"sortBy\":[{\"desc\":true,\"displayName\":\"Value\"}]},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"increase(volcano_e2e_job_scheduling_duration{}[24h]) != 0\",\"format\":\"table\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Job Running Legency\",\"transformations\":[{\"id\":\"organize\",\"options\":{\"excludeByName\":{\"Time\":true,\"__name__\":true,\"instance\":true,\"job\":true,\"kubernetes_name\":true,\"kubernetes_namespace\":true},\"indexByName\":{},\"renameByName\":{\"Time\":\"\",\"job_name\":\"Volcano Job\"}}}],\"type\":\"table\"},{\"collapsed\":false,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":56},\"id\":13,\"panels\":[],\"title\":\"Volcano Fairness\",\"type\":\"row\"},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":16,\"x\":0,\"y\":57},\"hiddenSeries\":false,\"id\":14,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"paceLength\":10,\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"stddev(volcano_e2e_job_scheduling_duration)/avg(volcano_e2e_job_scheduling_duration)\",\"format\":\"time_series\",\"intervalFactor\":1,\"legendFormat\":\"CV (Job Duration)\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Job Duration Coefficient Of Variation\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"transparent\":true,\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"percentunit\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"collapsed\":false,\"datasource\":null,\"gridPos\":{\"h\":1,\"w\":24,\"x\":0,\"y\":64},\"id\":11,\"panels\":[],\"title\":\"Volcano Effectiveness\",\"type\":\"row\"},{\"cacheTimeout\":null,\"colorBackground\":false,\"colorValue\":false,\"colors\":[\"#299c46\",\"rgba(237, 129, 40, 0.89)\",\"#d44a3a\"],\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"format\":\"percentunit\",\"gauge\":{\"maxValue\":1,\"minValue\":0,\"show\":true,\"thresholdLabels\":false,\"thresholdMarkers\":true},\"gridPos\":{\"h\":8,\"w\":5,\"x\":0,\"y\":65},\"id\":2,\"interval\":null,\"links\":[],\"mappingType\":1,\"mappingTypes\":[{\"name\":\"value to text\",\"value\":1},{\"name\":\"range to text\",\"value\":2}],\"maxDataPoints\":100,\"nullPointMode\":\"connected\",\"nullText\":null,\"postfix\":\"\",\"postfixFontSize\":\"50%\",\"prefix\":\"\",\"prefixFontSize\":\"50%\",\"rangeMaps\":[{\"from\":\"null\",\"text\":\"N/A\",\"to\":\"null\"}],\"sparkline\":{\"fillColor\":\"rgba(31, 118, 189, 0.18)\",\"full\":false,\"lineColor\":\"rgb(31, 120, 193)\",\"show\":false},\"tableColumn\":\"\",\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_container_resource_requests{resource=\\\"cpu\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{}) \\nby (pod,namespace)))/\\nsum(kube_node_status_allocatable{resource=\\\"cpu\\\", unit=\\\"core\\\"})\",\"format\":\"time_series\",\"instant\":false,\"interval\":\"\",\"intervalFactor\":1,\"legendFormat\":\"\",\"refId\":\"A\"}],\"thresholds\":\"0.7,0.9\",\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Cluster Average CPU Usage\",\"transparent\":true,\"type\":\"singlestat\",\"valueFontSize\":\"80%\",\"valueMaps\":[{\"op\":\"=\",\"text\":\"N/A\",\"value\":\"null\"}],\"valueName\":\"current\"},{\"cacheTimeout\":null,\"colorBackground\":false,\"colorValue\":false,\"colors\":[\"#299c46\",\"rgba(237, 129, 40, 0.89)\",\"#d44a3a\"],\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"format\":\"percentunit\",\"gauge\":{\"maxValue\":1,\"minValue\":0,\"show\":true,\"thresholdLabels\":false,\"thresholdMarkers\":true},\"gridPos\":{\"h\":8,\"w\":5,\"x\":5,\"y\":65},\"id\":3,\"interval\":null,\"links\":[],\"mappingType\":1,\"mappingTypes\":[{\"name\":\"value to text\",\"value\":1},{\"name\":\"range to text\",\"value\":2}],\"maxDataPoints\":100,\"nullPointMode\":\"connected\",\"nullText\":null,\"postfix\":\"\",\"postfixFontSize\":\"50%\",\"prefix\":\"\",\"prefixFontSize\":\"50%\",\"rangeMaps\":[{\"from\":\"null\",\"text\":\"N/A\",\"to\":\"null\"}],\"sparkline\":{\"fillColor\":\"rgba(31, 118, 189, 0.18)\",\"full\":false,\"lineColor\":\"rgb(31, 120, 193)\",\"show\":false},\"tableColumn\":\"\",\"targets\":[{\"expr\":\"sum((sum(kube_pod_container_resource_requests{resource=\\\"memory\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{}) by (pod,namespace)))/sum(kube_node_status_allocatable{resource=\\\"memory\\\", unit=\\\"byte\\\"})\",\"format\":\"time_series\",\"instant\":false,\"interval\":\"\",\"intervalFactor\":1,\"legendFormat\":\"\",\"refId\":\"A\"}],\"thresholds\":\"0.7,0.9\",\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Cluster Average Memory Usage\",\"transparent\":true,\"type\":\"singlestat\",\"valueFontSize\":\"80%\",\"valueMaps\":[{\"op\":\"=\",\"text\":\"N/A\",\"value\":\"null\"}],\"valueName\":\"current\"},{\"cacheTimeout\":null,\"colorBackground\":false,\"colorValue\":false,\"colors\":[\"#299c46\",\"rgba(237, 129, 40, 0.89)\",\"#d44a3a\"],\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"format\":\"percentunit\",\"gauge\":{\"maxValue\":1,\"minValue\":0,\"show\":true,\"thresholdLabels\":false,\"thresholdMarkers\":true},\"gridPos\":{\"h\":8,\"w\":5,\"x\":10,\"y\":65},\"id\":4,\"interval\":null,\"links\":[],\"mappingType\":1,\"mappingTypes\":[{\"name\":\"value to text\",\"value\":1},{\"name\":\"range to text\",\"value\":2}],\"maxDataPoints\":100,\"nullPointMode\":\"connected\",\"nullText\":null,\"postfix\":\"\",\"postfixFontSize\":\"50%\",\"prefix\":\"\",\"prefixFontSize\":\"50%\",\"rangeMaps\":[{\"from\":\"null\",\"text\":\"N/A\",\"to\":\"null\"}],\"sparkline\":{\"fillColor\":\"rgba(31, 118, 189, 0.18)\",\"full\":false,\"lineColor\":\"rgb(31, 120, 193)\",\"show\":false},\"tableColumn\":\"\",\"targets\":[{\"expr\":\"sum((sum(kube_pod_container_resource_requests{resource=\\\"nvidia_com_gpu\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{}) by (pod,namespace)))/sum(kube_node_status_capacity{resource=\\\"nvidia_com_gpu\\\"})\",\"format\":\"time_series\",\"instant\":false,\"interval\":\"\",\"intervalFactor\":1,\"legendFormat\":\"\",\"refId\":\"A\"}],\"thresholds\":\"0.7,0.9\",\"timeFrom\":null,\"timeShift\":null,\"title\":\"Volcano Cluster Average GPU Usage\",\"transparent\":true,\"type\":\"singlestat\",\"valueFontSize\":\"80%\",\"valueMaps\":[{\"op\":\"=\",\"text\":\"N/A\",\"value\":\"null\"}],\"valueName\":\"current\"},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":7,\"w\":16,\"x\":0,\"y\":73},\"hiddenSeries\":false,\"id\":6,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"links\":[],\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"paceLength\":10,\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"stddev(sum by (node) (kube_pod_container_resource_requests{resource=\\\"cpu\\\"}))/avg(sum by (node) (kube_pod_container_resource_requests{resource=\\\"cpu\\\"}))\",\"format\":\"time_series\",\"intervalFactor\":1,\"legendFormat\":\"CV (CPU)\",\"refId\":\"A\"},{\"expr\":\"stddev(sum by (node) (kube_pod_container_resource_requests{resource=\\\"memory\\\"}))/avg(sum by (node) (kube_pod_container_resource_requests{resource=\\\"memory\\\"}))\",\"format\":\"time_series\",\"intervalFactor\":1,\"legendFormat\":\"CV (Memory)\",\"refId\":\"B\"},{\"expr\":\"stddev(sum by (node) (kube_pod_container_resource_requests{resource=\\\"nvidia_com_gpu\\\"}))/avg(sum by (node) (kube_pod_container_resource_requests{resource=\\\"nvidia_com_gpu\\\"}))\",\"format\":\"time_series\",\"intervalFactor\":1,\"legendFormat\":\"CV (Nvidia GPU)\",\"refId\":\"C\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Node Resource Coefficient Of Variation\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"transparent\":true,\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"percentunit\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"refresh\":false,\"schemaVersion\":26,\"style\":\"dark\",\"tags\":[],\"templating\":{\"list\":[]},\"time\":{\"from\":\"now-12h\",\"to\":\"now\"},\"timepicker\":{\"refresh_intervals\":[\"5s\",\"10s\",\"30s\",\"1m\",\"5m\",\"15m\",\"30m\",\"1h\",\"2h\",\"1d\"],\"time_options\":[\"5m\",\"15m\",\"1h\",\"6h\",\"12h\",\"24h\",\"2d\",\"7d\",\"30d\"]},\"timezone\":\"\",\"title\":\"Volcano Global Overview Dashboard\",\"uid\":\"nYn30KvMzf\",\"version\":19}"
    "volcano-namespace-overview-dashboard.json" = "{\"annotations\":{\"list\":[{\"builtIn\":1,\"datasource\":\"prometheus\",\"enable\":true,\"hide\":true,\"iconColor\":\"rgba(0, 211, 255, 1)\",\"name\":\"Annotations & Alerts\",\"type\":\"dashboard\"}]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"id\":3,\"iteration\":1607928231899,\"links\":[],\"panels\":[{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":0,\"y\":0},\"id\":6,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\",namespace=\\\"$namespace\\\"}==1)\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running Job\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":3,\"y\":0},\"id\":16,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"count(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\",namespace=\\\"$namespace\\\"}==0)\",\"instant\":false,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Finished Job Total\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":6,\"y\":0},\"id\":17,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"count((max_over_time(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",namespace=\\\"$namespace\\\"}[10m]) != 0) and kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",namespace=\\\"$namespace\\\"} == 0)\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Last 10m Finished Job\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"short\"},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":9,\"y\":0},\"id\":7,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"cpu\\\",job=\\\"kube-state-metrics\\\",volcano_namespace=\\\"$namespace\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\"}) \\nby (pod,namespace))) \",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"volcano_job\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running CPU\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"short\"},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":12,\"y\":0},\"id\":8,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"gpu\\\",job=\\\"kube-state-metrics\\\",volcano_namespace=\\\"$namespace\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\"}) \\nby (pod,namespace))) \",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"volcano_job\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running GPU\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"bytes\"},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":15,\"y\":0},\"id\":2,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"memory\\\",job=\\\"kube-state-metrics\\\",volcano_namespace=\\\"$namespace\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\"}) \\nby (pod,namespace))) \",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"volcano_job\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running Memory\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{\"align\":null,\"filterable\":false},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[{\"matcher\":{\"id\":\"byName\",\"options\":\"Time\"},\"properties\":[{\"id\":\"custom.width\",\"value\":195}]},{\"matcher\":{\"id\":\"byName\",\"options\":\"__name__\"},\"properties\":[{\"id\":\"custom.width\",\"value\":267}]},{\"matcher\":{\"id\":\"byName\",\"options\":\"Value\"},\"properties\":[{\"id\":\"custom.displayMode\",\"value\":\"lcd-gauge\"},{\"id\":\"unit\",\"value\":\"ms\"}]}]},\"gridPos\":{\"h\":24,\"w\":12,\"x\":0,\"y\":5},\"id\":14,\"options\":{\"showHeader\":true,\"sortBy\":[{\"desc\":true,\"displayName\":\"Value\"}]},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"increase(volcano_e2e_job_scheduling_duration{job_namespace=\\\"$namespace\\\"}[24h]) != 0 \",\"format\":\"table\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Namespace Running Job Legency In 24H\",\"transformations\":[{\"id\":\"organize\",\"options\":{\"excludeByName\":{\"Time\":true,\"__name__\":true,\"instance\":true,\"job\":true,\"kubernetes_name\":true,\"kubernetes_namespace\":true},\"indexByName\":{},\"renameByName\":{}}}],\"type\":\"table\"},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":5},\"hiddenSeries\":false,\"id\":12,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"cpu\\\",job=\\\"kube-state-metrics\\\",volcano_namespace=\\\"$namespace\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\"}) \\nby (pod,namespace))) \",\"interval\":\"\",\"legendFormat\":\"CPU Cores\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Namespace Running CPU\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"unit\":\"bytes\"},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":13},\"hiddenSeries\":false,\"id\":10,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"memory\\\",job=\\\"kube-state-metrics\\\",volcano_namespace=\\\"$namespace\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\"}) \\nby (pod,namespace))) \",\"interval\":\"\",\"legendFormat\":\"Memory Bytes\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Namespace Running Memory \",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":21},\"hiddenSeries\":false,\"id\":11,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"gpu\\\",job=\\\"kube-state-metrics\\\",volcano_namespace=\\\"$namespace\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_container_status_running{job=\\\"kube-state-metrics\\\"}) \\nby (pod,namespace))) \",\"interval\":\"\",\"legendFormat\":\"GPU Cards\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Namespace Running GPU\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"schemaVersion\":26,\"style\":\"dark\",\"tags\":[],\"templating\":{\"list\":[{\"allValue\":null,\"current\":{\"selected\":false,\"text\":\"yu7gvcjd\",\"value\":\"yu7gvcjd\"},\"datasource\":\"prometheus\",\"definition\":\"label_values(kube_namespace_labels, namespace)\",\"error\":null,\"hide\":0,\"includeAll\":false,\"label\":null,\"multi\":false,\"name\":\"namespace\",\"options\":[],\"query\":\"label_values(kube_namespace_labels, namespace)\",\"refresh\":1,\"regex\":\"\",\"skipUrlSync\":false,\"sort\":0,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-6h\",\"to\":\"now\"},\"timepicker\":{},\"timezone\":\"\",\"title\":\"Volcano Namespace  View\",\"uid\":\"TWuLSpJMk\",\"version\":14}"
    "volcano-queue-overview-dashboard.json"     = "{\"annotations\":{\"list\":[{\"builtIn\":1,\"datasource\":\"prometheus\",\"enable\":true,\"hide\":true,\"iconColor\":\"rgba(0, 211, 255, 1)\",\"name\":\"Annotations & Alerts\",\"type\":\"dashboard\"}]},\"editable\":true,\"gnetId\":null,\"graphTooltip\":0,\"id\":4,\"iteration\":1607928216980,\"links\":[],\"panels\":[{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":0,\"y\":0},\"id\":6,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}==1)\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running Job\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":3,\"y\":0},\"id\":16,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"lastNotNull\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"count(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}==0)\",\"instant\":false,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Finished Job\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":6,\"y\":0},\"id\":17,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"count((max_over_time(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}[10m]) != 0) and kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"} == 0)\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Last 10m Finished Job\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"short\"},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":9,\"y\":0},\"id\":7,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"cpu\\\",job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) \\nby (pod,namespace))) \",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"volcano_job\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running CPU\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"short\"},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":12,\"y\":0},\"id\":8,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"gpu\\\",job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) \\nby (pod,namespace))) \",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"volcano_job\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running GPU\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"mappings\":[],\"thresholds\":{\"mode\":\"absolute\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]},\"unit\":\"bytes\"},\"overrides\":[]},\"gridPos\":{\"h\":5,\"w\":3,\"x\":15,\"y\":0},\"id\":2,\"options\":{\"colorMode\":\"value\",\"graphMode\":\"area\",\"justifyMode\":\"auto\",\"orientation\":\"auto\",\"reduceOptions\":{\"calcs\":[\"mean\"],\"fields\":\"\",\"values\":false},\"textMode\":\"auto\"},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"memory\\\",job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) \\nby (pod,namespace))) \",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"volcano_job\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Running Memory\",\"type\":\"stat\"},{\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{\"align\":null,\"filterable\":false},\"mappings\":[],\"thresholds\":{\"mode\":\"percentage\",\"steps\":[{\"color\":\"green\",\"value\":null},{\"color\":\"red\",\"value\":80}]}},\"overrides\":[{\"matcher\":{\"id\":\"byName\",\"options\":\"Time\"},\"properties\":[{\"id\":\"custom.width\",\"value\":195}]},{\"matcher\":{\"id\":\"byName\",\"options\":\"__name__\"},\"properties\":[{\"id\":\"custom.width\",\"value\":267}]},{\"matcher\":{\"id\":\"byName\",\"options\":\"Value\"},\"properties\":[{\"id\":\"custom.displayMode\",\"value\":\"lcd-gauge\"},{\"id\":\"unit\",\"value\":\"ms\"}]}]},\"gridPos\":{\"h\":24,\"w\":12,\"x\":0,\"y\":5},\"id\":14,\"options\":{\"showHeader\":true,\"sortBy\":[{\"desc\":true,\"displayName\":\"Value\"}]},\"pluginVersion\":\"7.3.4\",\"targets\":[{\"expr\":\"increase(volcano_e2e_job_scheduling_duration{queue=\\\"$queue\\\"}[24h]) != 0  \",\"format\":\"table\",\"instant\":true,\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"timeFrom\":null,\"timeShift\":null,\"title\":\"Queue Running Job Legency\",\"transformations\":[{\"id\":\"organize\",\"options\":{\"excludeByName\":{\"Time\":true,\"__name__\":true,\"instance\":true,\"job\":true,\"kubernetes_name\":true,\"kubernetes_namespace\":true},\"indexByName\":{},\"renameByName\":{}}}],\"type\":\"table\"},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":5},\"hiddenSeries\":false,\"id\":12,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"cpu\\\",job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) \\nby (pod,namespace))) \",\"interval\":\"\",\"legendFormat\":\"CPU Cores\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Queue Running CPU\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{},\"unit\":\"bytes\"},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":13},\"hiddenSeries\":false,\"id\":10,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"memory\\\",job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) \\nby (pod,namespace))) \",\"interval\":\"\",\"legendFormat\":\"\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Queue Running Memory \",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"bytes\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}},{\"aliasColors\":{},\"bars\":false,\"dashLength\":10,\"dashes\":false,\"datasource\":null,\"fieldConfig\":{\"defaults\":{\"custom\":{}},\"overrides\":[]},\"fill\":1,\"fillGradient\":0,\"gridPos\":{\"h\":8,\"w\":12,\"x\":12,\"y\":21},\"hiddenSeries\":false,\"id\":11,\"legend\":{\"avg\":false,\"current\":false,\"max\":false,\"min\":false,\"show\":true,\"total\":false,\"values\":false},\"lines\":true,\"linewidth\":1,\"nullPointMode\":\"null\",\"options\":{\"alertThreshold\":true},\"percentage\":false,\"pluginVersion\":\"7.3.4\",\"pointradius\":2,\"points\":false,\"renderer\":\"flot\",\"seriesOverrides\":[],\"spaceLength\":10,\"stack\":false,\"steppedLine\":false,\"targets\":[{\"expr\":\"sum(\\n(sum(kube_pod_volcano_container_resource_requests{resource=\\\"gpu\\\",job=\\\"kube-state-metrics\\\",volcano_namespace=\\\"$namespace\\\"}) by (pod,namespace)) * on(pod) (max(kube_pod_volcano_container_status_running{job=\\\"kube-state-metrics\\\",queue=\\\"$queue\\\"}) \\nby (pod,namespace))) \",\"interval\":\"\",\"legendFormat\":\"GPU Cards\",\"refId\":\"A\"}],\"thresholds\":[],\"timeFrom\":null,\"timeRegions\":[],\"timeShift\":null,\"title\":\"Queue Running GPU\",\"tooltip\":{\"shared\":true,\"sort\":0,\"value_type\":\"individual\"},\"type\":\"graph\",\"xaxis\":{\"buckets\":null,\"mode\":\"time\",\"name\":null,\"show\":true,\"values\":[]},\"yaxes\":[{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true},{\"format\":\"short\",\"label\":null,\"logBase\":1,\"max\":null,\"min\":null,\"show\":true}],\"yaxis\":{\"align\":false,\"alignLevel\":null}}],\"schemaVersion\":26,\"style\":\"dark\",\"tags\":[],\"templating\":{\"list\":[{\"allValue\":null,\"current\":{\"selected\":false,\"text\":\"default\",\"value\":\"default\"},\"datasource\":\"prometheus\",\"definition\":\"label_values(volcano_queue_share,queue_name)\",\"error\":null,\"hide\":0,\"includeAll\":false,\"label\":null,\"multi\":false,\"name\":\"queue\",\"options\":[],\"query\":\"label_values(volcano_queue_share,queue_name)\",\"refresh\":1,\"regex\":\"\",\"skipUrlSync\":false,\"sort\":0,\"tagValuesQuery\":\"\",\"tags\":[],\"tagsQuery\":\"\",\"type\":\"query\",\"useTags\":false}]},\"time\":{\"from\":\"now-6h\",\"to\":\"now\"},\"timepicker\":{},\"timezone\":\"\",\"title\":\"Volcano Queue View\",\"uid\":\"sAtQfo1Mk\",\"version\":8}"
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
    "prometheus.rules" = "groups:\n- name: devopscube demo alert\n  rules:\n  - alert: High Pod Memory\n    expr: sum(container_memory_usage_bytes) > 1\n    for: 1m\n    labels:\n      severity: slack\n    annotations:\n      summary: High Memory Usage"
    "prometheus.yml"   = "global:\n  scrape_interval: 5s\n  evaluation_interval: 5s\nrule_files:\n  - /etc/prometheus/prometheus.rules\nalerting:\n  alertmanagers:\n  - scheme: http\n    static_configs:\n    - targets:\n      - \"alertmanager.monitoring.svc:9093\"\n\nscrape_configs:\n  - job_name: 'kubernetes-apiservers'\n\n    kubernetes_sd_configs:\n    - role: endpoints\n    scheme: https\n\n    tls_config:\n      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]\n      action: keep\n      regex: default;kubernetes;https\n\n  - job_name: 'kubernetes-nodes'\n\n    scheme: https\n\n    tls_config:\n      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n\n    kubernetes_sd_configs:\n    - role: node\n\n    relabel_configs:\n    - action: labelmap\n      regex: __meta_kubernetes_node_label_(.+)\n    - target_label: __address__\n      replacement: kubernetes.default.svc:443\n    - source_labels: [__meta_kubernetes_node_name]\n      regex: (.+)\n      target_label: __metrics_path__\n      replacement: /api/v1/nodes/$${1}/proxy/metrics\n\n  \n  - job_name: 'kubernetes-pods'\n\n    kubernetes_sd_configs:\n    - role: pod\n\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]\n      action: keep\n      regex: true\n    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]\n      action: replace\n      target_label: __metrics_path__\n      regex: (.+)\n    - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]\n      action: replace\n      regex: ([^:]+)(?::\\d+)?;(\\d+)\n      replacement: $1:$2\n      target_label: __address__\n    - action: labelmap\n      regex: __meta_kubernetes_pod_label_(.+)\n    - source_labels: [__meta_kubernetes_namespace]\n      action: replace\n      target_label: kubernetes_namespace\n    - source_labels: [__meta_kubernetes_pod_name]\n      action: replace\n      target_label: kubernetes_pod_name\n  \n  - job_name: 'kube-state-metrics'\n    static_configs:\n      - targets: ['kube-state-metrics.volcano.svc.cluster.local:8080']\n\n  - job_name: 'kubernetes-cadvisor'\n\n    scheme: https\n\n    tls_config:\n      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n\n    kubernetes_sd_configs:\n    - role: node\n\n    relabel_configs:\n    - action: labelmap\n      regex: __meta_kubernetes_node_label_(.+)\n    - target_label: __address__\n      replacement: kubernetes.default.svc:443\n    - source_labels: [__meta_kubernetes_node_name]\n      regex: (.+)\n      target_label: __metrics_path__\n      replacement: /api/v1/nodes/$${1}/proxy/metrics/cadvisor\n  \n  - job_name: 'kubernetes-service-endpoints'\n\n    kubernetes_sd_configs:\n    - role: endpoints\n\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]\n      action: keep\n      regex: true\n    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]\n      action: replace\n      target_label: __scheme__\n      regex: (https?)\n    - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]\n      action: replace\n      target_label: __metrics_path__\n      regex: (.+)\n    - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]\n      action: replace\n      target_label: __address__\n      regex: ([^:]+)(?::\\d+)?;(\\d+)\n      replacement: $1:$2\n    - action: labelmap\n      regex: __meta_kubernetes_service_label_(.+)\n    - source_labels: [__meta_kubernetes_namespace]\n      action: replace\n      target_label: kubernetes_namespace\n    - source_labels: [__meta_kubernetes_service_name]\n      action: replace\n      target_label: kubernetes_name"
  }
}

resource "kubernetes_config_map" "release_name_scheduler_configmap" {
  metadata {
    name      = "release-name-scheduler-configmap"
    namespace = "volcano"
  }

  data = {
    "volcano-scheduler.conf" = "actions: \"enqueue, allocate, backfill\"\ntiers:\n- plugins:\n  - name: priority\n  - name: gang\n    enablePreemptable: false\n  - name: conformance\n- plugins:\n  - name: overcommit\n  - name: drf\n    enablePreemptable: false\n  - name: predicates\n  - name: proportion\n  - name: nodeorder\n  - name: binpack\n"
  }
}

resource "kubernetes_cluster_role" "release_name_admission" {
  metadata {
    name = "release-name-admission"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["get", "list", "create", "delete"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["create", "update"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests/approval"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["queues"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["podgroups"]
  }
}

resource "kubernetes_cluster_role" "release_name_agent" {
  metadata {
    name = "release-name-agent"

    labels = {
      app = "volcano-agent"
    }
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/eviction"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["list", "watch", "create", "update", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }
}

resource "kubernetes_cluster_role" "release_name_controllers" {
  metadata {
    name = "release-name-controllers"
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "delete"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs/status", "jobs/finalizers"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["cronjobs"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["cronjobs/status", "cronjobs/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "delete"]
    api_groups = ["bus.volcano.sh"]
    resources  = ["commands"]
  }

  rule {
    verbs      = ["create", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "delete", "patch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = [""]
    resources  = ["pods/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create"]
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["get", "create", "delete", "update"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update", "patch"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["podgroups", "queues", "queues/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update"]
    api_groups = ["flow.volcano.sh"]
    resources  = ["jobflows", "jobtemplates"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["flow.volcano.sh"]
    resources  = ["jobflows/status", "jobs/finalizers", "jobtemplates/status", "jobtemplates/finalizers"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete"]
    api_groups = ["scheduling.k8s.io"]
    resources  = ["priorityclasses"]
  }

  rule {
    verbs      = ["get", "create", "delete"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["apps"]
    resources  = ["daemonsets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["apps"]
    resources  = ["replicasets", "statefulsets"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["get", "create", "update", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["list", "watch", "get", "create", "delete", "update", "patch"]
    api_groups = ["topology.volcano.sh"]
    resources  = ["hypernodes", "hypernodes/status"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["nodes"]
  }
}

resource "kubernetes_cluster_role" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "secrets", "nodes", "pods", "services", "resourcequotas", "replicationcontrollers", "limitranges", "persistentvolumeclaims", "persistentvolumes", "namespaces", "endpoints"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployments", "replicasets", "ingresses"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["statefulsets", "daemonsets", "deployments", "replicasets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "volumeattachments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
  }
}

resource "kubernetes_cluster_role" "prometheus_volcano" {
  metadata {
    name = "prometheus-volcano"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["ingresses"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role" "release_name_scheduler" {
  metadata {
    name = "release-name-scheduler"
  }

  rule {
    verbs      = ["create", "get", "list", "watch", "delete"]
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs/status"]
  }

  rule {
    verbs      = ["create", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch", "patch", "delete"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["update"]
    api_groups = [""]
    resources  = ["pods/status"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/binding"]
  }

  rule {
    verbs      = ["list", "watch", "update"]
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
  }

  rule {
    verbs      = ["list", "watch", "update"]
    api_groups = [""]
    resources  = ["persistentvolumes"]
  }

  rule {
    verbs      = ["list", "watch", "get"]
    api_groups = [""]
    resources  = ["namespaces", "services", "replicationcontrollers"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["resourcequotas"]
  }

  rule {
    verbs      = ["get", "list", "watch", "update", "patch"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities", "volumeattachments"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["scheduling.k8s.io"]
    resources  = ["priorityclasses"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "update"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["queues"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["queues/status"]
  }

  rule {
    verbs      = ["list", "watch", "update"]
    api_groups = ["scheduling.incubator.k8s.io", "scheduling.volcano.sh"]
    resources  = ["podgroups"]
  }

  rule {
    verbs      = ["get", "list", "watch", "delete"]
    api_groups = ["nodeinfo.volcano.sh"]
    resources  = ["numatopologies"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["topology.volcano.sh"]
    resources  = ["hypernodes", "hypernodes/status"]
  }

  rule {
    verbs      = ["get", "create", "delete", "update"]
    api_groups = [""]
    resources  = ["configmaps"]
  }

  rule {
    verbs      = ["list", "watch", "get"]
    api_groups = ["apps"]
    resources  = ["daemonsets", "replicasets", "statefulsets"]
  }

  rule {
    verbs      = ["get", "create", "update", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
    api_groups = ["resource.k8s.io"]
    resources  = ["resourceclaims"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["resource.k8s.io"]
    resources  = ["resourceclaims/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create"]
    api_groups = ["resource.k8s.io"]
    resources  = ["deviceclasses", "resourceslices"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["resource.k8s.io"]
    resources  = ["devicetaintrules"]
  }
}

resource "kubernetes_cluster_role" "vcjob_editor_role" {
  metadata {
    name = "vcjob-editor-role"
  }

  rule {
    verbs      = ["create", "get", "list", "update", "delete"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["create", "get", "list"]
    api_groups = ["bus.volcano.sh"]
    resources  = ["commands"]
  }
}

resource "kubernetes_cluster_role" "vcjob_viewer_role" {
  metadata {
    name = "vcjob-viewer-role"
  }

  rule {
    verbs      = ["get", "list"]
    api_groups = ["batch.volcano.sh"]
    resources  = ["jobs"]
  }
}

resource "kubernetes_cluster_role_binding" "release_name_admission_role" {
  metadata {
    name = "release-name-admission-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-admission"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-admission"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_agent_role" {
  metadata {
    name = "release-name-agent-role"
    labels = {
      app = "volcano-agent"
    }
  }
  subject {
    kind      = "ServiceAccount"
    name      = "release-name-agent"
    namespace = "volcano"
  }
  subject {
    kind      = "User"
    api_group = "rbac.authorization.k8s.io"
    name      = "release-name-agent"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-agent"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_controllers_role" {
  metadata {
    name = "release-name-controllers-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-controllers"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-controllers"
  }
}

resource "kubernetes_cluster_role_binding" "kube_state_metrics" {
  metadata {
    name = "kube-state-metrics"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kube-state-metrics"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube-state-metrics"
  }
}

resource "kubernetes_cluster_role_binding" "prometheus_volcano" {
  metadata {
    name = "prometheus-volcano"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus-volcano"
  }
}

resource "kubernetes_cluster_role_binding" "release_name_scheduler_role" {
  metadata {
    name = "release-name-scheduler-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-scheduler"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "release-name-scheduler"
  }
}

resource "kubernetes_service" "release_name_admission_service" {
  metadata {
    name      = "release-name-admission-service"
    namespace = "volcano"

    labels = {
      app = "volcano-admission"
    }
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 443
      target_port = "8443"
    }

    selector = {
      app = "volcano-admission"
    }

    session_affinity = "None"
  }
}

resource "kubernetes_service" "release_name_controllers_service" {
  metadata {
    name      = "release-name-controllers-service"
    namespace = "volcano"

    labels = {
      app = "volcano-controller"
    }

    annotations = {
      "prometheus.io/path"   = "/metrics"
      "prometheus.io/port"   = "8081"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 8081
      target_port = "8081"
    }

    selector = {
      app = "volcano-controller"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "volcano"

    annotations = {
      "prometheus.io/port"   = "3000"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 3000
      target_port = "3000"
      node_port   = 30004
    }

    selector = {
      app = "grafana"
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "volcano"

    labels = {
      "app.kubernetes.io/name" = "kube-state-metrics"
    }

    annotations = {
      "prometheus.io/path"   = "/metrics"
      "prometheus.io/port"   = "8080"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      port        = 8080
      target_port = "http-metrics"
    }

    port {
      name        = "telemetry"
      port        = 8081
      target_port = "telemetry"
    }

    selector = {
      k8s-app = "kube-state-metrics"
    }
  }
}

resource "kubernetes_service" "prometheus_service" {
  metadata {
    name      = "prometheus-service"
    namespace = "volcano"

    annotations = {
      "prometheus.io/port"   = "9090"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 8080
      target_port = "9090"
      node_port   = 30003
    }

    selector = {
      app = "prometheus-server"
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "release_name_scheduler_service" {
  metadata {
    name      = "release-name-scheduler-service"
    namespace = "volcano"

    labels = {
      app = "volcano-scheduler"
    }

    annotations = {
      "prometheus.io/path"   = "/metrics"
      "prometheus.io/port"   = "8080"
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      app = "volcano-scheduler"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_daemonset" "release_name_agent" {
  metadata {
    name      = "release-name-agent"
    namespace = "volcano"
  }

  spec {
    selector {
      match_labels = {
        name = "volcano-agent"
      }
    }

    template {
      metadata {
        name = "volcano-agent"

        labels = {
          name = "volcano-agent"
        }

        annotations = {
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/port"   = "3300"
          "prometheus.io/scheme" = "http"
          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        volume {
          name = "bwm-dir"

          host_path {
            path = "/usr/share/bwmcli/"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "cni-plugin-dir"

          host_path {
            path = "/opt/cni/bin"
            type = "Directory"
          }
        }

        volume {
          name = "host-etc"

          host_path {
            path = "/etc"
            type = "Directory"
          }
        }

        volume {
          name = "host-sys-fs"

          host_path {
            path = "/sys/fs"
            type = "Directory"
          }
        }

        volume {
          name = "host-proc-sys"

          host_path {
            path = "/proc/sys"
            type = "Directory"
          }
        }

        volume {
          name = "log"

          host_path {
            path = "/var/log/volcano/agent"
          }
        }

        volume {
          name = "localtime"

          host_path {
            path = "/etc/localtime"
          }
        }

        volume {
          name = "kubelet-cpu-manager-policy"

          host_path {
            path = "/var/lib/kubelet/"
          }
        }

        volume {
          name = "proc-stat"

          host_path {
            path = "/proc/stat"
            type = "File"
          }
        }

        init_container {
          name    = "volcano-agent-init"
          image   = "docker.io/volcanosh/vc-agent:v1.13.0"
          command = ["/bin/sh", "-c", "/usr/local/bin/install.sh"]

          volume_mount {
            name       = "bwm-dir"
            mount_path = "/usr/share/bwmcli"
          }

          volume_mount {
            name       = "cni-plugin-dir"
            mount_path = "/opt/cni/bin"
          }

          volume_mount {
            name       = "host-etc"
            mount_path = "/host/etc"
          }

          volume_mount {
            name       = "log"
            mount_path = "/var/log/volcano/agent"
          }

          volume_mount {
            name       = "host-proc-sys"
            mount_path = "/host/proc/sys"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["CHOWN", "DAC_OVERRIDE", "FOWNER"]
              drop = ["ALL"]
            }

            run_as_user = 0
          }
        }

        container {
          name    = "volcano-agent"
          image   = "docker.io/volcanosh/vc-agent:v1.13.0"
          command = ["/bin/sh", "-c", "/vc-agent \\\n--v=2 1>> /var/log/volcano/agent/volcano-agent.log 2>&1\n"]

          env {
            name  = "SYS_FS_PATH"
            value = "/host/sys/fs"
          }

          env {
            name  = "CNI_CONF_FILE_PATH"
            value = "/host/etc/cni/net.d/cni.conflist"
          }

          env {
            name = "KUBE_NODE_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "spec.nodeName"
              }
            }
          }

          env {
            name = "KUBE_POD_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }

          env {
            name = "KUBE_POD_NAMESPACE"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.namespace"
              }
            }
          }

          volume_mount {
            name       = "bwm-dir"
            mount_path = "/usr/share/bwmcli"
          }

          volume_mount {
            name       = "cni-plugin-dir"
            mount_path = "/opt/cni/bin"
          }

          volume_mount {
            name       = "host-etc"
            mount_path = "/host/etc"
          }

          volume_mount {
            name       = "log"
            mount_path = "/var/log/volcano/agent"
          }

          volume_mount {
            name              = "host-sys-fs"
            mount_path        = "/host/sys/fs"
            mount_propagation = "HostToContainer"
          }

          volume_mount {
            name       = "host-proc-sys"
            mount_path = "/host/proc/sys"
          }

          volume_mount {
            name       = "localtime"
            read_only  = true
            mount_path = "/etc/localtime"
          }

          volume_mount {
            name       = "kubelet-cpu-manager-policy"
            read_only  = true
            mount_path = "/var/lib/kubelet"
          }

          volume_mount {
            name       = "proc-stat"
            read_only  = true
            mount_path = "/host/proc/stat"
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "3300"
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 5
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              add  = ["DAC_OVERRIDE", "SETUID", "SETGID", "SETFCAP", "BPF"]
              drop = ["ALL"]
            }

            run_as_user     = 1000
            run_as_non_root = true
          }
        }

        restart_policy       = "Always"
        dns_policy           = "Default"
        service_account_name = "release-name-agent"
        host_network         = true

        security_context {
          se_linux_option {
            level = "s0:c123,c456"
          }

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        toleration {
          key      = "volcano.sh/offline-job-evicting"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        priority_class_name = "system-node-critical"
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "10%"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_deployment" "release_name_admission" {
  metadata {
    name      = "release-name-admission"
    namespace = "volcano"

    labels = {
      app = "volcano-admission"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "volcano-admission"
      }
    }

    template {
      metadata {
        labels = {
          app = "volcano-admission"
        }

        annotations = {
          "rollme/helm-revision" = "1"
        }
      }

      spec {
        volume {
          name = "admission-certs"

          secret {
            secret_name  = "volcano-admission-secret"
            default_mode = "0644"
          }
        }

        volume {
          name = "admission-config"

          config_map {
            name = "release-name-admission-configmap"
          }
        }

        container {
          name  = "admission"
          image = "docker.io/volcanosh/vc-webhook-manager:v1.13.0"
          args  = ["--enabled-admission=/jobs/mutate,/jobs/validate,/podgroups/validate,/queues/mutate,/queues/validate,/hypernodes/validate,/cronjobs/validate", "--tls-cert-file=/admission.local.config/certificates/tls.crt", "--tls-private-key-file=/admission.local.config/certificates/tls.key", "--ca-cert-file=/admission.local.config/certificates/ca.crt", "--admission-conf=/admission.local.config/configmap/volcano-admission.conf", "--webhook-namespace=volcano", "--webhook-service-name=release-name-admission-service", "--enable-healthz=true", "--logtostderr", "--port=8443", "-v=4", "2>&1"]

          volume_mount {
            name       = "admission-certs"
            read_only  = true
            mount_path = "/admission.local.config/certificates"
          }

          volume_mount {
            name       = "admission-config"
            mount_path = "/admission.local.config/configmap"
          }

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

        service_account_name = "release-name-admission"

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

resource "kubernetes_deployment" "release_name_controllers" {
  metadata {
    name      = "release-name-controllers"
    namespace = "volcano"

    labels = {
      app = "volcano-controller"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "volcano-controller"
      }
    }

    template {
      metadata {
        labels = {
          app = "volcano-controller"
        }
      }

      spec {
        container {
          name  = "release-name-controllers"
          image = "docker.io/volcanosh/vc-controller-manager:v1.13.0"
          args  = ["--logtostderr", "--enable-healthz=true", "--enable-metrics=true", "--leader-elect=true", "--leader-elect-resource-namespace=volcano", "--kube-api-qps=50", "--kube-api-burst=100", "--worker-threads=3", "--worker-threads-for-gc=5", "--worker-threads-for-podgroup=5", "-v=4", "2>&1"]

          env {
            name  = "KUBE_POD_NAMESPACE"
            value = "volcano"
          }

          env {
            name  = "HELM_RELEASE_NAME"
            value = "release-name"
          }

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

        service_account = "release-name-controllers"

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

resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "volcano"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        name = "grafana"

        labels = {
          app = "grafana"
        }
      }

      spec {
        volume {
          name      = "grafana-storage"
          empty_dir = {}
        }

        volume {
          name = "grafana-release-name-dashboard"

          config_map {
            name         = "grafana-release-name-dashboard"
            default_mode = "0644"
          }
        }

        volume {
          name = "grafana-datasources"

          config_map {
            name         = "grafana-datasources"
            default_mode = "0644"
          }
        }

        volume {
          name = "grafana-release-name-dashboard-config"

          config_map {
            name         = "grafana-release-name-dashboard-config"
            default_mode = "0644"
          }
        }

        container {
          name  = "grafana"
          image = "grafana/grafana:latest"

          port {
            name           = "grafana"
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "2Gi"
            }

            requests = {
              cpu    = "500m"
              memory = "1Gi"
            }
          }

          volume_mount {
            name       = "grafana-storage"
            mount_path = "/var/lib/grafana"
          }

          volume_mount {
            name       = "grafana-datasources"
            mount_path = "/etc/grafana/provisioning/datasources"
          }

          volume_mount {
            name       = "grafana-release-name-dashboard"
            mount_path = "/var/lib/grafana/dashboards"
          }

          volume_mount {
            name       = "grafana-release-name-dashboard-config"
            read_only  = true
            mount_path = "/etc/grafana/provisioning/dashboards"
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = "3000"
            }

            initial_delay_seconds = 10
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = "3000"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "kube_state_metrics" {
  metadata {
    name      = "kube-state-metrics"
    namespace = "volcano"

    labels = {
      k8s-app = "kube-state-metrics"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        k8s-app = "kube-state-metrics"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "kube-state-metrics"
        }
      }

      spec {
        container {
          name  = "kube-state-metrics"
          image = "docker.io/volcanosh/kube-state-metrics:v2.0.0-beta"

          port {
            name           = "http-metrics"
            container_port = 8080
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }

          image_pull_policy = "IfNotPresent"
        }

        dns_policy           = "ClusterFirst"
        service_account_name = "kube-state-metrics"
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    progress_deadline_seconds = 600
  }
}

resource "kubernetes_deployment" "prometheus_deployment" {
  metadata {
    name      = "prometheus-deployment"
    namespace = "volcano"

    labels = {
      app = "prometheus-server"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus-server"
        }
      }

      spec {
        volume {
          name = "prometheus-config-volume"

          config_map {
            name         = "prometheus-server-conf"
            default_mode = "0644"
          }
        }

        volume {
          name      = "prometheus-storage-volume"
          empty_dir = {}
        }

        container {
          name  = "prometheus"
          image = "prom/prometheus"
          args  = ["--config.file=/etc/prometheus/prometheus.yml", "--storage.tsdb.path=/prometheus/"]

          port {
            container_port = 9090
          }

          volume_mount {
            name       = "prometheus-config-volume"
            mount_path = "/etc/prometheus/"
          }

          volume_mount {
            name       = "prometheus-storage-volume"
            mount_path = "/prometheus/"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "release_name_scheduler" {
  metadata {
    name      = "release-name-scheduler"
    namespace = "volcano"

    labels = {
      app = "volcano-scheduler"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "volcano-scheduler"
      }
    }

    template {
      metadata {
        labels = {
          app = "volcano-scheduler"
        }
      }

      spec {
        volume {
          name = "scheduler-config"

          config_map {
            name = "release-name-scheduler-configmap"
          }
        }

        volume {
          name      = "klog-sock"
          empty_dir = {}
        }

        container {
          name  = "release-name-scheduler"
          image = "docker.io/volcanosh/vc-scheduler:v1.13.0"
          args  = ["--logtostderr", "--scheduler-conf=/volcano.scheduler/volcano-scheduler.conf", "--enable-healthz=true", "--enable-metrics=true", "--leader-elect=true", "--leader-elect-resource-namespace=volcano", "--kube-api-qps=2000", "--kube-api-burst=2000", "--schedule-period=1s", "--node-worker-threads=20", "-v=3", "2>&1"]

          env {
            name  = "DEBUG_SOCKET_DIR"
            value = "/tmp/klog-socks"
          }

          volume_mount {
            name       = "scheduler-config"
            mount_path = "/volcano.scheduler"
          }

          volume_mount {
            name       = "klog-sock"
            mount_path = "/tmp/klog-socks"
          }

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

        service_account = "release-name-scheduler"

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

resource "kubernetes_role" "release_name_admission_init" {
  metadata {
    name      = "release-name-admission-init"
    namespace = "volcano"

    annotations = {
      "helm.sh/hook"               = "pre-install,pre-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
      "helm.sh/hook-weight"        = "0"
    }
  }

  rule {
    verbs      = ["create", "patch", "get"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_role_binding" "release_name_admission_init_role" {
  metadata {
    name      = "release-name-admission-init-role"
    namespace = "volcano"

    annotations = {
      "helm.sh/hook"               = "pre-install,pre-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
      "helm.sh/hook-weight"        = "0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "release-name-admission-init"
    namespace = "volcano"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "release-name-admission-init"
  }
}

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

