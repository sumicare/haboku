## Sumicare [Velero](https://github.com/vmware-tanzu/velero) OpenTofu Modules

This module deploys [Velero](https://github.com/vmware-tanzu/velero) to the cluster.

Velero is an open source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  velero_version = "1.17.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "velero_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-velero/modules/velero-image"
  debian_version = locals.debian_version
  velero_version = locals.velero_version

  depends_on = [module.debian_images]
}

module "velero" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-velero/modules/velero-chart"
  velero_version = locals.velero_version

  depends_on = [module.velero_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| velero_version | Velero version to deploy        | string | `"1.17.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
