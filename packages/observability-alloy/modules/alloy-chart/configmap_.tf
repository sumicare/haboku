resource "kubernetes_manifest" "configmap_alloy_release_name_alloy" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "config.alloy" = <<-EOT
      logging {
      	level  = "info"
      	format = "logfmt"
      }

      discovery.kubernetes "pods" {
      	role = "pod"
      }

      discovery.kubernetes "nodes" {
      	role = "node"
      }

      discovery.kubernetes "services" {
      	role = "service"
      }

      discovery.kubernetes "endpoints" {
      	role = "endpoints"
      }

      discovery.kubernetes "endpointslices" {
      	role = "endpointslice"
      }

      discovery.kubernetes "ingresses" {
      	role = "ingress"
      }
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component"  = "config"
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "alloy"
        "app.kubernetes.io/part-of"    = "alloy"
        "app.kubernetes.io/version"    = "v1.11.3"
        "helm.sh/chart"                = "alloy-1.4.0"
      }
      "name"      = "release-name-alloy"
      "namespace" = "alloy"
    }
  }
}
