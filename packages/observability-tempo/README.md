## Sumicare [Tempo](https://github.com/grafana/tempo) OpenTofu Modules

Deploys [Tempo](https://github.com/grafana/tempo) for cost-effective distributed tracing.

Grafana Tempo stores traces in object storage without indexing, dramatically reducing costs while supporting OpenTelemetry, Jaeger, and Zipkin formats with trace-to-logs/metrics correlation in Grafana for end-to-end request debugging.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  tempo_version = "2.9.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "tempo_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-tempo/modules/tempo-image"
  debian_version = locals.debian_version
  tempo_version = locals.tempo_version

  depends_on = [module.debian_images]
}

module "tempo" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-tempo/modules/tempo-chart"
  tempo_version = locals.tempo_version

  depends_on = [module.tempo_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| tempo_version  | Tempo version to deploy         | string | `"2.9.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
