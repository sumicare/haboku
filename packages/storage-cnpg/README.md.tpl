## Sumicare [CloudNativePG](https://github.com/cloudnative-pg/cloudnative-pg) OpenTofu Modules

This module deploys [CloudNativePG](https://github.com/cloudnative-pg/cloudnative-pg) to the cluster.

CloudNativePG is a Kubernetes operator that covers the full lifecycle of a highly available PostgreSQL database cluster.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  cnpg_version = "{{index .Versions "storage-cnpg"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "cnpg_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-cnpg/modules/cnpg-image"
  debian_version = locals.debian_version
  cnpg_version = locals.cnpg_version

  depends_on = [module.debian_images]
}

module "cnpg" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-cnpg/modules/cnpg-chart"
  cnpg_version = locals.cnpg_version

  depends_on = [module.cnpg_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| cnpg_version   | CloudNativePG version to deploy | string | `"{{index .Versions "storage-cnpg"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
