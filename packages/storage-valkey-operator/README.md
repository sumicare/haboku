## Sumicare [Valkey Operator](https://github.com/sap/valkey-operator) OpenTofu Modules

This module deploys [Valkey Operator](https://github.com/sap/valkey-operator) to the cluster.

Valkey Operator is a Kubernetes operator for managing Valkey (Redis-compatible) clusters.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  valkey_version = "9.0.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "valkey_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-valkey/modules/valkey-image"
  debian_version = locals.debian_version
  valkey_version = locals.valkey_version

  depends_on = [module.debian_images]
}

module "valkey" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-valkey/modules/valkey-chart"
  valkey_version = locals.valkey_version

  depends_on = [module.valkey_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| valkey_version | Valkey version to deploy        | string | `"9.0.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
