/*
   Copyright 2025 Sumicare

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/


resource "kubernetes_manifest" "validatingwebhookconfiguration_volcano_admission_service_jobs_validate" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "name" = "volcano-admission-service-jobs-validate"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-admission-service"
            "namespace" = "volcano"
            "path"      = "/jobs/validate"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "validatejob.volcano.sh"
        "namespaceSelector" = {
          "matchExpressions" = [
            {
              "key"      = "kubernetes.io/metadata.name"
              "operator" = "NotIn"
              "values" = [
                "volcano",
                "kube-system",
              ]
            },
          ]
        }
        "objectSelector" = {}
        "rules" = [
          {
            "apiGroups" = [
              "batch.volcano.sh",
            ]
            "apiVersions" = [
              "v1alpha1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "jobs",
            ]
            "scope" = "*"
          },
        ]
        "sideEffects"    = "NoneOnDryRun"
        "timeoutSeconds" = 10
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_volcano_admission_service_queues_validate" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "name" = "volcano-admission-service-queues-validate"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-admission-service"
            "namespace" = "volcano"
            "path"      = "/queues/validate"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "validatequeue.volcano.sh"
        "namespaceSelector" = {
          "matchExpressions" = [
            {
              "key"      = "kubernetes.io/metadata.name"
              "operator" = "NotIn"
              "values" = [
                "volcano",
                "kube-system",
              ]
            },
          ]
        }
        "objectSelector" = {}
        "rules" = [
          {
            "apiGroups" = [
              "scheduling.volcano.sh",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
              "DELETE",
            ]
            "resources" = [
              "queues",
            ]
            "scope" = "*"
          },
        ]
        "sideEffects"    = "NoneOnDryRun"
        "timeoutSeconds" = 10
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_volcano_admission_service_podgroups_validate" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "name" = "volcano-admission-service-podgroups-validate"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-admission-service"
            "namespace" = "volcano"
            "path"      = "/podgroups/validate"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "validatepodgroup.volcano.sh"
        "namespaceSelector" = {
          "matchExpressions" = [
            {
              "key"      = "kubernetes.io/metadata.name"
              "operator" = "NotIn"
              "values" = [
                "volcano",
                "kube-system",
              ]
            },
          ]
        }
        "objectSelector" = {}
        "rules" = [
          {
            "apiGroups" = [
              "scheduling.volcano.sh",
            ]
            "apiVersions" = [
              "v1beta1",
            ]
            "operations" = [
              "CREATE",
            ]
            "resources" = [
              "podgroups",
            ]
            "scope" = "*"
          },
        ]
        "sideEffects"    = "NoneOnDryRun"
        "timeoutSeconds" = 10
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_volcano_admission_service_hypernodes_validate" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "name" = "volcano-admission-service-hypernodes-validate"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-admission-service"
            "namespace" = "volcano"
            "path"      = "/hypernodes/validate"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "validatehypernodes.volcano.sh"
        "rules" = [
          {
            "apiGroups" = [
              "topology.volcano.sh",
            ]
            "apiVersions" = [
              "v1alpha1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "hypernodes",
            ]
          },
        ]
        "sideEffects"    = "None"
        "timeoutSeconds" = 10
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_volcano_admission_service_cronjobs_validate" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "name" = "volcano-admission-service-cronjobs-validate"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
        ]
        "clientConfig" = {
          "service" = {
            "name"      = "release-name-admission-service"
            "namespace" = "volcano"
            "path"      = "/cronjobs/validate"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "validatecronjob.volcano.sh"
        "namespaceSelector" = {
          "matchExpressions" = [
            {
              "key"      = "kubernetes.io/metadata.name"
              "operator" = "NotIn"
              "values" = [
                "volcano",
                "kube-system",
              ]
            },
          ]
        }
        "objectSelector" = {}
        "rules" = [
          {
            "apiGroups" = [
              "batch.volcano.sh",
            ]
            "apiVersions" = [
              "v1alpha1",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "cronjobs",
            ]
            "scope" = "*"
          },
        ]
        "sideEffects"    = "NoneOnDryRun"
        "timeoutSeconds" = 10
      },
    ]
  }
}
