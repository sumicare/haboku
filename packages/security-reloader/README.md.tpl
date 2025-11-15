## Sumicare [Reloader](https://github.com/stakater/Reloader) OpenTofu Modules

This module deploys [Reloader](https://github.com/stakater/Reloader) to the cluster.

Reloader is a Kubernetes controller to watch changes in ConfigMap and Secrets and do rolling upgrades on Pods with their associated Deployments, StatefulSets, DaemonSets, and DeploymentConfigs.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  reloader_version = "{{index .Versions "security-reloader"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "reloader_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-reloader/modules/reloader-image"
  debian_version = locals.debian_version
  reloader_version = locals.reloader_version

  depends_on = [module.debian_images]
}

module "reloader" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-reloader/modules/reloader-chart"
  reloader_version = locals.reloader_version

  depends_on = [module.reloader_image]
}
```

### Parameters

| Name             | Description                     | Type   | Default                  | Required   |
|------------------|---------------------------------|--------|--------------------------|------------|
| debian_version   | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| reloader_version | Reloader version to deploy      | string | `"{{index .Versions "security-reloader"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
