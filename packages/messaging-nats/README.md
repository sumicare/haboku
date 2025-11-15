## Sumicare [NATS](https://github.com/nats-io/k8s) OpenTofu Modules

This module deploys [NATS](https://nats.io/) to the cluster using the official Helm chart.

NATS is a high-performance, cloud-native messaging system for distributed systems and microservices.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  nats_version   = "0.13.1"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "nats_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/messaging-nats/modules/nats-image"
  debian_version = locals.debian_version
  nats_version   = locals.nats_version

  depends_on = [module.debian_images]
}

module "nats" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/messaging-nats/modules/nats-chart"
  nats_version = locals.nats_version

  depends_on = [module.nats_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"trixie-20251117-slim"` | no         |
| nats_version   | NATS version to deploy          | string | `"0.13.1"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
