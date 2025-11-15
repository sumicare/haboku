locals {
  versions_json = jsondecode(file("${path.module}/../../../../versions.json"))

  debian_version = local.versions_json["debian"]

  atlas_operator_version   = local.versions_json["development-atlas-operator"]
  dex_version              = local.versions_json["development-dex"]
  tekton_chains_version    = local.versions_json["development-tekton-chains"]
  tekton_dashboard_version = local.versions_json["development-tekton-dashboard"]
  tekton_pipeline_version  = local.versions_json["development-tekton-pipeline"]
  tekton_results_version   = local.versions_json["development-tekton-results"]
  tekton_trigger_version   = local.versions_json["development-tekton-trigger"]
  theia_version            = local.versions_json["development-theia"]
  zot_version              = local.versions_json["development-zot"]

  argo_cd_version        = local.versions_json["gitops-argo-cd"]
  argo_events_version    = local.versions_json["gitops-argo-events"]
  argo_rollouts_version  = local.versions_json["gitops-argo-rollouts"]
  argo_workflows_version = local.versions_json["gitops-argo-workflows"]

  data_fusion_ballista_version = local.versions_json["mlops-data-fusion-ballista"]
  kuberay_version              = local.versions_json["mlops-kuberay"]
  ome_version                  = local.versions_json["mlops-ome"]
  volcano_version              = local.versions_json["mlops-volcano"]

  calico_version       = local.versions_json["networking-calico"]
  external_dns_version = local.versions_json["networking-external-dns"]
  gateway_api_version  = local.versions_json["networking-gateway-api"]
  linkerd_version      = local.versions_json["networking-linkerd"]

  alloy_version       = local.versions_json["observability-alloy"]
  grafana_version     = local.versions_json["observability-grafana"]
  grafana_mcp_version = local.versions_json["observability-grafana-mcp"]
  loki_version        = local.versions_json["observability-loki"]
  mimir_version       = local.versions_json["observability-mimir"]
  prometheus_version  = local.versions_json["observability-prometheus"]
  pyroscope_version   = local.versions_json["observability-pyroscope"]
  tempo_version       = local.versions_json["observability-tempo"]

  cert_manager_version     = local.versions_json["security-cert-manager"]
  external_secrets_version = local.versions_json["security-external-secrets"]
  falco_version            = local.versions_json["security-falco"]
  kyverno_version          = local.versions_json["security-kyverno"]
  openbao_version          = local.versions_json["security-openbao"]
  openfga_version          = local.versions_json["security-openfga"]
  reloader_version         = local.versions_json["security-reloader"]

  cnpg_version                   = local.versions_json["storage-cnpg"]
  local_path_provisioner_version = local.versions_json["storage-local-path-provisioner"]
  pvc_autoresizer_version        = local.versions_json["storage-pvc-autoresizer"]
  valkey_version                 = local.versions_json["storage-valkey"]
  velero_version                 = local.versions_json["storage-velero"]
}
