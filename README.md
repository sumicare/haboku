# Haboku (破墨)

[![Project License](https://img.shields.io/github/license/sumicare/opentofu-kubernetes-modules)](LICENSE)
[![Go Report Card](https://goreportcard.com/badge/github.com/sumicare/opentofu-kubernetes-modules/packages/sumicare-versioning)](https://goreportcard.com/report/github.com/sumicare/opentofu-kubernetes-modules/packages/sumicare-versioning)

Haboku — the splashed-ink technique of sumi-e painting — creates bold, expressive landscapes with fluid, dynamic strokes. In the spirit of this traditional art, Haboku provides a curated collection of OpenTofu modules for Reference Cloud Native Architecture (RCNA).

These modules offer precise, maintainable infrastructure provisioning as a robust alternative to Helm charts, ensuring reliable state management and drift detection. Designed for use with Terraform Stacks or Terragrunt.

Haboku forms the expressive foundation upon which the ikebana-inspired components of the Kachō ecosystem ([Rikka](https://github.com/sumicare/rikka), [Shōka](https://github.com/sumicare/shoka), [Moribana](https://github.com/sumicare/moribana), [Jiyuka](https://github.com/sumicare/jiyuka)) harmoniously arrange cluster resources.

## Modules

Each module includes detailed usage instructions and examples.

- **Base**: Debian distroless images
- **Development**: Atlas Operator, Dex IdP, Tekton (Pipelines, Dashboard, Triggers, Chains, Results)
- **GitOps**: Argo CD, Argo Events, Argo Rollouts, Argo Workflows
- **Messaging**: NATS
- **MLOps**: Ballista, KubeRay, OME, Volcano scheduler
- **Networking**: Calico, ExternalDNS, Gateway API, Linkerd2
- **Observability**: Alloy, Grafana (MCP), Loki, Mimir, Prometheus, Pyroscope, Tempo
- **Security**: Bank-Vaults, cert-manager, Falco, Kyverno, OpenFGA, Reloader
- **Storage**: CloudNativePG, Local Path Provisioner, PVC Autoresizer, RustFS, TopoLVM, Valkey Operator, Velero

## Development

Open the provided `.code-workspace` in VS Code, or other related editors, with the [DevContainer](https://containers.dev/), or install dependencies via [asdf](https://asdf-vm.com/).

## License

Copyright 2025 **[Sumicare](https://sumi.care)**

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](OSS_TERMS.md).

[Sumicare Haboku](https://sumi.care/haboku) library, and its components, are licensed under the terms of [Apache License, Version 2.0](LICENSE).
