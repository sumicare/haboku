## Sumicare [Calico](https://github.com/projectcalico/calico) OpenTofu Modules

Deploys [Calico](https://github.com/projectcalico/calico) for high-performance networking and network policy.

Calico provides a CNI plugin with BGP-based routing, network policies for microsegmentation, and eBPF dataplane options, enabling scalable pod networking with fine-grained security controls and observability across hybrid cloud environments.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  calico_version = "{{index .Versions "networking-calico"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "calico_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-calico/modules/calico-image"
  debian_version = locals.debian_version
  calico_version = locals.calico_version

  depends_on = [module.debian_images]
}

module "calico" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/networking-calico/modules/calico-chart"
  calico_version = locals.calico_version

  depends_on = [module.calico_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| calico_version | Calico version to deploy        | string | `"{{index .Versions "networking-calico"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
