## Sumicare [External DNS](https://github.com/kubernetes-sigs/external-dns) OpenTofu Modules

Deploys [External DNS](https://github.com/kubernetes-sigs/external-dns) for automatic DNS record management.

ExternalDNS watches Services, Ingresses, and Gateway API resources to automatically create and update DNS records in providers like Route53, CloudFlare, and Google Cloud DNS, eliminating manual DNS configuration for Kubernetes workloads.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  external_dns_version = "{{index .Versions "networking-external-dns"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "external_dns_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-external-dns/modules/external-dns-image"
  debian_version = locals.debian_version
  external_dns_version = locals.external_dns_version

  depends_on = [module.debian_images]
}

module "external_dns" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-external-dns/modules/external-dns-chart"
  external_dns_version = locals.external_dns_version

  depends_on = [module.external_dns_image]
}
```

### Parameters

| Name                 | Description                       | Type   | Default                  | Required   |
|----------------------|-----------------------------------|--------|--------------------------|------------|
| debian_version       | Debian version for the image      | string | `"{{index .Versions "debian"}}"` | no         |
| external_dns_version | External DNS version to deploy    | string | `"{{index .Versions "networking-external-dns"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
