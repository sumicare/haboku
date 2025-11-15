## Sumicare [Mimir](https://github.com/grafana/mimir) OpenTofu Modules

Deploys [Mimir](https://github.com/grafana/mimir) for scalable long-term Prometheus storage.

Grafana Mimir provides unlimited cardinality, multi-tenant isolation, and global query views across Prometheus instances, with object storage backends (S3/GCS/Azure) enabling cost-effective retention of years of metrics data at scale.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  mimir_version = "3.0.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "mimir_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-mimir/modules/mimir-image"
  debian_version = locals.debian_version
  mimir_version = locals.mimir_version

  depends_on = [module.debian_images]
}

module "mimir" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-mimir/modules/mimir-chart"
  mimir_version = locals.mimir_version

  depends_on = [module.mimir_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| mimir_version  | Mimir version to deploy         | string | `"3.0.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
