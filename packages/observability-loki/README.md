## Sumicare [Loki](https://github.com/grafana/loki) OpenTofu Modules

Deploys [Loki](https://github.com/grafana/loki) for cost-effective log aggregation.

Loki indexes only metadata (labels) rather than full text, dramatically reducing storage costs while enabling fast queries through label-based filtering and LogQL, with native Grafana integration for unified metrics-logs correlation.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  loki_version = "2.8.3"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "loki_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-loki/modules/loki-image"
  debian_version = locals.debian_version
  loki_version = locals.loki_version

  depends_on = [module.debian_images]
}

module "loki" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-loki/modules/loki-chart"
  loki_version = locals.loki_version

  depends_on = [module.loki_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| loki_version   | Loki version to deploy          | string | `"2.8.3"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
