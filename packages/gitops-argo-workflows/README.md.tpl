## Sumicare [Argo Workflows](https://github.com/argoproj/argo-workflows) OpenTofu Modules

Deploys [Argo Workflows](https://github.com/argoproj/argo-workflows) for complex job orchestration on Kubernetes.

Argo Workflows enables DAG and step-based workflows with parallel execution, artifact passing, retries, and timeouts—ideal for CI/CD pipelines, data processing, ML training, and batch jobs with a powerful templating system and web UI.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  argo_workflows_version = "{{index .Versions "gitops-argo-workflows"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "argo_workflows_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-workflows/modules/argo-workflows-image"
  debian_version = locals.debian_version
  argo_workflows_version = locals.argo_workflows_version

  depends_on = [module.debian_images]
}

module "argo_workflows" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-workflows/modules/argo-workflows-chart"
  argo_workflows_version = locals.argo_workflows_version

  depends_on = [module.argo_workflows_image]
}
```

### Parameters

| Name                   | Description                        | Type   | Default                  | Required   |
|------------------------|------------------------------------|--------|--------------------------|------------|
| debian_version         | Debian version for the image       | string | `"{{index .Versions "debian"}}"` | no         |
| argo_workflows_version | Argo Workflows version to deploy   | string | `"{{index .Versions "gitops-argo-workflows"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
