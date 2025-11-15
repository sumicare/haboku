## Sumicare [Bank-Vaults Operator](https://github.com/bank-vaults/vault-operator) OpenTofu Modules

Deploys [Bank-Vaults Operator](https://github.com/bank-vaults/vault-operator) for automated Vault cluster management.

Bank-Vaults Operator provisions and manages HashiCorp Vault clusters on Kubernetes with automated unsealing, configuration-as-code, backup/restore, and HA setup, simplifying secrets management infrastructure operations.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  bank_vaults_operator_version = "1.23.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "bank_vaults_operator_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-bank-vaults-operator/modules/bank-vaults-operator-image"
  debian_version = locals.debian_version
  bank_vaults_operator_version = locals.bank_vaults_operator_version

  depends_on = [module.debian_images]
}

module "bank_vaults_operator" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/security-bank-vaults-operator/modules/bank-vaults-operator-chart"
  bank_vaults_operator_version = locals.bank_vaults_operator_version

  depends_on = [module.bank_vaults_operator_image]
}
```

### Parameters

| Name                         | Description                             | Type   | Default                  | Required   |
|------------------------------|-----------------------------------------|--------|--------------------------|------------|
| debian_version               | Debian version for the image            | string | `"trixie-20251117-slim"` | no         |
| bank_vaults_operator_version | Bank-Vaults Operator version to deploy  | string | `"1.23.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
