## Sumicare [Falco](https://github.com/falcosecurity/falco) OpenTofu Modules

Deploys [Falco](https://github.com/falcosecurity/falco) for runtime threat detection and security monitoring.

Falco uses eBPF/kernel modules to detect anomalous syscalls, container escapes, and policy violations in real-time, providing intrusion detection with customizable rules and integration with SIEM/alerting systems for incident response.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  falco_version = "{{index .Versions "security-falco"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "falco_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-falco/modules/falco-image"
  debian_version = locals.debian_version
  falco_version = locals.falco_version

  depends_on = [module.debian_images]
}

module "falco" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-falco/modules/falco-chart"
  falco_version = locals.falco_version

  depends_on = [module.falco_image]
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| falco_version  | Falco version to deploy         | string | `"{{index .Versions "security-falco"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
