## Sumicare [Linkerd](https://linkerd.io/) OpenTofu Modules

Deploys [Linkerd](https://linkerd.io/) as a lightweight, security-focused service mesh.

Linkerd provides automatic mTLS, latency-aware load balancing, and golden metrics (success rate, latency, throughput) with minimal resource overhead, enabling zero-trust networking and observability without application code changes.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  linkerd_version = "{{index .Versions "networking-linkerd"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "linkerd_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-linkerd/modules/linkerd-image"
  debian_version = locals.debian_version
  linkerd_version = locals.linkerd_version

  depends_on = [module.debian_images]
}

module "linkerd" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-linkerd/modules/linkerd-chart"
  linkerd_version = locals.linkerd_version

  depends_on = [module.linkerd_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| linkerd_version | Linkerd version to deploy       | string | `"{{index .Versions "networking-linkerd"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
