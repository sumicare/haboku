## Sumicare [Tekton Triggers](https://github.com/tektoncd/triggers) OpenTofu Modules

Deploys [Tekton Triggers](https://github.com/tektoncd/triggers) for event-driven pipeline automation.

Tekton Triggers enables automatic pipeline execution from external events (webhooks, cloud events), extracting payload data to parameterize builds and supporting GitHub/GitLab/Bitbucket integrations for true GitOps CI/CD workflows.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  tekton_triggers_version = "{{index .Versions "development-tekton-triggers"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "tekton_triggers_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-triggers/modules/tekton-trigger-image"
  debian_version = locals.debian_version
  tekton_triggers_version = locals.tekton_triggers_version

  depends_on = [module.debian_images]
}

module "tekton_triggers" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/development-tekton-triggers/modules/tekton-trigger-chart"
  tekton_triggers_version = locals.tekton_triggers_version

  depends_on = [module.tekton_triggers_image]
}
```

### Parameters

| Name                    | Description                         | Type   | Default                  | Required   |
|-------------------------|-------------------------------------|--------|--------------------------|------------|
| debian_version          | Debian version for the image        | string | `"{{index .Versions "debian"}}"` | no         |
| tekton_triggers_version | Tekton Triggers version to deploy   | string | `"{{index .Versions "development-tekton-triggers"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
