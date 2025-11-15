## Sumicare [DataFusion Ballista](https://github.com/apache/datafusion-ballista) OpenTofu Modules

Deploys [DataFusion Ballista](https://github.com/apache/datafusion-ballista) for distributed SQL analytics.

Ballista provides a Spark-like distributed query engine built on Apache Arrow and DataFusion, enabling high-performance SQL queries over Parquet, CSV, and JSON data with Kubernetes-native scaling and memory-efficient columnar processing.

### Usage

```terraform

locals {
  debian_version = "trixie-20251117-slim"
  data_fusion_ballista_version = "50.0.0"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "data_fusion_ballista_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-data-fusion-ballista/modules/data-fusion-ballista-image"
  debian_version = locals.debian_version
  data_fusion_ballista_version = locals.data_fusion_ballista_version

  depends_on = [module.debian_images]
}

module "data_fusion_ballista" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-data-fusion-ballista/modules/data-fusion-ballista-chart"
  data_fusion_ballista_version = locals.data_fusion_ballista_version

  depends_on = [module.data_fusion_ballista_image]
}
```

### Parameters

| Name                         | Description                             | Type   | Default                  | Required   |
|------------------------------|-----------------------------------------|--------|--------------------------|------------|
| debian_version               | Debian version for the image            | string | `"trixie-20251117-slim"` | no         |
| data_fusion_ballista_version | DataFusion Ballista version to deploy   | string | `"50.0.0"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
