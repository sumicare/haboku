## Reference Cloud Native Architecture

The Reference Cloud Native Architecture (RCNA) is a curated set of mature CNCF projects designed to provide a reliable, 
cost-effective, and secure foundation for running modern cloud-native applications.

It emphasizes:
- Well-defined best practices
- Complete observability
- Elimination of circular dependencies in continuous deployments and continuous provisioning
- Stateless infrastructure
- Cost-aware provisioning and predictive autoscaling
- Predictable Cost of Ownership
- Vendor neutrality

## RCNA consists of 

- **Base Images** — secure container foundations

  [Debian](https://www.debian.org/) provides minimal, secure base images.

- **Development Plane** — CI/CD, artifact management, and identity

  [Tekton Pipeline](https://github.com/tektoncd/pipeline) provides Kubernetes-native CI/CD building blocks.
  
  [Tekton Triggers](https://github.com/tektoncd/triggers) enables webhook-driven pipeline execution.
  
  [Tekton Chains](https://github.com/tektoncd/chains) signs artifacts and generates SLSA provenance.
  
  [Tekton Results](https://github.com/tektoncd/results) stores pipeline history in external backends.
  
  [Tekton Dashboard](https://github.com/tektoncd/dashboard) provides pipeline visualization.
  
  [Atlas Operator](https://github.com/ariga/atlas-operator) manages declarative database migrations.

  [Dex](https://github.com/dexidp/dex) federates identity providers into unified OIDC.

  [Gitea](https://github.com/go-gitea/gitea) provides lightweight self-hosted Git service.

- **GitOps Plane** — declarative delivery and workflow automation

  [Argo CD](https://github.com/argoproj/argo-cd) reconciles cluster state with Git repositories.

  [Argo Rollouts](https://github.com/argoproj/argo-rollouts) enables progressive delivery.

  [Argo Workflows](https://github.com/argoproj/argo-workflows) orchestrates complex job DAGs.

  [Argo Events](https://github.com/argoproj/argo-events) connects event sources to triggers.

- **MLOps Plane** — distributed computing and model serving

  [Volcano](https://github.com/volcano-sh/volcano) provides gang scheduling for ML workloads.

  [KubeRay](https://github.com/ray-project/kuberay) manages Ray clusters on Kubernetes.

  [DataFusion Ballista](https://github.com/apache/datafusion-ballista) provides distributed SQL.

  [OME](https://github.com/sgl-project/ome) serves LLMs with optimized inference.

- **Networking Plane** — CNI, service mesh, and traffic management

  [Calico](https://github.com/projectcalico/calico) provides CNI with network policy enforcement.

  [Gateway API](https://github.com/kubernetes-sigs/gateway-api) supersedes Ingress with expressive routing.

  [Linkerd](https://linkerd.io/) provides lightweight service mesh with automatic mTLS.

  [External DNS](https://github.com/kubernetes-sigs/external-dns) automates DNS record management.

- **Observability Plane** — metrics, logs, traces, and profiles

  [Prometheus](https://github.com/prometheus/prometheus) provides pull-based metrics collection.

  [Mimir](https://github.com/grafana/mimir) scales Prometheus to unlimited cardinality.

  [Loki](https://github.com/grafana/loki) provides cost-effective log aggregation.

  [Tempo](https://github.com/grafana/tempo) stores traces without indexing.

  [Pyroscope](https://github.com/grafana/pyroscope) enables continuous profiling.

  [Grafana](https://github.com/grafana/grafana) unifies observability visualization.

  [Grafana Alloy](https://github.com/grafana/alloy) collects all telemetry signals.

  [Grafana MCP](https://github.com/grafana/mcp-grafana) enables AI-assisted observability.

- **Security Plane** — secrets, certificates, policies, and runtime protection

  [cert-manager](https://github.com/cert-manager/cert-manager) automates TLS certificate lifecycle.

  [Bank-Vaults Operator](https://github.com/bank-vaults/vault-operator) manages Vault/[OpenBao](https://github.com/openbao/openbao) clusters.

  [Bank-Vaults Webhook](https://github.com/bank-vaults/secrets-webhook) injects Vault secrets.

  [OpenBao](https://github.com/openbao/openbao) provides open-source secrets management (Vault fork).

  [OpenFGA](https://github.com/openfga/openfga) provides fine-grained authorization.

  [Reloader](https://github.com/stakater/Reloader) triggers rollouts on ConfigMap/Secret changes.

  [Kyverno](https://github.com/kyverno/kyverno) enforces policies as Kubernetes CRDs.
 
  [Falco](https://github.com/falcosecurity/falco) detects runtime threats via syscall analysis.

- **Storage Plane** — persistent storage, object storage, and data systems

  [Local Path Provisioner](https://github.com/rancher/local-path-provisioner) enables node-local PVCs.

  [TopoLVM](https://github.com/topolvm/topolvm) provides LVM-based local storage with scheduling.

  [PVC Autoresizer](https://github.com/topolvm/pvc-autoresizer) expands volumes automatically.

  [Velero](https://github.com/vmware-tanzu/velero) provides backup and disaster recovery.

  [CloudNativePG](https://github.com/cloudnative-pg/cloudnative-pg) operates PostgreSQL clusters.

  [Valkey](https://github.com/valkey-io/valkey) provides Redis-compatible in-memory store (Redis fork).
