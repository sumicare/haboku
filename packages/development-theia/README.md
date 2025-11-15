## Sumicare [Eclipse Theia](https://github.com/eclipse-theia/theia) OpenTofu Modules

Deploys [Eclipse Theia](https://github.com/eclipse-theia/theia) as a cloud-native development environment.

Eclipse Theia provides a VS Code-compatible, browser-based IDE that runs in Kubernetes, enabling remote development with full language server support, terminal access, and extension compatibility while keeping source code secure within the cluster.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  theia_version = "1.66.2"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "theia_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-theia/modules/theia-image"
  debian_version = locals.debian_version
  theia_version = locals.theia_version

  depends_on = [module.debian_images]
}

module "theia" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-theia/modules/theia-chart"
  theia_version = locals.theia_version

  depends_on = [module.theia_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| theia_version  | Theia version to deploy         | string | `"1.66.2"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
