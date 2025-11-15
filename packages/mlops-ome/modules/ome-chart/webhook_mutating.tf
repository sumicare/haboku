
resource "kubernetes_manifest" "mutatingwebhookconfiguration_inferenceservice_ome_io" {
  manifest = {
    apiVersion = "admissionregistration.k8s.io/v1"
    kind       = "MutatingWebhookConfiguration"
    metadata = {
      annotations = {
        "cert-manager.io/inject-ca-from" = "ome/serving-cert"
      }
      name = "inferenceservice.ome.io"
    }
    webhooks = [
      {
        admissionReviewVersions = [
          "v1beta1",
        ]
        clientConfig = {
          caBundle = "Cg=="
          service = {
            name      = "ome-webhook-server-service"
            namespace = "ome"
            path      = "/mutate-ome-io-v1beta1-inferenceservice"
          }
        }
        failurePolicy = "Fail"
        name          = "inferenceservice.ome-webhook-server.defaulter"
        rules = [
          {
            apiGroups = [
              "ome.io",
            ]
            apiVersions = [
              "v1beta1",
            ]
            operations = [
              "CREATE",
              "UPDATE",
            ]
            resources = [
              "inferenceservices",
            ]
          },
        ]
        sideEffects = "None"
      },
      {
        admissionReviewVersions = [
          "v1beta1",
        ]
        clientConfig = {
          caBundle = "Cg=="
          service = {
            name      = "ome-webhook-server-service"
            namespace = "ome"
            path      = "/mutate-pods"
          }
        }
        failurePolicy = "Fail"
        name          = "inferenceservice.ome-webhook-server.pod-mutator"
        namespaceSelector = {
          matchExpressions = [
            {
              key      = "control-plane"
              operator = "DoesNotExist"
            },
          ]
        }
        objectSelector = {
          matchExpressions = [
            {
              key      = "ome.io/inferenceservice"
              operator = "Exists"
            },
          ]
        }
        reinvocationPolicy = "IfNeeded"
        rules = [
          {
            apiGroups = [
              "",
            ]
            apiVersions = [
              "v1",
            ]
            operations = [
              "CREATE",
            ]
            resources = [
              "pods",
            ]
          },
        ]
        sideEffects = "None"
      },
    ]
  }
}