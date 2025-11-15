## Sumicare [KubeRay](https://github.com/ray-project/kuberay) OpenTofu Modules

Deploys [KubeRay](https://github.com/ray-project/kuberay) for distributed ML and Python workloads.

KubeRay manages Ray clusters on Kubernetes with autoscaling, fault tolerance, and GPU scheduling, enabling distributed training, hyperparameter tuning, reinforcement learning, and model serving with seamless integration into ML pipelines.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  kuberay_version = "{{index .Versions "mlops-kuberay"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "kuberay_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-kuberay/modules/kuberay-image"
  debian_version = locals.debian_version
  kuberay_version = locals.kuberay_version

  depends_on = [module.debian_images]
}

module "kuberay" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/mlops-kuberay/modules/kuberay-chart"
  kuberay_version = locals.kuberay_version

  depends_on = [module.kuberay_image]
}
```

### Parameters

| Name            | Description                     | Type   | Default                  | Required   |
|-----------------|---------------------------------|--------|--------------------------|------------|
| debian_version  | Debian version for the image    | string | `"{{index .Versions "debian"}}"` | no         |
| kuberay_version | KubeRay version to deploy       | string | `"{{index .Versions "mlops-kuberay"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
