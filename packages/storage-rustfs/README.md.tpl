## Sumicare [TopoLVM](https://github.com/topolvm/topolvm) OpenTofu Modules

This module deploys [TopoLVM](https://github.com/topolvm/topolvm) to the cluster.

TopoLVM is a CSI plugin using LVM for Kubernetes that provides dynamic provisioning of local storage.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  topolvm_version = "{{index .Versions "storage-topolvm"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "topolvm_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-topolvm/modules/topolvm-image"
  debian_version = locals.debian_version
  topolvm_version = locals.topolvm_version

  depends_on = [module.debian_images]
}

module "topolvm" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-topolvm/modules/topolvm-chart"
  topolvm_version = locals.topolvm_version

  depends_on = [module.topolvm_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| topolvm_version | TopoLVM version to deploy       | string | `"{{index .Versions "storage-topolvm"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
