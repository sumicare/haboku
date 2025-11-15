## Sumicare [Prometheus](https://github.com/prometheus/prometheus) OpenTofu Modules

Deploys [Prometheus](https://github.com/prometheus/prometheus) for pull-based metrics collection and alerting.

Prometheus scrapes metrics from instrumented applications and infrastructure, storing time-series data with a powerful query language (PromQL) and integrating with Alertmanager for flexible notification routing based on metric thresholds.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  prometheus_version = "3.8.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "prometheus_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-prometheus/modules/prometheus-image"
  debian_version = locals.debian_version
  prometheus_version = locals.prometheus_version

  depends_on = [module.debian_images]
}

module "prometheus" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-prometheus/modules/prometheus-chart"
  prometheus_version = locals.prometheus_version

  depends_on = [module.prometheus_image]
}
```

### Parameters

| Name               | Description                     | Type   | Default                  | Required   |
|--------------------|---------------------------------|--------|--------------------------|------------|
| debian_version     | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| prometheus_version | Prometheus version to deploy    | string | `"3.8.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
