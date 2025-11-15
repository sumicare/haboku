## Sumicare [Tekton Results](https://github.com/tektoncd/results) OpenTofu Modules

Deploys [Tekton Results](https://github.com/tektoncd/results) for persistent CI/CD execution history.

Tekton Results stores pipeline and task run data in a dedicated backend (PostgreSQL/GCS/S3), enabling long-term retention, efficient querying, 
and reduced etcd load while providing a gRPC/REST API for build analytics and compliance auditing.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  tekton_results_version = "0.17.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "tekton_results_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-results/modules/tekton-results-image"
  debian_version = locals.debian_version
  tekton_results_version = locals.tekton_results_version

  depends_on = [module.debian_images]
}

module "tekton_results" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-results/modules/tekton-results-chart"
  tekton_results_version = locals.tekton_results_version

  depends_on = [module.tekton_results_image]
}
```

### Parameters

| Name                   | Description                        | Type   | Default                  | Required   |
|------------------------|------------------------------------|--------|--------------------------|------------|
| debian_version         | Debian version for the image       | string | `"trixie-20251117-slim"` | no         |
| tekton_results_version | Tekton Results version to deploy   | string | `"0.17.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
