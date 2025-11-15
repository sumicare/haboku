## Sumicare Kubernetes OpenTofu Модулі 🚀

[![Project License](https://img.shields.io/github/license/sumicare/opentofu-kubernetes-modules)](../LICENSE)
[![Go Report Card](https://goreportcard.com/badge/github.com/sumicare/opentofu-kubernetes-modules/packages/sumicare-versioning)](https://goreportcard.com/report/github.com/sumicare/opentofu-kubernetes-modules/packages/sumicare-versioning)

[English](../README.md)

Це колекція OpenTofu модулів для Референсної Хмарно-Нативної Архітектури (**[RCNA](RCNA.UA.md)**), що замінює поширені Helm Charts.

Цей проєкт призначений для використання з [Terraform Stacks](https://www.terraform.io/language/stacks) або з [Terragrunt](https://terragrunt.gruntwork.io/) та [OpenTofu](https://opentofu.io/).

Усі docker-образи створюються з використанням власного базового образу [Debian Distroless](../packages/debian/modules/debian-images/Dockerfile.distroless). <br/>
Наразі ми не плануємо підтримку FIPS.

**Коротко:** 
 - Helm-чарти не дають повністю готового рішення «з коробки»
 - Спільнота чартів часто стикається з проблемами підтримки (напр., [статус підтримки Bitnami](https://github.com/bitnami/charts/issues/35164))
 - Виявлення дрифту в Helm може бути ненадійним через складність Server-Side Apply та 3-way merge (див. [відомі проблеми](https://enix.io/en/blog/helm-4/))
 - Розвиток [Infracost](https://github.com/infracost/infracost) сповільнився, а [DriftCtl](https://github.com/snyk/driftctl) майже не розвивається
 - Відсутність єдиного джерела істини для стану інфраструктури призводить до складних циклічних залежностей
 - Досягнення належного виявлення дрифту та справді безстанної інфраструктури є складним при традиційних підходах, що обмежує ефективні DevOps-практики

Хоча Terraform/OpenTofu має свої компроміси, ми вважаємо, що він пропонує найнадійніше рішення для управління станом на сьогодні.
Sumicare вірить, що справжня цінність Platform Engineering полягає в сталому відкритому коді та спільній відповідальності.
Цей проєкт ділиться нашими практичними рішеннями для управління хмарно-нативною інфраструктурою та економічно ефективної експлуатації.

Ми працюємо над комплексним рішенням для compute plane [tofuslicer](https://github.com/sumicare/tofuslicer), щоб забезпечити готовий досвід автомасштабування для Kubernetes.

### Використання 📦

Усі terraform-модулі містять файл `README.md` з інструкціями та прикладами використання.

 - **Base**: [Debian](https://www.debian.org/) distroless [модулі образів](../packages/debian/)
 - **Development**: [Atlas Operator](../packages/development-atlas-operator/), [Dex](https://dexidp.io/) [IdP](../packages/development-dex/), [Tekton](https://tekton.dev/) ([Pipeline](../packages/development-tekton-pipeline/), [Dashboard](../packages/development-tekton-dashboard/), [Triggers](../packages/development-tekton-triggers/), [Chains](../packages/development-tekton-chains/), [Results](../packages/development-tekton-results/))
 - **GitOps**: [Argo CD](../packages/gitops-argo-cd/), [Argo Events](../packages/gitops-argo-events/), [Argo Rollouts](../packages/gitops-argo-rollouts/), [Argo Workflows](../packages/gitops-argo-workflows/)
 - **Messaging**: [NATS](../packages/messaging-nats/)
 - **MLOps**: [Ballista](../packages/mlops-data-fusion-ballista/), [KubeRay](../packages/mlops-kuberay/), [OME](../packages/mlops-ome/), [Volcano](../packages/mlops-volcano/) scheduler
 - **Networking**: [Calico](../packages/networking-calico/), [ExternalDNS](../packages/networking-external-dns/), [Gateway API](../packages/networking-gateway-api/), [Linkerd2](../packages/networking-linkerd/)
 - **Observability**: [Alloy](../packages/observability-alloy/), [Grafana](../packages/observability-grafana/) ([MCP](../packages/observability-grafana-mcp/)), [Loki](../packages/observability-loki/), [Mimir](../packages/observability-mimir/), [Prometheus](../packages/observability-prometheus/), [Pyroscope](../packages/observability-pyroscope/), [Tempo](../packages/observability-tempo/)
 - **Security**: [Bank-Vaults](../packages/security-bank-vaults/), [cert-manager](../packages/security-cert-manager/), [Falco](../packages/security-falco/), [Kyverno](../packages/security-kyverno/), [OpenFGA](../packages/security-openfga/), [Reloader](../packages/security-reloader/)
 - **Storage**: [CloudNativePG](../packages/storage-cnpg/), [Local Path Provisioner](../packages/storage-local-path-provisioner/), [PVC Autoresizer](../packages/storage-pvc-autoresizer/), [RustFS](../packages/storage-rustfs/), [TopoLVM](../packages/storage-topolvm/), [Valkey](../packages/storage-valkey-operator), [Velero](../packages/storage-velero/)

**Примітка:** Ці модулі призначені для команд з принаймні **[Компетентним рівнем](https://link.springer.com/article/10.1007/s10270-025-01309-x#Sec2)** (Керованим рівнем) Організаційної Зрілості.

### Розробка 🛠️

Відкрийте [.code-workspace](sumicare-kubernetes.code-workspace) у [VSCode](https://code.visualstudio.com/), використовуйте наданий [Dev Container](https://code.visualstudio.com/docs/devcontainers/containers) для локальної розробки.

Ви також можете встановити всі залежності та інструменти вручну за допомогою [asdf](https://asdf-vm.com/).

Дивіться [DEVELOPMENT.UA.md](DEVELOPMENT.UA.md) для `детальнішого пояснення`...

### Цінності 📏

Читайте [CONVENTIONS.UA.md](CONVENTIONS.UA.md) та [VALUES.UA.md](VALUES.UA.md) для пояснення `чому все саме так`...

### Ліцензія 📜

Copyright 2025 Sumicare

Використовуючи цей проєкт в академічних, рекламних, корпоративних чи будь-яких інших цілях, <br/>
ви надаєте свою **Неявну Згоду** з [Умовами Використання](OSS_TERMS.UA.md) Sumicare OSS.

Sumicare Kubernetes OpenTofu Модулі ліцензовані на умовах [Apache License, Version 2.0](LICENSE).
