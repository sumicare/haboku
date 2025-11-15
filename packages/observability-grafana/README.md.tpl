## Sumicare [Grafana](https://github.com/grafana/grafana) OpenTofu Modules

Deploys [Grafana](https://github.com/grafana/grafana) for unified observability visualization.

Grafana provides rich dashboards and alerting for metrics, logs, and traces from 100+ data sources, enabling correlation across Prometheus, Loki, Tempo, and cloud providers with team collaboration, RBAC, and enterprise SSO support.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  grafana_version = "{{index .Versions "observability-grafana"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "grafana_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-grafana/modules/grafana-image"
  debian_version = locals.debian_version
  grafana_version = locals.grafana_version

  depends_on = [module.debian_images]
}

module "grafana" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-grafana/modules/grafana-chart"
  grafana_version = locals.grafana_version

  depends_on = [module.grafana_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| grafana_version | Grafana version to deploy       | string | `"{{index .Versions "observability-grafana"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
