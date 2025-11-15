## Sumicare [Argo Events](https://github.com/argoproj/argo-events) OpenTofu Modules

Deploys [Argo Events](https://github.com/argoproj/argo-events) for event-driven workflow orchestration.

Argo Events connects 20+ event sources (webhooks, S3, Kafka, NATS, cron) to triggers that spawn Argo Workflows, Kubernetes resources, or HTTP requests, enabling reactive automation patterns and complex event processing pipelines.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  argo_events_version = "{{index .Versions "gitops-argo-events"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "argo_events_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-events/modules/argo-events-image"
  debian_version = locals.debian_version
  argo_events_version = locals.argo_events_version

  depends_on = [module.debian_images]
}

module "argo_events" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/gitops-argo-events/modules/argo-events-chart"
  argo_events_version = locals.argo_events_version

  depends_on = [module.argo_events_image]
}
```

### Parameters

| Name                | Description                     | Type   | Default                  | Required   |
|---------------------|---------------------------------|--------|--------------------------|------------|
| debian_version      | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| argo_events_version | Argo Events version to deploy   | string | `"{{index .Versions "gitops-argo-events"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
