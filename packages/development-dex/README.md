## Sumicare [Dex](https://github.com/dexidp/dex) OpenTofu Modules

Deploys [Dex](https://github.com/dexidp/dex) as a federated OpenID Connect identity provider.

Dex acts as an authentication broker that unifies multiple identity sources (LDAP, SAML, GitHub, Google, OIDC) into a single OIDC interface, enabling consistent SSO across Kubernetes and cloud-native applications.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  dex_version = "2.44.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "dex_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-dex/modules/dex-image"
  debian_version = locals.debian_version
  dex_version = locals.dex_version

  depends_on = [module.debian_images]
}

module "dex" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-dex/modules/dex-chart"
  dex_version = locals.dex_version

  depends_on = [module.dex_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| dex_version    | Dex version to deploy           | string | `"2.44.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
