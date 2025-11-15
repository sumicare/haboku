## Sumicare [Kyverno](https://github.com/kyverno/kyverno) OpenTofu Modules

Deploys [Kyverno](https://github.com/kyverno/kyverno) for Kubernetes-native policy enforcement.

Kyverno validates, mutates, and generates Kubernetes resources using policies written as CRDs (no new language required), enforcing security standards, best practices, and compliance requirements at admission time and through background scans.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  kyverno_version = "{{index .Versions "security-kyverno"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "kyverno_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-kyverno/modules/kyverno-image"
  debian_version = locals.debian_version
  kyverno_version = locals.kyverno_version

  depends_on = [module.debian_images]
}

module "kyverno" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-kyverno/modules/kyverno-chart"
  kyverno_version = locals.kyverno_version

  depends_on = [module.kyverno_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| kyverno_version | Kyverno version to deploy       | string | `"{{index .Versions "security-kyverno"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
