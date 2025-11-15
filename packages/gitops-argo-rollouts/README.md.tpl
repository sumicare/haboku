## Sumicare [Argo Rollouts](https://github.com/argoproj/argo-rollouts) OpenTofu Modules

Deploys [Argo Rollouts](https://github.com/argoproj/argo-rollouts) for progressive delivery and deployment strategies.

Argo Rollouts extends Kubernetes Deployments with blue-green, canary, and experimentation capabilities, integrating with service meshes and ingress controllers for traffic shifting while supporting automated rollback based on metrics analysis.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  argo_rollouts_version = "{{index .Versions "gitops-argo-rollouts"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "argo_rollouts_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-rollouts/modules/argo-rollouts-image"
  debian_version = locals.debian_version
  argo_rollouts_version = locals.argo_rollouts_version

  depends_on = [module.debian_images]
}

module "argo_rollouts" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-rollouts/modules/argo-rollouts-chart"
  argo_rollouts_version = locals.argo_rollouts_version

  depends_on = [module.argo_rollouts_image]
}
```

### Parameters

| Name                  | Description                       | Type   | Default                  | Required   |
|-----------------------|-----------------------------------|--------|--------------------------|------------|
| debian_version        | Debian version for the image      | string | `"{{index .Versions "debian"}}"` | no         |
| argo_rollouts_version | Argo Rollouts version to deploy   | string | `"{{index .Versions "gitops-argo-rollouts"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
