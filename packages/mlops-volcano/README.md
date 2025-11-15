## Sumicare [Volcano](https://github.com/volcano-sh/volcano) OpenTofu Modules

Deploys [Volcano](https://github.com/volcano-sh/volcano) for batch and HPC workload scheduling.

Volcano extends Kubernetes scheduling with gang scheduling, fair-share queuing, and preemption policies essential for ML training, MPI jobs, Spark, and scientific computing workloads that require coordinated multi-pod scheduling and resource guarantees.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  volcano_version = "1.9.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "volcano_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-volcano/modules/volcano-images"
  debian_version = locals.debian_version
  volcano_version = locals.volcano_version

  depends_on = [module.debian_images]
}

module "volcano" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-volcano/modules/volcano-chart"
  volcano_version = locals.volcano_version

  depends_on = [module.volcano_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| volcano_version | Volcano version to deploy       | string | `"1.9.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
