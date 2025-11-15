## Sumicare [OME](https://github.com/sgl-project/ome) OpenTofu Modules

Deploys [OME](https://github.com/sgl-project/ome) for high-throughput LLM inference serving.

OME (Open Model Engine) provides optimized inference for large language models with continuous batching, PagedAttention, and tensor parallelism, delivering production-grade LLM serving with OpenAI-compatible APIs and efficient GPU utilization.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  ome_version = "0.3.8"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "ome_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-ome/modules/ome-image"
  debian_version = locals.debian_version
  ome_version = locals.ome_version

  depends_on = [module.debian_images]
}

module "ome" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-ome/modules/ome-chart"
  ome_version = locals.ome_version

  depends_on = [module.ome_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| ome_version    | OME version to deploy           | string | `"0.3.8"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
