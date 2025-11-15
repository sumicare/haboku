## Sumicare [PVC Autoresizer](https://github.com/topolvm/pvc-autoresizer) OpenTofu Modules

Deploys [PVC Autoresizer](https://github.com/topolvm/pvc-autoresizer) for automatic persistent volume expansion.

PVC Autoresizer monitors volume usage and automatically expands PVCs before they fill up, preventing application outages from disk pressure while optimizing storage costs by starting with smaller initial allocations.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  pvc_autoresizer_version = "0.18.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "pvc_autoresizer_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-pvc-autoresizer/modules/pvc-autoresizer-image"
  debian_version = locals.debian_version
  pvc_autoresizer_version = locals.pvc_autoresizer_version

  depends_on = [module.debian_images]
}

module "pvc_autoresizer" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-pvc-autoresizer/modules/pvc-autoresizer-chart"
  pvc_autoresizer_version = locals.pvc_autoresizer_version

  depends_on = [module.pvc_autoresizer_image]
}
```

### Parameters

| Name                    | Description                        | Type   | Default                  | Required   |
|-------------------------|------------------------------------|--------|--------------------------|------------|
| debian_version          | Debian version for the image       | string | `"trixie-20251117-slim"` | no         |
| pvc_autoresizer_version | PVC Autoresizer version to deploy  | string | `"0.18.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
