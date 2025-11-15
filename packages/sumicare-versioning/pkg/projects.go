//
// Copyright (c) 2025 Sumicare
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package pkg

// GetProjects returns the central registry of package configurations.
func GetProjects() map[string]ProjectConfig {
	return projects
}

// projects is the central registry of package configurations.
//
//nolint:gochecknoglobals // Registry map
var projects = map[string]ProjectConfig{
	"debian": {
		URL:     "debian",
		Fetcher: FetcherCustom,
		Custom:  GetDebianVersion,
	},
	"development-atlas-operator": {
		URL:     "https://github.com/ariga/atlas-operator.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-dex": {
		URL:     "https://github.com/dexidp/dex.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-gitea": {
		URL:     "https://github.com/go-gitea/gitea.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-tekton-chains": {
		URL:     "https://github.com/tektoncd/chains.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-tekton-dashboard": {
		URL:     "https://github.com/tektoncd/dashboard.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-tekton-pipeline": {
		URL:     "https://github.com/tektoncd/pipeline.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-tekton-results": {
		URL:     "https://github.com/tektoncd/results.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-tekton-triggers": {
		URL:     "https://github.com/tektoncd/triggers.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-theia": {
		URL:     "https://github.com/eclipse-theia/theia.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-theia-cloud": {
		URL:     "https://github.com/eclipse-theia/theia-cloud.git",
		Fetcher: FetcherGitHubReleases,
	},
	"development-theia-ide": {
		URL:     "https://github.com/eclipse-theia/theia-ide.git",
		Fetcher: FetcherGitHubTags,
	},
	"gitops-argo-cd": {
		URL:     "https://github.com/argoproj/argo-cd.git",
		Fetcher: FetcherGitHubReleases,
	},
	"gitops-argo-events": {
		URL:     "https://github.com/argoproj/argo-events.git",
		Fetcher: FetcherGitHubReleases,
	},
	"gitops-argo-rollouts": {
		URL:     "https://github.com/argoproj/argo-rollouts.git",
		Fetcher: FetcherGitHubReleases,
	},
	"gitops-argo-workflows": {
		URL:     "https://github.com/argoproj/argo-workflows.git",
		Fetcher: FetcherGitHubReleases,
	},
	"mlops-data-fusion-ballista": {
		URL:     "https://github.com/apache/datafusion-ballista.git",
		Fetcher: FetcherGitHubTags,
	},
	"mlops-kuberay": {
		URL:     "https://github.com/ray-project/kuberay.git",
		Fetcher: FetcherGitHubReleases,
	},
	"mlops-ome": {
		URL:     "https://github.com/sgl-project/ome.git",
		Fetcher: FetcherGitHubReleases,
	},
	"mlops-volcano": {
		URL:     "https://github.com/volcano-sh/volcano.git",
		Fetcher: FetcherGitHubReleases,
	},
	"messaging-nats": {
		URL:     "https://github.com/nats-io/k8s.git",
		Fetcher: FetcherGitHubTags,
		Prefix:  "v",
	},
	"messaging-nats-server": {
		URL:     "https://github.com/nats-io/nats-server.git",
		Fetcher: FetcherGitHubReleases,
	},
	"networking-calico": {
		URL:     "https://github.com/projectcalico/calico.git",
		Fetcher: FetcherGitHubReleases,
	},
	"networking-external-dns": {
		URL:     "https://github.com/kubernetes-sigs/external-dns.git",
		Fetcher: FetcherGitHubReleases,
	},
	"networking-gateway-api": {
		URL:     "https://github.com/kubernetes-sigs/gateway-api.git",
		Fetcher: FetcherGitHubReleases,
	},
	"networking-linkerd": {
		URL:     "https://github.com/linkerd/linkerd2.git",
		Fetcher: FetcherGitHubReleases,
		Prefix:  "edge-",
	},
	"observability-alloy": {
		URL:     "https://github.com/grafana/alloy.git",
		Fetcher: FetcherGitHubReleases,
	},
	"observability-grafana": {
		URL:     "https://github.com/grafana/grafana.git",
		Fetcher: FetcherGitHubReleases,
	},
	"observability-grafana-mcp": {
		URL:     "https://github.com/grafana/mcp-grafana.git",
		Fetcher: FetcherGitHubReleases,
	},
	"observability-loki": {
		URL:     "https://github.com/grafana/loki.git",
		Fetcher: FetcherGitHubTags,
	},
	"observability-mimir": {
		URL:     "https://github.com/grafana/mimir.git",
		Fetcher: FetcherGitHubReleases,
		Prefix:  "mimir-",
	},
	"observability-prometheus": {
		URL:     "https://github.com/prometheus/prometheus.git",
		Fetcher: FetcherGitHubReleases,
	},
	"observability-pyroscope": {
		URL:     "https://github.com/grafana/pyroscope.git",
		Fetcher: FetcherGitHubReleases,
	},
	"observability-tempo": {
		URL:     "https://github.com/grafana/tempo.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-bank-vaults-operator": {
		URL:     "https://github.com/bank-vaults/vault-operator.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-bank-vaults-webhook": {
		URL:     "https://github.com/bank-vaults/secrets-webhook.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-cert-manager": {
		URL:     "https://github.com/cert-manager/cert-manager.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-falco": {
		URL:     "https://github.com/falcosecurity/falco.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-kyverno": {
		URL:     "https://github.com/kyverno/kyverno.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-openbao": {
		URL:     "https://github.com/openbao/openbao.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-openfga": {
		URL:     "https://github.com/openfga/openfga.git",
		Fetcher: FetcherGitHubReleases,
	},
	"security-reloader": {
		URL:     "https://github.com/stakater/Reloader.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-cnpg": {
		URL:     "https://github.com/cloudnative-pg/cloudnative-pg.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-local-path-provisioner": {
		URL:     "https://github.com/rancher/local-path-provisioner.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-postgres": {
		URL:     "https://github.com/postgres/postgres.git",
		Fetcher: FetcherCustom,
		Custom:  GetPostgresVersion,
	},
	"storage-postgres-hypopg": {
		URL:     "https://github.com/HypoPG/hypopg.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-postgres-index-advisor": {
		URL:     "https://github.com/supabase/index_advisor.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-postgres-pg-repack": {
		URL:     "https://github.com/reorg/pg_repack.git",
		Fetcher: FetcherGitHubTags,
		Prefix:  "ver_",
	},
	"storage-postgres-pgaudit": {
		URL:     "https://github.com/pgaudit/pgaudit.git",
		Fetcher: FetcherGitHubTags,
	},
	"storage-postgres-pgmq": {
		URL:     "https://github.com/pgmq/pgmq.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-postgres-pgroonga": {
		URL:     "https://github.com/pgroonga/pgroonga.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-postgres-pgrouting": {
		URL:     "https://github.com/pgRouting/pgrouting.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-postgres-pgvector": {
		URL:     "https://github.com/pgvector/pgvector.git",
		Fetcher: FetcherGitHubTags,
	},
	"storage-postgres-pgx-ulid": {
		URL:     "https://github.com/pksunkara/pgx_ulid.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-postgres-rum": {
		URL:     "https://github.com/postgrespro/rum.git",
		Fetcher: FetcherGitHubTags,
	},
	"storage-pvc-autoresizer": {
		URL:     "https://github.com/topolvm/pvc-autoresizer.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-rustfs": {
		URL:     "https://github.com/rustfs/rustfs.git",
		Fetcher: FetcherCustom,
		Custom:  GetRustFSVersion,
	},
	"storage-topolvm": {
		URL:     "https://github.com/topolvm/topolvm.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-valkey": {
		URL:     "https://github.com/valkey-io/valkey.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-valkey-operator": {
		URL:     "https://github.com/sap/valkey-operator.git",
		Fetcher: FetcherGitHubReleases,
	},
	"storage-velero": {
		URL:     "https://github.com/vmware-tanzu/velero.git",
		Fetcher: FetcherGitHubReleases,
	},
}
