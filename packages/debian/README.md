## Sumicare Debian OpenTofu Modules

Provides secure, minimal Debian-based container images for all Sumicare modules.

Includes both build images (with toolchains) and distroless runtime images, ensuring consistent base layers across the stack with automated security updates and reduced attack surface.

### Usage

```terraform
locals {
  debian_version = "trixie-20251117-slim"
}

module "debian_images" {
    source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
    debian_version = locals.debian_version
}
```

### Parameters

| Name           | Description                     | Type   | Default                  | Required   |
|----------------|---------------------------------|--------|--------------------------|------------|
| debian_version | Base Images Debian version      | string | `"trixie-20251117-slim"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
