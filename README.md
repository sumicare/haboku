## Sumicare Kubernetes OpenTofu Modules 🚀

[![Project License](https://img.shields.io/github/license/sumicare/opentofu-kubernetes-modules)](LICENSE)
[![Go Report Card](https://goreportcard.com/badge/github.com/sumicare/opentofu-kubernetes-modules/packages/sumicare-versioning)](https://goreportcard.com/report/github.com/sumicare/opentofu-kubernetes-modules/packages/sumicare-versioning)

[Українська](./doc/README.UA.md)

This is a collection of OpenTofu modules for the Reference Cloud Native Architecture (**[RCNA](RCNA.md)**), replacing widespread Helm Charts.

This project is designed to be used either with [Terraform Stacks](https://www.terraform.io/language/stacks) or with [Terragrunt](https://terragrunt.gruntwork.io/) and [OpenTofu](https://opentofu.io/).

All docker images are built using a custom [Debian Distroless](./packages/debian/modules/debian-images/Dockerfile.distroless) base image. <br/>
We don't have any plans for FIPS support, at the moment.

**tldr;** 
 - Helm Charts do not provide complete off-the-shelf experience
 - Community charts often face maintenance challenges (e.g., [Bitnami maintenance status](https://github.com/bitnami/charts/issues/35164))
 - Helm drift detection can be unreliable due to Server-Side Apply and 3-way merge complexity (see [known issues](https://enix.io/en/blog/helm-4/))
 - [Infracost](https://github.com/infracost/infracost) lost traction and [DriftCtl](https://github.com/snyk/driftctl) is mostly dead, as well
 - Lack of a single source of truth for infrastructure state leads to complex circular dependencies
 - Achieving proper Drift Detection and true Stateless Infrastructure is difficult with traditional approaches, limiting effective DevOps practices

While Terraform/OpenTofu has its own trade-offs, we believe it offers the most robust solution for state management available today.
Sumicare believes the real value of Platform Engineering lies in sustainable open source and shared responsibility.
This project shares our practical solutions for cloud-native infrastructure management, and cost-efficient operation.

We are working on a comprehensive compute plane plumbing solution [tofuslicer](https://github.com/sumicare/tofuslicer), to provide "of the shelf" autoscaling experience for Kubernetes.

### Usage 📦

All terraform modules contain a `README.md` file with usage instructions, and examples.

 - **Base**: [Debian](https://www.debian.org/) distroless [image modules](./packages/debian/)
 - **Development**: [Atlas Operator](./packages/development-atlas-operator/), [Dex](https://dexidp.io/) [IdP](./packages/development-dex/), [Tekton](https://tekton.dev/) ([Pipeline](./packages/development-tekton-pipeline/), [Dashboard](./packages/development-tekton-dashboard/), [Triggers](./packages/development-tekton-triggers/), [Chains](./packages/development-tekton-chains/), [Results](./packages/development-tekton-results/))
 - **GitOps**: [Argo CD](./packages/gitops-argo-cd/), [Argo Events](./packages/gitops-argo-events/), [Argo Rollouts](./packages/gitops-argo-rollouts/), [Argo Workflows](./packages/gitops-argo-workflows/)
 - **Messaging**: [NATS](./packages/messaging-nats/)
 - **MLOps**: [Ballista](./packages/mlops-data-fusion-ballista/), [KubeRay](./packages/mlops-kuberay/), [OME](./packages/mlops-ome/), [Volcano](./packages/mlops-volcano/) scheduler
 - **Networking**: [Calico](./packages/networking-calico/), [ExternalDNS](./packages/networking-external-dns/), [Gateway API](./packages/networking-gateway-api/), [Linkerd2](./packages/networking-linkerd/)
 - **Observability**: [Alloy](./packages/observability-alloy/), [Grafana](./packages/observability-grafana/) ([MCP](./packages/observability-grafana-mcp/)), [Loki](./packages/observability-loki/), [Mimir](./packages/observability-mimir/), [Prometheus](./packages/observability-prometheus/), [Pyroscope](./packages/observability-pyroscope/), [Tempo](./packages/observability-tempo/)
 - **Security**: [Bank-Vaults](./packages/security-bank-vaults/), [cert-manager](./packages/security-cert-manager/), [Falco](./packages/security-falco/), [Kyverno](./packages/security-kyverno/), [OpenFGA](./packages/security-openfga/), [Reloader](./packages/security-reloader/)
 - **Storage**: [CloudNativePG](./packages/storage-cnpg/), [Local Path Provisioner](./packages/storage-local-path-provisioner/), [PVC Autoresizer](./packages/storage-pvc-autoresizer/), [RustFS](./packages/storage-rustfs/), [TopoLVM](./packages/storage-topolvm/), [Valkey](./packages/storage-valkey-operator), [Velero](./packages/storage-velero/)

**Note:** These modules are designed for teams with at least a **[Competent level](https://link.springer.com/article/10.1007/s10270-025-01309-x#Sec2)** (Manageable level) of Organizational Maturity.

### Development 🛠️

Open [.code-workspace](sumicare-kubernetes.code-workspace) file in [VSCode](https://code.visualstudio.com/), use provided [Dev Container](https://code.visualstudio.com/docs/devcontainers/containers) for local development.

You can install all the dependencies and tools using [asdf](https://asdf-vm.com/), manually, as well.

See [DEVELOPMENT.md](DEVELOPMENT.md) for `a more detailed explanation`...

### Values 📏

See [CONVENTIONS.md](CONVENTIONS.md) and [VALUES.md](VALUES.md) for `why it is the way it is`...

### License 📜

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules are licensed under the terms of [Apache License, Version 2.0](LICENSE).
