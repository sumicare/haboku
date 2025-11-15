## Sumicare [Tekton Chains](https://github.com/tektoncd/chains) OpenTofu Modules

Deploys [Tekton Chains](https://github.com/tektoncd/chains) for software supply chain security and attestation.

Tekton Chains automatically signs pipeline artifacts and generates SLSA provenance attestations, providing cryptographic proof of build integrity and enabling secure software supply chain verification with Sigstore/cosign integration.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  tekton_chains_version = "{{index .Versions "development-tekton-chains"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "tekton_chains_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-chains/modules/tekton-chains-image"
  debian_version = locals.debian_version
  tekton_chains_version = locals.tekton_chains_version

  depends_on = [module.debian_images]
}

module "tekton_chains" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-chains/modules/tekton-chains-chart"
  tekton_chains_version = locals.tekton_chains_version

  depends_on = [module.tekton_chains_image]
}
```

### Parameters

| Name                  | Description                       | Type   | Default                  | Required   |
|-----------------------|-----------------------------------|--------|--------------------------|------------|
| debian_version        | Debian version for the image      | string | `"{{index .Versions "debian"}}"` | no         |
| tekton_chains_version | Tekton Chains version to deploy   | string | `"{{index .Versions "development-tekton-chains"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
