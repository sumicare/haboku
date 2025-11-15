## Sumicare [Pyroscope](https://github.com/grafana/pyroscope) OpenTofu Modules

Deploys [Pyroscope](https://github.com/grafana/pyroscope) for continuous profiling and performance analysis.

Grafana Pyroscope captures CPU, memory, and goroutine profiles with minimal overhead, enabling flame graph visualization to identify performance bottlenecks, memory leaks, and optimization opportunities in production workloads.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  pyroscope_version = "{{index .Versions "observability-pyroscope"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "pyroscope_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-pyroscope/modules/pyroscope-image"
  debian_version = locals.debian_version
  pyroscope_version = locals.pyroscope_version

  depends_on = [module.debian_images]
}

module "pyroscope" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-pyroscope/modules/pyroscope-chart"
  pyroscope_version = locals.pyroscope_version

  depends_on = [module.pyroscope_image]
}
```

### Parameters

| Name              | Description                     | Type   | Default                  | Required   |
|-------------------|---------------------------------|--------|--------------------------|------------|
| debian_version    | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| pyroscope_version | Pyroscope version to deploy     | string | `"{{index .Versions "observability-pyroscope"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
