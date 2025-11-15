resource "kubernetes_manifest" "mutatingwebhookconfiguration_prepare_downscale_loki" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "MutatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.29.0"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "loki"
        "helm.sh/chart"                          = "rollout-operator-0.33.2"
      }
      "name" = "prepare-downscale-loki"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "loki"
            "path"      = "/admission/prepare-downscale"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "prepare-downscale-loki.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "loki"
          }
        }
        "rules" = [
          {
            "apiGroups" = [
              "apps",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "UPDATE",
            ]
            "resources" = [
              "statefulsets",
              "statefulsets/scale",
            ]
            "scope" = "Namespaced"
          },
        ]
        "sideEffects"    = "NoneOnDryRun"
        "timeoutSeconds" = 10
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_no_downscale_loki" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.29.0"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "loki"
        "helm.sh/chart"                          = "rollout-operator-0.33.2"
      }
      "name" = "no-downscale-loki"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "loki"
            "path"      = "/admission/no-downscale"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "name"          = "no-downscale-loki.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "loki"
          }
        }
        "rules" = [
          {
            "apiGroups" = [
              "apps",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "UPDATE",
            ]
            "resources" = [
              "statefulsets",
              "statefulsets/scale",
            ]
            "scope" = "Namespaced"
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_pod_eviction_loki" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.29.0"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "loki"
        "helm.sh/chart"                          = "rollout-operator-0.33.2"
      }
      "name" = "pod-eviction-loki"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "loki"
            "path"      = "/admission/pod-eviction"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "name"          = "pod-eviction-loki.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "loki"
          }
        }
        "rules" = [
          {
            "apiGroups" = [
              "",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "CREATE",
            ]
            "resources" = [
              "pods/eviction",
            ]
            "scope" = "Namespaced"
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_zpdb_validation_loki" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.29.0"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "loki"
        "helm.sh/chart"                          = "rollout-operator-0.33.2"
      }
      "name" = "zpdb-validation-loki"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "loki"
            "path"      = "/admission/zpdb-validation"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "name"          = "zpdb-validation-loki.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "loki"
          }
        }
        "rules" = [
          {
            "apiGroups" = [
              "rollout-operator.grafana.com",
            ]
            "apiVersions" = [
              "v1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "zoneawarepoddisruptionbudgets",
            ]
            "scope" = "Namespaced"
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}
