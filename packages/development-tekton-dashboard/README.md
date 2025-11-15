## Sumicare [Tekton Dashboard](https://github.com/tektoncd/dashboard) OpenTofu Modules

Deploys [Tekton Dashboard](https://github.com/tektoncd/dashboard) for visual CI/CD pipeline management.

Tekton Dashboard provides a web UI for monitoring and managing Tekton resources, including real-time pipeline/task execution logs, resource creation, and RBAC-aware multi-tenant access to CI/CD workflows.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  tekton_dashboard_version = "0.63.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "tekton_dashboard_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-dashboard/modules/tekton-dashboard-image"
  debian_version = locals.debian_version
  tekton_dashboard_version = locals.tekton_dashboard_version

  depends_on = [module.debian_images]
}

module "tekton_dashboard" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-dashboard/modules/tekton-dashboard-chart"
  tekton_dashboard_version = locals.tekton_dashboard_version

  depends_on = [module.tekton_dashboard_image]
}
```

### Parameters

| Name                     | Description                          | Type   | Default                  | Required   |
|--------------------------|--------------------------------------|--------|--------------------------|------------|
| debian_version           | Debian version for the image         | string | `"trixie-20251117-slim"` | no         |
| tekton_dashboard_version | Tekton Dashboard version to deploy   | string | `"0.63.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
