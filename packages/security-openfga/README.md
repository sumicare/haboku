## Sumicare [OpenFGA](https://github.com/openfga/openfga) OpenTofu Modules

This module deploys [OpenFGA](https://github.com/openfga/openfga) to the cluster.

OpenFGA is a high-performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  openfga_version = "1.11.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "openfga_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-openfga/modules/openfga-image"
  debian_version = locals.debian_version
  openfga_version = locals.openfga_version

  depends_on = [module.debian_images]
}

module "openfga" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-openfga/modules/openfga-chart"
  openfga_version = locals.openfga_version

  depends_on = [module.openfga_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| openfga_version | OpenFGA version to deploy       | string | `"1.11.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
