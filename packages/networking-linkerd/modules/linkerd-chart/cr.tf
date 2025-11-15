resource "kubernetes_manifest" "validatingwebhookconfiguration_linkerd_sp_validator_webhook_config" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "linkerd.io/control-plane-component" = "destination"
        "linkerd.io/control-plane-ns"        = "linkerd"
      }
      "name" = "linkerd-sp-validator-webhook-config"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "caBundle" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURUVENDQWpXZ0F3SUJBZ0lSQUxnUGZlbHlxZStFSXk3eFZ6TWlSK2N3RFFZSktvWklodmNOQVFFTEJRQXcKS3pFcE1DY0dBMVVFQXhNZ2JHbHVhMlZ5WkMxemNDMTJZV3hwWkdGMGIzSXViR2x1YTJWeVpDNXpkbU13SGhjTgpNalV4TVRBMU1UQXpNREkzV2hjTk1qWXhNVEExTVRBek1ESTNXakFyTVNrd0p3WURWUVFERXlCc2FXNXJaWEprCkxYTndMWFpoYkdsa1lYUnZjaTVzYVc1clpYSmtMbk4yWXpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVAKQURDQ0FRb0NnZ0VCQUxVc3pZRVdOaWxzMzFRQzg3K2IzSXlISGxvbWNialViMW00MDRGVVBROENxN3g2MXlmVwp1c1ExelBtUEh6L3BDSHN0OXZDWTN0VDZ1SWxrNzd1elVnVVVsTW5wRG1qcjVuWFBUTnUza0tVZWdHcEd5WFozCkFRSURCZFM3V3dQUHZpdXhkQkNyK1FsMWxDZkRnd1Uwb0phSG56K051T1MrSEk2Q2hicGh0ODRGQ29QYWQ3clMKbk52VGRRSkExL2lWN2xmMmNlcHpoMUVFeFEwVGgxUGpYUFB1TERqeGZVQU53eGpTZVlaa29OOHg0MmM2YzVHVgpXV3JrbU9MenNrTEgvbUlYL1hPWkpreU0rNERUbkgyQ3ozQzlGQ25IaGkyZWpublArV25oQlplSTBlNHRqY0dnCnhqTWltQnVSb1g2ck1CUzZaT3FrNXJkdkhPUXdMZ3MzN2ZNQ0F3RUFBYU5zTUdvd0RnWURWUjBQQVFIL0JBUUQKQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHQVFVRkJ3TUJCZ2dyQmdFRkJRY0RBakFNQmdOVkhSTUJBZjhFQWpBQQpNQ3NHQTFVZEVRUWtNQ0tDSUd4cGJtdGxjbVF0YzNBdGRtRnNhV1JoZEc5eUxteHBibXRsY21RdWMzWmpNQTBHCkNTcUdTSWIzRFFFQkN3VUFBNElCQVFBNVBEUlRuUHQzRlY3ZjVPUnNXU1U4QVN2TlNicWpxMVUzZlFiRGZ4eU8KaWpEU3ZCd1I1WjlUSS9QTFdIRkdsWmxWcXBsUVgwRXlLT3ZSSTYwa3hEbFE3OG1pMWdLZ0M4NHJmb0hGT3hvcgpDVUtoM3VzZGRZeWN0Vmp3bmtubUpzSVhSNzlBa3NiQW1XZU53UnlCNXpjZ05PSXJzdEdnVEZVNTM4MTkwS3dYCll1QzZIaG55RUwxcTVzaExoV3U4eFRQVkZkYmd6QXpudnNodTBUSTdUSWUvQlNRSGN4UFV2MThYQ2VUU21mVUUKN1RmNmZVRWtESmxWRWY4NjIyN2dtemxySHJYUEV3N0ZteEw3MUxCYnJyRWFPUXBjeUJsZ1NPcEpqV1hscE4ycAo3STlHUkxuNzdOZlhvblBibnJidzRVd1NlV2dqcnhQR1VOZEtLdVVWWjlROAotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0t"
          "service" = {
            "name"      = "linkerd-sp-validator"
            "namespace" = "linkerd"
            "path"      = "/"
          }
        }
        "failurePolicy" = "Ignore"
        "name"          = "linkerd-sp-validator.linkerd.io"
        "namespaceSelector" = {
          "matchExpressions" = [
            {
              "key"      = "config.linkerd.io/admission-webhooks"
              "operator" = "NotIn"
              "values" = [
                "disabled",
              ]
            },
          ]
        }
        "rules" = [
          {
            "apiGroups" = [
              "linkerd.io",
            ]
            "apiVersions" = [
              "v1alpha1",
              "v1alpha2",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "serviceprofiles",
            ]
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_linkerd_policy_validator_webhook_config" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "ValidatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "linkerd.io/control-plane-component" = "destination"
        "linkerd.io/control-plane-ns"        = "linkerd"
      }
      "name" = "linkerd-policy-validator-webhook-config"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "caBundle" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURXRENDQWtDZ0F3SUJBZ0lRWFROUDBXVG5nbHJvUWpESloyd1d1ekFOQmdrcWhraUc5dzBCQVFzRkFEQXYKTVMwd0t3WURWUVFERXlSc2FXNXJaWEprTFhCdmJHbGplUzEyWVd4cFpHRjBiM0l1YkdsdWEyVnlaQzV6ZG1NdwpIaGNOTWpVeE1UQTFNVEF6TURJM1doY05Nall4TVRBMU1UQXpNREkzV2pBdk1TMHdLd1lEVlFRREV5UnNhVzVyClpYSmtMWEJ2YkdsamVTMTJZV3hwWkdGMGIzSXViR2x1YTJWeVpDNXpkbU13Z2dFaU1BMEdDU3FHU0liM0RRRUIKQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURjazZFblBBbFk1Q0ZKT3RMRXVmeGx1VnV3aTdTQklEQjlidmxVUFovZApQcnJGZGZXZmc1b2YweDZQWUtwdFRhekdiTHpzUlZMNEY5azNqTzJkUjBscmZBS2pjYm9DMzg0ZXRhdUNVVFBDCjVlSHdtbURLaEdUTnZzaWxqUWE5WUpNVitMY2p2VGZFeDh4dk5rSHNtQU1KeVhrNEJMLzdxSm1FOWtBc0lrMEwKMGs5cHpTTVpGS3NWVFc5WStla0RERTM0RVhGL2RMdjl2RzB1ZjB2RVZCc01YTis3NXQ2Nm5BMXR5d1FGejdrNwpoT0c1S1lLQkViY0ZwYSt6OGtmNmwvR1l1d2ZxbXBDV3FxUENhWkxheUk5SmFjWlcvYSs0VTh4eU5LdVFwYWkxCjNHVU9QYnlyeldnMU1tUENvZFQ5aG1ucUhjYmEzTUZOd3d0S0tRSVVBT1dKQWdNQkFBR2pjREJ1TUE0R0ExVWQKRHdFQi93UUVBd0lGb0RBZEJnTlZIU1VFRmpBVUJnZ3JCZ0VGQlFjREFRWUlLd1lCQlFVSEF3SXdEQVlEVlIwVApBUUgvQkFJd0FEQXZCZ05WSFJFRUtEQW1naVJzYVc1clpYSmtMWEJ2YkdsamVTMTJZV3hwWkdGMGIzSXViR2x1CmEyVnlaQzV6ZG1Nd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFLd0JMNkwvMys4L3RhV3ZqZjhVZDhEVHFyeXAKQjZ1T2Z5djVuQTROem0xNWtMWGZNckF6d0tFa1V0YVJwTDVXRHRNVHVPZStiUU1pRmtmVkRwVE9zRDdUTVJTeQpOWTQ2eDJYbzlLbCtub2hXYWEydG1mcWhuZCtWK3RoQnk4Tjd5MFNySkxmOE5NcEkxSXFKbWlzSGI0dVUxbk9jCllwVGVjbTVmejJHemRnaFJQYy9rdWxMakhidXpkOHMvYnROQ244QS9hK1FZViswb1NGaHBPOVYxc0E1UkR0R0UKRlVkWDJPOWpXMzVPS295TkhQN1A3bTdVMURvaHlhM2R3MCtKTmpvOG1NWm8vM3FCM3ZXL01zYkdlU2FtVy9regpVcVdPV1pOS21rMkpraFNCUkNHV0k0VjN0Z2NjRURCVmFxcEV4TkRPUm5kZ1l4UnNqdjNYd0RaUS9zND0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ=="
          "service" = {
            "name"      = "linkerd-policy-validator"
            "namespace" = "linkerd"
            "path"      = "/"
          }
        }
        "failurePolicy" = "Ignore"
        "name"          = "linkerd-policy-validator.linkerd.io"
        "namespaceSelector" = {
          "matchExpressions" = [
            {
              "key"      = "config.linkerd.io/admission-webhooks"
              "operator" = "NotIn"
              "values" = [
                "disabled",
              ]
            },
          ]
        }
        "rules" = [
          {
            "apiGroups" = [
              "policy.linkerd.io",
            ]
            "apiVersions" = [
              "*",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "authorizationpolicies",
              "httplocalratelimitpolicies",
              "httproutes",
              "networkauthentications",
              "meshtlsauthentications",
              "serverauthorizations",
              "servers",
              "egressnetworks",
            ]
          },
          {
            "apiGroups" = [
              "gateway.networking.k8s.io",
            ]
            "apiVersions" = [
              "*",
            ]
            "operations" = [
              "CREATE",
              "UPDATE",
            ]
            "resources" = [
              "httproutes",
              "grpcroutes",
              "tlsroutes",
              "tcproutes",
            ]
          },
        ]
        "sideEffects" = "None"
      },
    ]
  }
}

resource "kubernetes_manifest" "mutatingwebhookconfiguration_linkerd_proxy_injector_webhook_config" {
  manifest = {
    "apiVersion" = "admissionregistration.k8s.io/v1"
    "kind"       = "MutatingWebhookConfiguration"
    "metadata" = {
      "labels" = {
        "linkerd.io/control-plane-component" = "proxy-injector"
        "linkerd.io/control-plane-ns"        = "linkerd"
      }
      "name" = "linkerd-proxy-injector-webhook-config"
    }
    "webhooks" = [
      {
        "admissionReviewVersions" = [
          "v1",
          "v1beta1",
        ]
        "clientConfig" = {
          "caBundle" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURVakNDQWpxZ0F3SUJBZ0lRRkFHOTdSR0tWdHAxZDBDcGNTSWhiekFOQmdrcWhraUc5dzBCQVFzRkFEQXQKTVNzd0tRWURWUVFERXlKc2FXNXJaWEprTFhCeWIzaDVMV2x1YW1WamRHOXlMbXhwYm10bGNtUXVjM1pqTUI0WApEVEkxTVRFd05URXdNekF5TjFvWERUSTJNVEV3TlRFd016QXlOMW93TFRFck1Da0dBMVVFQXhNaWJHbHVhMlZ5ClpDMXdjbTk0ZVMxcGJtcGxZM1J2Y2k1c2FXNXJaWEprTG5OMll6Q0NBU0l3RFFZSktvWklodmNOQVFFQkJRQUQKZ2dFUEFEQ0NBUW9DZ2dFQkFMRVlvNEQwQ0U4ZEVRRlFTclp3ejc0azB6UUJ0UFJHRy9zR3lqZWhrMlRxbTFEYwpOaSt4cTRobW9KQlRWeTJOaVZBTlQwREJlQzJZdy9tVHM2R3hBUG9zWmRVbytDR0d3NEcwTnVxUng5QWhpV0FICnRPUGNvaWw2RUdRcDdhbS9hdUErWHBWeWxaYldXcit0akRBODRZdWxkYUZOeEw5dXJUeUk3eTM2QU5JckY1WkkKeldQQTY4VDIwY3pucEd6UXBTRXJvNzFNVlZsYW9ENlhUQzNqYzI1eXRLVHE5bXIyaWIvZERyVG4zd0s2d2JuOQpucXFTZXRJZVdlWkdLdk00RUNBMHZvQVVmN0VQdGp0bm9FbTE1b05mbk5WSmNrNm5TQUUrNWVtZDFEbk1PaFN3Ck5XRW1DZDNMajI0QlBlSlljOFVwQ1lXaU8rQjN5NUY1dHRndWRDVUNBd0VBQWFOdU1Hd3dEZ1lEVlIwUEFRSC8KQkFRREFnV2dNQjBHQTFVZEpRUVdNQlFHQ0NzR0FRVUZCd01CQmdnckJnRUZCUWNEQWpBTUJnTlZIUk1CQWY4RQpBakFBTUMwR0ExVWRFUVFtTUNTQ0lteHBibXRsY21RdGNISnZlSGt0YVc1cVpXTjBiM0l1YkdsdWEyVnlaQzV6CmRtTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQ09EdUM1THl0U0FFMCtkTHFsa29TQkdYMm01VS9HQmYvUXoKR2w2RmtRK2tiVlF3cHltaXk5djFWVU9qaVgwSDZEVHcxTGwxajI2TTVlSVhET2ZhcGt2YTNnWXNueE9RN3BLRwp3SnkrdEFOamJRbmtsdEFYa1R3TDhrd3pkRFVwSlEvZ1hhSkdaNVozZWN2K0pzeHFyYXBmWEwyZ3R4b25RenpYCnhLSmJnTUo2eWpmMW8rbTk2L3FUMDRmZFUxVFdoMWRvR0dHUWhNQitmWFB5YXNkb3FkK3RjUmI0Qy9XU0kwTEgKOTVxa3UvcXdEZWZMa2JVZnI0WXhGMThNaFoyTjhRbVc3Q28vblhUNTR2RnZ3cVM0azBqR2h6a1JXVkpXSllBWgpFd2Zsb0w0eVd5NFR1azlRUUhnMTJ1S3V0STNKWTRNVFpFaVBYcU8rMHRSQXFaTWxZVEE9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0="
          "service" = {
            "name"      = "linkerd-proxy-injector"
            "namespace" = "linkerd"
            "path"      = "/"
          }
        }
        "failurePolicy" = "Ignore"
        "name"          = "linkerd-proxy-injector.linkerd.io"
        "namespaceSelector" = {
          "matchExpressions" = [
            {
              "key"      = "config.linkerd.io/admission-webhooks"
              "operator" = "NotIn"
              "values" = [
                "disabled",
              ]
            },
            {
              "key"      = "kubernetes.io/metadata.name"
              "operator" = "NotIn"
              "values" = [
                "kube-system",
                "cert-manager",
              ]
            },
          ]
        }
        "objectSelector" = null
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
              "pods",
              "services",
            ]
            "scope" = "Namespaced"
          },
        ]
        "sideEffects"    = "None"
        "timeoutSeconds" = 10
      },
    ]
  }
}
