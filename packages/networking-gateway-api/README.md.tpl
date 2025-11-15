## Sumicare [Gateway API](https://github.com/kubernetes-sigs/gateway-api) OpenTofu Modules

Deploys [Gateway API](https://github.com/kubernetes-sigs/gateway-api) CRDs for next-generation Kubernetes ingress.

Gateway API provides expressive, role-oriented routing resources (Gateway, HTTPRoute, GRPCRoute) that supersede Ingress, enabling advanced traffic management like header-based routing, traffic splitting, and cross-namespace references with portable configurations.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  gateway_api_version = "{{index .Versions "networking-gateway-api"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "gateway_api_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-gateway-api/modules/gateway-api-image"
  debian_version = locals.debian_version
  gateway_api_version = locals.gateway_api_version

  depends_on = [module.debian_images]
}

module "gateway_api" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-gateway-api/modules/gateway-api-chart"
  gateway_api_version = locals.gateway_api_version

  depends_on = [module.gateway_api_image]
}
```

### Parameters

| Name                | Description                      | Type   | Default                  | Required   |
|---------------------|----------------------------------|--------|--------------------------|------------|
| debian_version      | Debian version for the image     | string | `"{{index .Versions "debian"}}"` | no         |
| gateway_api_version | Gateway API version to deploy    | string | `"{{index .Versions "networking-gateway-api"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
