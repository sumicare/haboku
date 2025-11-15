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


resource "kubernetes_config_map" "inferenceservice_config" {
  metadata {
    name      = "inferenceservice-config"
    namespace = "ome"
  }

  data = {
    deploy            = "{\n  \"defaultDeploymentMode\": \"RawDeployment\"\n}"
    ingress           = "{\n    \"ingressGateway\" : \"knative-serving/knative-ingress-gateway\",\n    \"ingressService\" : \"istio-ingressgateway.istio-system.svc.cluster.local\",\n    \"localGateway\" : \"knative-serving/knative-local-gateway\",\n    \"localGatewayService\" : \"knative-local-gateway.istio-system.svc.cluster.local\",\n    \"knativeLocalGatewayService\" : \"knative-local-gateway.istio-system.svc.cluster.local\",\n    \"omeIngressGateway\" : \"\",\n    \"ingressDomain\"  : \"svc.cluster.local\",\n    \"ingressClassName\" : \"istio\",\n    \"additionalIngressDomains\" : null,\n    \"domainTemplate\": \"{{ .Name }}.{{ .Namespace }}.{{ .IngressDomain }}\",\n    \"urlScheme\": \"http\",\n    \"disableIstioVirtualHost\": false,\n    \"pathTemplate\": \"\",\n    \"disableIngressCreation\": false,\n    \"enableGatewayAPI\": false\n}"
    kedaConfig        = "{\n  \"enableKeda\" : true,\n  \"promServerAddress\": \"http://prometheus-operated.monitoring.svc.cluster.local:9090\",\n  \"customPromQuery\": \"\",\n  \"scalingThreshold\": \"10\",\n  \"scalingOperator\": \"GreaterThanOrEqual\"\n}"
    metricsAggregator = "{\n  \"enableMetricAggregation\": \"false\",\n  \"enablePrometheusScraping\" : \"false\"\n}"
    modelInit         = "{\n    \"image\":  \"ghcr.io/moirai-internal/ome-agent:v0.1.2\",\n    \"memoryRequest\": \"150Gi\",\n    \"memoryLimit\": \"180Gi\",\n    \"cpuRequest\": \"15\",\n    \"cpuLimit\": \"15\",\n    \"compartmentId\": \"ocid1.compartment.oc1..dummy-compartment\",\n    \"authType\" : \"InstancePrincipal\",\n    \"vaultId\": \"ocid1.vault.oc1.ap-osaka-1.dummy.dummy-vault\",\n    \"region\": \"ap-osaka-1\"\n}"
    multinodeProber   = "{\n    \"image\": \"ghcr.io/moirai-internal/multinode-prober:v0.1\",\n    \"memoryRequest\": \"100Mi\",\n    \"memoryLimit\": \"100Mi\",\n    \"cpuRequest\": \"100m\",\n    \"cpuLimit\": \"100m\",\n    \"startupFailureThreshold\": 150,\n    \"startupPeriodSeconds\": 30,\n    \"startupTimeoutSeconds\": 60,\n    \"startupInitialDelaySeconds\": 120,\n    \"unavailableThresholdSeconds\": 600\n}"
    servingSidecar    = "{\n    \"image\": \"ghcr.io/moirai-internal/ome-agent:v0.1.2\",\n    \"memoryRequest\": \"2Gi\",\n    \"memoryLimit\": \"4Gi\",\n    \"cpuRequest\": \"1\",\n    \"cpuLimit\": \"2\",\n    \"compartmentId\": \"ocid1.compartment.oc1..dummy-compartment\",\n    \"authType\" : \"InstancePrincipal\",\n    \"region\": \"ap-osaka-1\"\n}"
  }
}

resource "kubernetes_config_map" "benchmarkjob_config" {
  metadata {
    name      = "benchmarkjob-config"
    namespace = "ome"
  }

  data = {
    benchmarkjob = "{\n  \"podConfig\": {\n    \"image\": \"ghcr.io/moirai-internal/genai-bench:0.1.113\",\n    \"cpuRequest\": \"2\",\n    \"memoryRequest\": \"2Gi\",\n    \"cpuLimit\": \"2\",\n    \"memoryLimit\": \"2Gi\"\n  }\n}\n"
  }
}

