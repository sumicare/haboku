resource "kubernetes_manifest" "mutatingwebhookconfiguration_prepare_downscale_tempo" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "MutatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.31.1"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "tempo"
        "helm.sh/chart"                          = "rollout-operator-0.35.1"
      }
      "name" = "prepare-downscale-tempo"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "tempo"
            "path"      = "/admission/prepare-downscale"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "prepare-downscale-tempo.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "tempo"
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

resource "kubernetes_manifest" "prometheusrule_release_name_tempo" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "PrometheusRule"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "tempo"
        "app.kubernetes.io/version"    = "2.9.0"
        "helm.sh/chart"                = "tempo-distributed-1.53.2"
      }
      "name" = "release-name-tempo"
    }
    "spec" = {
      "groups" = []
    }
  }
}

resource "kubernetes_manifest" "scaledobject_tempo_release_name_tempo_compactor" {
  manifest = {
    "apiVersion" = "keda.sh/v1alpha1"
    "kind"       = "ScaledObject"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component"  = "compactor"
        "app.kubernetes.io/instance"   = "release-name"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "tempo"
        "app.kubernetes.io/version"    = "2.9.0"
        "helm.sh/chart"                = "tempo-distributed-1.53.2"
      }
      "name"      = "release-name-tempo-compactor"
      "namespace" = "tempo"
    }
    "spec" = {
      "maxReplicaCount" = 3
      "minReplicaCount" = 1
      "scaleTargetRef" = {
        "apiVersion" = "apps/v1"
        "kind"       = "Deployment"
        "name"       = "release-name-tempo-compactor"
      }
      "triggers" = null
    }
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_no_downscale_tempo" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.31.1"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "tempo"
        "helm.sh/chart"                          = "rollout-operator-0.35.1"
      }
      "name" = "no-downscale-tempo"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "tempo"
            "path"      = "/admission/no-downscale"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "name"          = "no-downscale-tempo.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "tempo"
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

resource "kubernetes_manifest" "validatingwebhookconfiguration_pod_eviction_tempo" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.31.1"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "tempo"
        "helm.sh/chart"                          = "rollout-operator-0.35.1"
      }
      "name" = "pod-eviction-tempo"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "tempo"
            "path"      = "/admission/pod-eviction"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "name"          = "pod-eviction-tempo.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "tempo"
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

resource "kubernetes_manifest" "validatingwebhookconfiguration_zpdb_validation_tempo" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/instance"             = "release-name"
        "app.kubernetes.io/managed-by"           = "Helm"
        "app.kubernetes.io/name"                 = "rollout-operator"
        "app.kubernetes.io/version"              = "v0.31.1"
        "grafana.com/inject-rollout-operator-ca" = "true"
        "grafana.com/namespace"                  = "tempo"
        "helm.sh/chart"                          = "rollout-operator-0.35.1"
      }
      "name" = "zpdb-validation-tempo"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-rollout-operator"
            "namespace" = "tempo"
            "path"      = "/admission/zpdb-validation"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "name"          = "zpdb-validation-tempo.grafana.com"
        "namespaceSelector" = {
          "matchLabels" = {
            "kubernetes.io/metadata.name" = "tempo"
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
