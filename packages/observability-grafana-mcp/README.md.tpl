## Sumicare [Grafana MCP](https://github.com/grafana/mcp-grafana) OpenTofu Modules

Deploys [Grafana MCP](https://github.com/grafana/mcp-grafana) for AI-assisted observability.

Grafana MCP implements the Model Context Protocol to expose Grafana dashboards, alerts, and data sources to LLMs, enabling natural language queries for metrics exploration, incident investigation, and automated dashboard generation.

### Usage

```terraform

locals {
  debian_version = "{{index .Versions "debian"}}"
  grafana_mcp_version = "{{index .Versions "observability-grafana-mcp"}}"
}

module "debian_images" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/debian/modules/debian-images"
  debian_version = locals.debian_version
}

module "grafana_mcp_image" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-grafana-mcp/modules/grafana-mcp-image"
  debian_version = locals.debian_version
  grafana_mcp_version = locals.grafana_mcp_version

  depends_on = [module.debian_images]
}

module "grafana_mcp" {
  source = "github.com/sumicare/terraform-kubernetes-modules//packages/observability-grafana-mcp/modules/grafana-mcp-chart"
  grafana_mcp_version = locals.grafana_mcp_version

  depends_on = [module.grafana_mcp_image]
}
```

### Parameters

| Name                | Description                      | Type   | Default                  | Required   |
|---------------------|----------------------------------|--------|--------------------------|------------|
| debian_version      | Debian version for the image     | string | `"{{index .Versions "debian"}}"` | no         |
| grafana_mcp_version | Grafana MCP version to deploy    | string | `"{{index .Versions "observability-grafana-mcp"}}"` | no         |

### License

Copyright 2025 Sumicare

By using this project for academic, advertising, enterprise, or any other purpose, <br/>
you grant your **Implicit Agreement** to the Sumicare OSS [Terms of Use](../../OSS_TERMS.md).

Sumicare Kubernetes OpenTofu Modules Licensed under the terms of [Apache License, Version 2.0](../../LICENSE).
