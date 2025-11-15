## Sumicare [cert-manager](https://github.com/cert-manager/cert-manager) OpenTofu Modules

Deploys [cert-manager](https://github.com/cert-manager/cert-manager) for automated TLS certificate lifecycle management.

cert-manager automates certificate issuance and renewal from Let's Encrypt, Vault, Venafi, and private CAs, managing certificates as Kubernetes resources with automatic rotation and integration with Ingress and Gateway API.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  cert_manager_version = "{{index .Versions "security-cert-manager"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "cert_manager_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-cert-manager/modules/cert-manager-image"
  debian_version = locals.debian_version
  cert_manager_version = locals.cert_manager_version

  depends_on = [module.debian_images]
}

module "cert_manager" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-cert-manager/modules/cert-manager-chart"
  cert_manager_version = locals.cert_manager_version

  depends_on = [module.cert_manager_image]
}
```

### Parameters

| Name                 | Description                       | Type   | Default                  | Required   |
|----------------------|-----------------------------------|--------|--------------------------|------------|
| debian_version       | Debian version for the image      | string | `"{{index .Versions "debian"}}"` | no         |
| cert_manager_version | cert-manager version to deploy    | string | `"{{index .Versions "security-cert-manager"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
