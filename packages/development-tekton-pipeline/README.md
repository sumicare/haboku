## Sumicare [Tekton Pipeline](https://github.com/tektoncd/pipeline) OpenTofu Modules

Deploys [Tekton Pipeline](https://github.com/tektoncd/pipeline) as the foundation for Kubernetes-native CI/CD.

Tekton Pipelines provides declarative, reusable CI/CD building blocks (Tasks, Pipelines, Workspaces) that run as Kubernetes pods, enabling portable, scalable automation with built-in artifact management and parallel execution.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  tekton_pipeline_version = "1.7.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "tekton_pipeline_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-pipeline/modules/tekton-pipeline-image"
  debian_version = locals.debian_version
  tekton_pipeline_version = locals.tekton_pipeline_version

  depends_on = [module.debian_images]
}

module "tekton_pipeline" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-pipeline/modules/tekton-pipeline-chart"
  tekton_pipeline_version = locals.tekton_pipeline_version

  depends_on = [module.tekton_pipeline_image]
}
```

### Parameters

| Name                    | Description                         | Type   | Default                  | Required   |
|-------------------------|-------------------------------------|--------|--------------------------|------------|
| debian_version          | Debian version for the image        | string | `"trixie-20251117-slim"` | no         |
| tekton_pipeline_version | Tekton Pipeline version to deploy   | string | `"1.7.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
