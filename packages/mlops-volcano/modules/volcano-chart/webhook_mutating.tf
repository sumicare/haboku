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


resource "kubernetes_manifest" "mutatingwebhookconfiguration_volcano_admission_service_queues_mutate" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "MutatingWebhookConfiguration"
    "metadata" = {
      "name" = "volcano-admission-service-queues-mutate"
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
            "path"      = "/queues/mutate"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "mutatequeue.volcano.sh"
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
        "objectSelector"     = {}
        "reinvocationPolicy" = "Never"
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

resource "kubernetes_manifest" "mutatingwebhookconfiguration_volcano_admission_service_jobs_mutate" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "MutatingWebhookConfiguration"
    "metadata" = {
      "name" = "volcano-admission-service-jobs-mutate"
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
            "path"      = "/jobs/mutate"
            "port"      = 443
          }
        }
        "failurePolicy" = "Fail"
        "matchPolicy"   = "Equivalent"
        "name"          = "mutatejob.volcano.sh"
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
        "objectSelector"     = {}
        "reinvocationPolicy" = "Never"
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
