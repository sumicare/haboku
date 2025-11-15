## Sumicare [Grafana Alloy](https://github.com/grafana/alloy) OpenTofu Modules

Deploys [Grafana Alloy](https://github.com/grafana/alloy) as a unified telemetry collector.

Grafana Alloy combines metrics, logs, traces, and profiles collection in a single agent with HCL-based configuration, supporting OpenTelemetry, Prometheus, Loki, and Pyroscope protocols while enabling dynamic pipeline composition and service discovery.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  alloy_version = "1.12.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "alloy_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-alloy/modules/alloy-image"
  debian_version = locals.debian_version
  alloy_version = locals.alloy_version

  depends_on = [module.debian_images]
}

module "alloy" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-alloy/modules/alloy-chart"
  alloy_version = locals.alloy_version

  depends_on = [module.alloy_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| alloy_version  | Alloy version to deploy         | string | `"1.12.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
