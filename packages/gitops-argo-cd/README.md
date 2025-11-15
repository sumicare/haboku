## Sumicare [Argo CD](https://github.com/argoproj/argo-cd) OpenTofu Modules

Deploys [Argo CD](https://github.com/argoproj/argo-cd) for declarative GitOps continuous delivery.

Argo CD continuously reconciles cluster state with Git repositories, providing automated deployments, drift detection, rollback capabilities, and a web UI for managing applications across multiple clusters with RBAC and SSO integration.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  argo_cd_version = "3.2.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "argo_cd_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-cd/modules/argo-cd-image"
  debian_version = locals.debian_version
  argo_cd_version = locals.argo_cd_version

  depends_on = [module.debian_images]
}

module "argo_cd" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-cd/modules/argo-cd-chart"
  argo_cd_version = locals.argo_cd_version

  depends_on = [module.argo_cd_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| argo_cd_version | Argo CD version to deploy       | string | `"3.2.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
