## Sumicare [Local Path Provisioner](https://github.com/rancher/local-path-provisioner) OpenTofu Modules

Deploys [Local Path Provisioner](https://github.com/rancher/local-path-provisioner) for dynamic local storage provisioning.

Local Path Provisioner enables dynamic PVC provisioning using node-local storage, creating hostPath volumes on demand for development clusters, edge deployments, and workloads requiring low-latency local disk access.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  local_path_provisioner_version = "{{index .Versions "storage-local-path-provisioner"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "local_path_provisioner_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-local-path-provisioner/modules/local-path-provisioner-image"
  debian_version = locals.debian_version
  local_path_provisioner_version = locals.local_path_provisioner_version

  depends_on = [module.debian_images]
}

module "local_path_provisioner" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/storage-local-path-provisioner/modules/local-path-provisioner-chart"
  local_path_provisioner_version = locals.local_path_provisioner_version

  depends_on = [module.local_path_provisioner_image]
}
```

### Parameters

| Name                           | Description                              | Type   | Default                  | Required   |
|--------------------------------|------------------------------------------|--------|--------------------------|------------|
| debian_version                 | Debian version for the image             | string | `"{{index .Versions "debian"}}"` | no         |
| local_path_provisioner_version | Local Path Provisioner version to deploy | string | `"{{index .Versions "storage-local-path-provisioner"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
