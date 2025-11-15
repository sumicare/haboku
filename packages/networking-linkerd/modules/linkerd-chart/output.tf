resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = "linkerd"

    labels = {
      "config.linkerd.io/admission-webhooks" = "disabled"
      "linkerd.io/control-plane-ns"          = "linkerd"
      "linkerd.io/is-control-plane"          = "true"
      "pod-security.kubernetes.io/enforce"   = "privileged"
    }

    annotations = {
      "linkerd.io/inject" = "disabled"
    }
  }
}

resource "kubernetes_cluster_role" "linkerd_linkerd_identity" {
  metadata {
    name = "linkerd-linkerd-identity"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["create"]
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_linkerd_identity" {
  metadata {
    name = "linkerd-linkerd-identity"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-identity"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-linkerd-identity"
  }
}

resource "kubernetes_service_account" "linkerd_identity" {
  metadata {
    name      = "linkerd-identity"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }
}

resource "kubernetes_cluster_role" "linkerd_linkerd_destination" {
  metadata {
    name = "linkerd-linkerd-destination"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["apps"]
    resources  = ["replicasets"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = [""]
    resources  = ["pods", "endpoints", "services", "nodes"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["linkerd.io"]
    resources  = ["serviceprofiles"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["workload.linkerd.io"]
    resources  = ["externalworkloads"]
  }

  rule {
    verbs      = ["create", "get", "update", "patch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["list", "get", "watch", "create", "update", "patch", "delete"]
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_linkerd_destination" {
  metadata {
    name = "linkerd-linkerd-destination"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-destination"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-linkerd-destination"
  }
}

resource "kubernetes_service_account" "linkerd_destination" {
  metadata {
    name      = "linkerd-destination"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }
}

resource "kubernetes_secret" "linkerd_sp_validator_k_8_s_tls" {
  metadata {
    name      = "linkerd-sp-validator-k8s-tls"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  data = {
    "tls.crt" = "-----BEGIN CERTIFICATE-----\nMIIDTDCCAjSgAwIBAgIQYzg06dwTk6mxSIIiZ2Om8zANBgkqhkiG9w0BAQsFADAr\nMSkwJwYDVQQDEyBsaW5rZXJkLXNwLXZhbGlkYXRvci5saW5rZXJkLnN2YzAeFw0y\nNTExMDUxMDMwMjJaFw0yNjExMDUxMDMwMjJaMCsxKTAnBgNVBAMTIGxpbmtlcmQt\nc3AtdmFsaWRhdG9yLmxpbmtlcmQuc3ZjMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A\nMIIBCgKCAQEAtk3nnmJt4pfsBTG1BvO1ZHNJmae1iQKXBJs1F1IUp9Lh3dTdo6AH\nL7l80gRlTkpwGpmyPZG29ho3XqPyuBsxa1BsQfGDKaD8pVp0E0WaVRHJvQh6vtMY\nH9bUauhOUvwexvIs9Kdx6ReVEUGoI0ZawAgs76/paXatYUz8y8jpOoHZ0ricRzLa\nyHdD1+dNlaCUEGJDDvTi91tIOHzBCA2qeJIGCe5hj0I3hzcJxrtpk3PfXizw6pop\nHv4WTBlM72hsLr2CP9t5ZzgByN2nqvjTUxUFKGgiN+9G/2IaY7u53JL12dgDyAmG\nS2p8FBFGXgZCMBooRnvmJTA2eCXv0BlMpQIDAQABo2wwajAOBgNVHQ8BAf8EBAMC\nBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMAwGA1UdEwEB/wQCMAAw\nKwYDVR0RBCQwIoIgbGlua2VyZC1zcC12YWxpZGF0b3IubGlua2VyZC5zdmMwDQYJ\nKoZIhvcNAQELBQADggEBAFeuejwwiRYkAsrYWF2ahWfo+KMsatlLnOPuzZC6Onch\nx1/t9/Ox8Ofoz4r0vClhWTxOdWM2GBuODFhV8tP3G4+BXhcr9al8ZXGOMe7wuAYa\nvzrDl64jKaigoL7gdyao4d0y8j5gEV8MXDlckHnjks9lfDIzkqGVRt80d22I54eY\nZUE9lYUzLzeufHPDKSRhp53FdheNUVXwA4p6oXvLXY1uyKJ6t67ZzKWmhEh13xKM\nCAsGdLwvmISV9UCDSnGGSFxRMyMg3qBq/V7FnxpLF5YGCzE4+UkAxo9i8X+nW0sd\n3tM0u05+23yGGYsKf8fzS2arGMGucrXdGegZCvbtluQ=\n-----END CERTIFICATE-----"
    "tls.key" = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAtk3nnmJt4pfsBTG1BvO1ZHNJmae1iQKXBJs1F1IUp9Lh3dTd\no6AHL7l80gRlTkpwGpmyPZG29ho3XqPyuBsxa1BsQfGDKaD8pVp0E0WaVRHJvQh6\nvtMYH9bUauhOUvwexvIs9Kdx6ReVEUGoI0ZawAgs76/paXatYUz8y8jpOoHZ0ric\nRzLayHdD1+dNlaCUEGJDDvTi91tIOHzBCA2qeJIGCe5hj0I3hzcJxrtpk3PfXizw\n6popHv4WTBlM72hsLr2CP9t5ZzgByN2nqvjTUxUFKGgiN+9G/2IaY7u53JL12dgD\nyAmGS2p8FBFGXgZCMBooRnvmJTA2eCXv0BlMpQIDAQABAoIBABVeHTtNuyZ3exUC\nxf6aGxU6hBJr+1WjRZMnI/pnRv+CsrGfDRlsHNuFqLEvDba299vOTvtzdFf1K68+\nlSjqGwlChGXYSnDbKzGwX/GQU24MJzKuZ0CtmmLE+eHL9743Sd40rXtBkxLojjLX\nGL+FtAZVDvtLCZcwb1L7xJeYJWoTcoGr7v8PHDRYCZg14wFZIJDDZ7OLTT+pllCY\nqrIpncQc+CErZyi8DxYgZWabcYrUvs1QAk0Nb6fII6WqfW7vLlH7WLz2TJF8vN/z\nzsnsALSu6YWUgF6pjcfzA2Ekxy3K8XvJdl76pNEIBA5yWVYHJXzWpcfxoduvEXAz\npICX/bMCgYEAzZklIt8vfEGZW+MnEVTvp8FR0i8yBeUEtRGEA1tcJejpj3nt/AS8\nboUvh9XCLy/L5m8lL8lBKaWSdDHLlpaKLTst5DfPFyITLe2H/nY8EqogHJ+B5tHP\nf8J9uDVWPVwYw4jVX9FgozehprEi3GbFUY67VlnQIaKWSWbpJy7IDDsCgYEA4v7j\nuDpEv2jQi0hV0MyXuxr99l3JVfuIDJsQ9bPhsbHX8h35BT0Y3Mf9wjH/1qZM2jib\nBZkiDT9nwMUZVfwy+IsGnrzYXBQTmilliHzyY0nnlmJn9Vcptihi5dmspR/5tmIK\nyJu6G21W2lY0H80UQ8xGMADJXlHQMdhLvZuV3J8CgYEApSq3q7kSo8brVec5VnIe\niW0Dt0/U5uliC7iDjlLRx17Ca1HvvvtrCXqTgZNXCaNjMb7uZ+JNKBDsg84RGOvd\nG5MkPegbxSDJuabODr2bav8jBvuZVv4MrT1o1Bh9LJQVDNibWfuRn+2sPoalU9x3\n/holI6zJSIweId+7xI+PhEsCgYEAse/WN/rNGzIhj50TUAqgwhXFkFMyWQlEO4Vu\nhPwN5kofmfZu1vFuxNqsi4bAItXXlpQayQeiDrpuLUkTtDhvCC+K7/HetEc0mnrq\n0VQIeVZciKD5FvPNibIc3EqGsCXhjFtMUrbn60oJdDtwvqD2yrKdLlHfh+UgC4Ke\n1LHahscCgYA8tu7jtay9QGEd3dYmLosp/FS+5rUvDoJ+cDN8/Y0PoqMA7MZffh6S\nqUEWczU79t6gYWlYNrELsngFr6RjrAw+g9Gcgwa9/78AealW3tZ4xyUj3X5K90Gm\nllrbyMjV+H0d8JG6WhLPTok/bmweHP/AiQb3dCnjWarsSCB2ZHVdVQ==\n-----END RSA PRIVATE KEY-----"
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "linkerd_policy_validator_k_8_s_tls" {
  metadata {
    name      = "linkerd-policy-validator-k8s-tls"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  data = {
    "tls.crt" = "-----BEGIN CERTIFICATE-----\nMIIDWTCCAkGgAwIBAgIRAI8WV5hh05BfnIgf8sdXBMswDQYJKoZIhvcNAQELBQAw\nLzEtMCsGA1UEAxMkbGlua2VyZC1wb2xpY3ktdmFsaWRhdG9yLmxpbmtlcmQuc3Zj\nMB4XDTI1MTEwNTEwMzAyMloXDTI2MTEwNTEwMzAyMlowLzEtMCsGA1UEAxMkbGlu\na2VyZC1wb2xpY3ktdmFsaWRhdG9yLmxpbmtlcmQuc3ZjMIIBIjANBgkqhkiG9w0B\nAQEFAAOCAQ8AMIIBCgKCAQEA3v0PR8LaLnZLFrXjUMvJVSY9ZDAn1Uh4rGE32FED\nrk7eibh5ittOx5QQ+YZmniXmp3JDyxNalxP5MLyspyq7P9mmsDS2gC8EDc1Vyh1j\ntYqgSNGp88QmyCUFUyZnCCB/0kmepuckzY2jgZpeno8pFN2SZBAzxULZMEn1LWkd\nEY4Zpg8XmO6Sz5zWTZqAED9jLeLuPJlt6Wy+bsER+W2ZKY2yOscnvnaMqvxJYMRu\n6YLB4wsa+b54xAUxFUn8r4mh4leLIzaPaiWP9mMSRt/idkOdPv2z0TybC7R7IaGz\nQg1kuZhuI5b1HYjgCY11/oM9qWShAJkqAuLrlMf6pAZABwIDAQABo3AwbjAOBgNV\nHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMAwGA1Ud\nEwEB/wQCMAAwLwYDVR0RBCgwJoIkbGlua2VyZC1wb2xpY3ktdmFsaWRhdG9yLmxp\nbmtlcmQuc3ZjMA0GCSqGSIb3DQEBCwUAA4IBAQCq7zSer/PVv1je95tzRBvYpPN5\nd3686R5SXP+W3ELsJahxAj0fj3EIKKp+HRR1jRLhQIGB9hXPBaBTqpuNtbdljqxQ\nnj+IroQkKHg+tB/StNLKk4rIQauXF5GTG4GH7Xnjbdt2GZYdonGeZ00bTMwFXI5U\nA97VKq5iok6TFn64J4NxRMv3sAuzrUMGD1AWLJbgt4imwbdnUHt9s603PyhJNwfc\n43w27xJ1ZcGpQ8KaiM7hqEGyTPvmqVgA3azCvOqa/uHtGacDFIiJINakTcKhkngZ\n8WN9T1jD/5K9rpmHk6E/hpaLaZWz+RkMVPTlOzn/Q9MqzrBSHo6n/wHQbhVj\n-----END CERTIFICATE-----"
    "tls.key" = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA3v0PR8LaLnZLFrXjUMvJVSY9ZDAn1Uh4rGE32FEDrk7eibh5\nittOx5QQ+YZmniXmp3JDyxNalxP5MLyspyq7P9mmsDS2gC8EDc1Vyh1jtYqgSNGp\n88QmyCUFUyZnCCB/0kmepuckzY2jgZpeno8pFN2SZBAzxULZMEn1LWkdEY4Zpg8X\nmO6Sz5zWTZqAED9jLeLuPJlt6Wy+bsER+W2ZKY2yOscnvnaMqvxJYMRu6YLB4wsa\n+b54xAUxFUn8r4mh4leLIzaPaiWP9mMSRt/idkOdPv2z0TybC7R7IaGzQg1kuZhu\nI5b1HYjgCY11/oM9qWShAJkqAuLrlMf6pAZABwIDAQABAoIBABO1w5bWEtSo28dE\nnt9NPAe86w/thRUq+ZD8a47BI8r8VAWmsDDwD0fAfzrxwHqkd/2qBx2uoW3ENAe0\n+FUzB5Juaczzw9k9uU/XrAhto5rFh5htgTu3mq6gkxa/82XPquy1WYLVizZoxCCY\nZVpXkMve2pSMrWl3bgeA1LKbCBjnz8JYAvxTqoxx/faiFIy7b0n0uCNvGFdRwuOK\nXvXMUHvqlsTUwtYI56DLBLJ3tGIiM5pNcd1s49l3oogX34fs6BK34yx0GWZHZlZA\nAwrK/wHcdBgO3UsjcMf9I2aSvV33mLnRsI3xrl5iB7g7X2s3JdQfzd6Wheh/azvz\nCcrHy2ECgYEA4PHmY74VPpjLaUSzPvKwWjpv65aIwFWiRT6/rJII+ZV55VuvIyJJ\nrw/F+SsDN+fFbv0abL8RgW4v0NOyuxgYx8lrkxpS6vqpf2IzZZE8+tVo/LlHVwga\nHkEpMNaqlx6CwrniTGovuztugsnwfBh7MV2z/LijaUmWAteb+BRVuucCgYEA/cYD\n+o4rDcfxzvAUdm1kqwoPjQYC9XXS56uV9OeAoQMIwjl+5fEtI2oV73N3cwrJs7ds\n5+ByAExGHHgx5wrnacire2WOaKX7nxQUKMQ/Zj8K/YorlvcMO5LQQe5caMJx3JoW\nSvyd9aAAtpvj9v4gzwK8q3PRhcFdp7zQTqOuzeECgYAGwTzZ4ethZdU15Ao96avC\nCd8yg+K3Y9rrmWbIF9qNJB/08zvfIjh0OVUIlnISS7NyEcepXFN6P4TQEItdcuvL\nlBDW6gNzavOMD7bbZfEe1ym/7RBnXKbsIajK/qdAwnnKvyo8gTPNu4smAkpmb5XD\ndbzh6el+T+dhTngwiuvIIQKBgQCbhhNCJoa0N2k2DWQ8/+XF/LBzGNAPZloOqNWJ\n9aabBqUDgwEGIrwrDATNbtIxqtbaUPtpT+AN1rDRGchbdA9GgTi2sxKHh9GhOEjy\ngvLn0pMFtvvn1RemGt+OyGnRufjV3Yj0A8U6lwhY4UjgQfYRZ/gAi0ZI1qxy9AAl\ncaLbgQKBgQDSaN20Hb4GM3KiqozcDYITmK+o2pHTzsqUYwbXvpzgCxC3rip+70wl\nBnCy3VMaRhJ+0xdMVVaa2+MkUumSFZu3zJgDlJD/Y2fMXr0D0P3T5hoOHEQeU1vu\n8oJO2kyisAk/5RGlFvfnIu5PSHx0YzwuOGjdWLmCmyp6vjF8nzxM9w==\n-----END RSA PRIVATE KEY-----"
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_cluster_role" "linkerd_policy" {
  metadata {
    name = "linkerd-policy"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["apps"]
    resources  = ["deployments"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["policy.linkerd.io"]
    resources  = ["authorizationpolicies", "httplocalratelimitpolicies", "httproutes", "meshtlsauthentications", "networkauthentications", "servers", "serverauthorizations", "egressnetworks"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["httproutes", "grpcroutes", "tlsroutes", "tcproutes"]
  }

  rule {
    verbs      = ["patch"]
    api_groups = ["policy.linkerd.io"]
    resources  = ["httproutes/status", "httplocalratelimitpolicies/status", "egressnetworks/status"]
  }

  rule {
    verbs      = ["patch"]
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["httproutes/status", "grpcroutes/status", "tlsroutes/status", "tcproutes/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["workload.linkerd.io"]
    resources  = ["externalworkloads"]
  }

  rule {
    verbs      = ["create", "get", "patch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_destination_policy" {
  metadata {
    name = "linkerd-destination-policy"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-destination"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-policy"
  }
}

resource "kubernetes_role" "remote_discovery" {
  metadata {
    name      = "remote-discovery"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["secrets"]
  }
}

resource "kubernetes_role_binding" "linkerd_destination_remote_discovery" {
  metadata {
    name      = "linkerd-destination-remote-discovery"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/part-of"          = "Linkerd"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-destination"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "remote-discovery"
  }
}

resource "kubernetes_role" "linkerd_heartbeat" {
  metadata {
    name      = "linkerd-heartbeat"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  rule {
    verbs          = ["get"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["linkerd-config"]
  }
}

resource "kubernetes_role_binding" "linkerd_heartbeat" {
  metadata {
    name      = "linkerd-heartbeat"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-heartbeat"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "linkerd-heartbeat"
  }
}

resource "kubernetes_cluster_role" "linkerd_heartbeat" {
  metadata {
    name = "linkerd-heartbeat"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  rule {
    verbs      = ["list"]
    api_groups = [""]
    resources  = ["namespaces"]
  }

  rule {
    verbs      = ["list"]
    api_groups = ["linkerd.io"]
    resources  = ["serviceprofiles"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_heartbeat" {
  metadata {
    name = "linkerd-heartbeat"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-heartbeat"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-heartbeat"
  }
}

resource "kubernetes_service_account" "linkerd_heartbeat" {
  metadata {
    name      = "linkerd-heartbeat"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "heartbeat"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }
}

resource "kubernetes_cluster_role" "linkerd_linkerd_proxy_injector" {
  metadata {
    name = "linkerd-linkerd-proxy-injector"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = [""]
    resources  = ["namespaces", "replicationcontrollers"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["pods"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["extensions", "apps"]
    resources  = ["deployments", "replicasets", "daemonsets", "statefulsets"]
  }

  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["extensions", "batch"]
    resources  = ["cronjobs", "jobs"]
  }
}

resource "kubernetes_cluster_role_binding" "linkerd_linkerd_proxy_injector" {
  metadata {
    name = "linkerd-linkerd-proxy-injector"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "linkerd-proxy-injector"
    namespace = "linkerd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "linkerd-linkerd-proxy-injector"
  }
}

resource "kubernetes_service_account" "linkerd_proxy_injector" {
  metadata {
    name      = "linkerd-proxy-injector"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }
  }
}

resource "kubernetes_secret" "linkerd_proxy_injector_k_8_s_tls" {
  metadata {
    name      = "linkerd-proxy-injector-k8s-tls"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  data = {
    "tls.crt" = "-----BEGIN CERTIFICATE-----\nMIIDUzCCAjugAwIBAgIRAPkSflO2kf8y6vyVtnlwF2wwDQYJKoZIhvcNAQELBQAw\nLTErMCkGA1UEAxMibGlua2VyZC1wcm94eS1pbmplY3Rvci5saW5rZXJkLnN2YzAe\nFw0yNTExMDUxMDMwMjFaFw0yNjExMDUxMDMwMjFaMC0xKzApBgNVBAMTImxpbmtl\ncmQtcHJveHktaW5qZWN0b3IubGlua2VyZC5zdmMwggEiMA0GCSqGSIb3DQEBAQUA\nA4IBDwAwggEKAoIBAQDR4+bkha6QtCP5JFx1zWaqEREAWUobVF34rv1dzyqZBGLR\n3HHTnK0pJDB8yxzj96iNwur2CoJWnU5SWHgdBl36xOTS2NtfucBqNq430Ag8MstL\nvnHSS1Gm0UOdogBz9pg5CUIrixLbJxzDe1oXrVpDyK3whtG2w5hKxLW2Heb90QMD\nfJJcCVdqTWgsNQ0rT+3QtOmMJK+x0HyNxENrlIDHD0uVifnSgm7WgsO2IM60erzp\nTISyO1irxGx9sVJWMvXwb5sC5VNpzCQdDRxgPcOXOVqvWI/Vcym/Ia61mvTFh8VL\naU+R//IePftqyXr6eiqCV45o+aYCkLrfYI1Nv1iDAgMBAAGjbjBsMA4GA1UdDwEB\n/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/\nBAIwADAtBgNVHREEJjAkgiJsaW5rZXJkLXByb3h5LWluamVjdG9yLmxpbmtlcmQu\nc3ZjMA0GCSqGSIb3DQEBCwUAA4IBAQBqTcVe1zZVrL2cj63up5d7kk7ja8AKxD6N\nLeXmK+Y7HwWDbSaDPckT//OXPFGYy2eFAe55OeVUqdcnJPhf/EWq/5UkjiwZIrqR\n4LiHUbiMIoGyYPiZs1TgNbSxPECW/MCFS5UmRHjZurWKXLcY2+jkLwQM6X1AD/4r\nv0Q8XmHKapv3YGa7bH1tjyDaT8xpnv/MZUmLiwTRVJH2IPDVobFZb9dXcoweGHwo\n6HFQAK3xUtFLA8czpZMn6Z2a4ck7h3zhshIasGk8xzTHXL22sH29rQ/X1eJVNZsU\n8uY28KGQd1viylQCF366jcCQfUBRBkeqYBQ3XhtjYyXO8bjfd5/C\n-----END CERTIFICATE-----"
    "tls.key" = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA0ePm5IWukLQj+SRcdc1mqhERAFlKG1Rd+K79Xc8qmQRi0dxx\n05ytKSQwfMsc4/eojcLq9gqCVp1OUlh4HQZd+sTk0tjbX7nAajauN9AIPDLLS75x\n0ktRptFDnaIAc/aYOQlCK4sS2yccw3taF61aQ8it8IbRtsOYSsS1th3m/dEDA3yS\nXAlXak1oLDUNK0/t0LTpjCSvsdB8jcRDa5SAxw9LlYn50oJu1oLDtiDOtHq86UyE\nsjtYq8RsfbFSVjL18G+bAuVTacwkHQ0cYD3Dlzlar1iP1XMpvyGutZr0xYfFS2lP\nkf/yHj37asl6+noqgleOaPmmApC632CNTb9YgwIDAQABAoIBABspmfFBC6ervcFk\nX0LaOMsRjQMKiyNLoSL/InLyzdnM+NedO8My/NsyKm7mqkUmVn3iF8jiRfPc77c1\nvnWjI/kWuguUskSKeXLwGKPIcbMOBRk2+uvy1gz3T/96aQHuNnegfHETfSE3cpV/\nGoMDQDHoKqUnYsR66PPkI8//FqxfauUBneX+NTW1v8/wMSjgUBtTYiGw3Ei/dk1M\nV2WT9JJFFpuW0ZwA1VWZDzXZZiQyHKrYni/w/auObG3SjsW9Y2As1pfG5EHO7yTB\nXT5BCeHtOM8gOSzRr9hsPghUb0c12jFZswSgc3J7+CKBW4oH5xsfQ6kjHkyIsx5F\nhdewmkECgYEA6w4bIyPgY+HUz0PgE6zL2yC+u1Z/Tl0wb6MAI3PTJcaP2F+wXm95\nuzPtcJdKRsxj4LsoD3+CQyPazXkQvlmlBZEPBN9oo3imHhk6F37O2MlBx4ZEq8a/\n3MqaHo7JYEuN6zKJPvkVc9+wL9qUmJ4SJZ5hk3fMGelLUKqq6Uq+BvkCgYEA5JfB\nNgCeSk3nyglK654armg4QmulMyk1TvoPXM0IznBKDvBiSK2dfP05TLbTbqo5hoJq\n2xUL+x0PAmqZWzEHhsMZOoWZs/xSJM/aM/BV67ift6cDn2hmsaAXpb798SwG7fZO\nzwIDKUdOAgVbDjTcsiz5hLCAG3Z4GBit80xrTlsCgYAKApzHP1TkDA8LEKHvVJGN\n8HQO+F0NkkxoxLFR0THxzuX7Wf/h1a+CeHCpNdg08aljPbU0C8MZZuJ/k6NR5/Fu\nLkJMe9Mx+wZgC8T8kSrv8oo5nA86nYk4NuyfVode8XjGxm0v4F24hJM1RoLDiR/O\nuFMBe72WcOgDNHF44/T5yQKBgQDITFTHDdmlQAg3FtdoB3xXkAij4pC5eIU2c5Qc\ne6gYw3mRB38HMeGKUJPxrU0sbcnEG+inmRSLb1XkhyVjK13t7mvfxIr+k7wid2I6\nGoAe8QI6OQTKm/9H6wBtgiIfPbXAsw8xAhFlDQ7EZI75rsYm9ZOZedJ2veLTMmTR\niAeKewKBgCqC8XAMHXBjpOXk6TL955TrtmicNGn8O9+AJlQWNWDfxgb9CO7qaVBU\nDGLibruWDtUFe8Y51HGzFmjZiAxhqknH+v+OxUiMsRsyIeIQEbOLoMS/R4rOuzeP\nFBT8UQ7NGV0YwukBsl5/4B6uqZaKiHZ+y41CRoef4RgZQjkVVw9e\n-----END RSA PRIVATE KEY-----"
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_role" "ext_namespace_metadata_linkerd_config" {
  metadata {
    name      = "ext-namespace-metadata-linkerd-config"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  rule {
    verbs          = ["get"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["linkerd-config"]
  }
}

resource "kubernetes_secret" "linkerd_identity_issuer" {
  metadata {
    name      = "linkerd-identity-issuer"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  data = {
    "crt.pem" = "-----BEGIN CERTIFICATE-----\nMIIBmzCCAUKgAwIBAgIBATAKBggqhkjOPQQDAjAmMSQwIgYDVQQDExtpZGVudGl0\neS5saW5rZXJkLm9mbXMubG9jYWwwHhcNMjUxMTA1MTAzMDExWhcNMjYxMTA1MTAz\nMDMxWjAmMSQwIgYDVQQDExtpZGVudGl0eS5saW5rZXJkLm9mbXMubG9jYWwwWTAT\nBgcqhkjOPQIBBggqhkjOPQMBBwNCAASTEeOpy8Qt7kv7o/FQRLvMWQDV3agsnqOC\npH1RTtIYWaTP7GuEBaOS+YLcKgvHLTrYD81crdL7pISbE32PmtU9o2EwXzAOBgNV\nHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMA8GA1Ud\nEwEB/wQFMAMBAf8wHQYDVR0OBBYEFO0/eutH7RT9Inz6VWE4E/BQTYDoMAoGCCqG\nSM49BAMCA0cAMEQCICU4TkBHtZVTRK4Np1bbUsmt3Jx3qKnCjk0ct73IVXT6AiBh\noNOKDopMm6+EmFOJ4CDxq6gByYjr5RlxGbFCmuNd7g==\n-----END CERTIFICATE-----"
    "key.pem" = "-----BEGIN EC PRIVATE KEY-----\nMHcCAQEEIKclSBIbFAOr+3cB7BJL3pKV2hocUZyOrjfiYpYDS5YmoAoGCCqGSM49\nAwEHoUQDQgAEkxHjqcvELe5L+6PxUES7zFkA1d2oLJ6jgqR9UU7SGFmkz+xrhAWj\nkvmC3CoLxy062A/NXK3S+6SEmxN9j5rVPQ==\n-----END EC PRIVATE KEY-----"
  }
}

resource "kubernetes_service" "linkerd_identity" {
  metadata {
    name      = "linkerd-identity"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      "linkerd.io/control-plane-component" = "identity"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "linkerd_identity_headless" {
  metadata {
    name      = "linkerd-identity-headless"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      "linkerd.io/control-plane-component" = "identity"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_deployment" "linkerd_identity" {
  metadata {
    name      = "linkerd-identity"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "identity"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "identity"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "linkerd.io/control-plane-component" = "identity"
        "linkerd.io/control-plane-ns"        = "linkerd"
        "linkerd.io/proxy-deployment"        = "linkerd-identity"
      }
    }

    template {
      metadata {
        labels = {
          "linkerd.io/control-plane-component" = "identity"
          "linkerd.io/control-plane-ns"        = "linkerd"
          "linkerd.io/proxy-deployment"        = "linkerd-identity"
          "linkerd.io/workload-ns"             = "linkerd"
        }

        annotations = {
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true"
          "config.linkerd.io/default-inbound-policy"       = "all-unauthenticated"
          "linkerd.io/created-by"                          = "linkerd/cli edge-25.8.5"
          "linkerd.io/proxy-version"                       = "edge-25.8.5"
          "linkerd.io/trust-root-sha256"                   = "8ed6f788dd7a1b21b02b80d69712e94d600b840f4633b50979208e057954e943"
        }
      }

      spec {
        volume {
          name = "identity-issuer"

          secret {
            secret_name = "linkerd-identity-issuer"
          }
        }

        volume {
          name = "trust-roots"

          config_map {
            name = "linkerd-identity-trust-roots"
          }
        }

        volume {
          name = "kube-api-access"

          projected {
            sources {
              service_account_token {
                expiration_seconds = 3607
                path               = "token"
              }
            }

            sources {
              config_map {
                name = "kube-root-ca.crt"

                items {
                  key  = "ca.crt"
                  path = "ca.crt"
                }
              }
            }

            sources {
              downward_api {
                items {
                  path = "namespace"

                  field_ref {
                    api_version = "v1"
                    field_path  = "metadata.namespace"
                  }
                }
              }
            }

            default_mode = "0644"
          }
        }

        volume {
          name      = "linkerd-proxy-init-xtables-lock"
          empty_dir = {}
        }

        volume {
          name = "linkerd-identity-token"

          projected {
            sources {
              service_account_token {
                audience           = "identity.l5d.io"
                expiration_seconds = 86400
                path               = "linkerd-identity-token"
              }
            }
          }
        }

        volume {
          name = "linkerd-identity-end-entity"

          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name  = "linkerd-init"
          image = "cr.l5d.io/linkerd/proxy-init:v2.4.3"
          args  = ["--firewall-bin-path", "iptables-nft", "--firewall-save-bin-path", "iptables-nft-save", "--ipv6=false", "--incoming-proxy-port", "4143", "--outgoing-proxy-port", "4140", "--proxy-uid", "2102", "--inbound-ports-to-ignore", "4190,4191,4567,4568", "--outbound-ports-to-ignore", "443,6443"]

          volume_mount {
            name       = "linkerd-proxy-init-xtables-lock"
            mount_path = "/run"
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW"]
            }

            run_as_user               = 65534
            run_as_group              = 65534
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "identity"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["identity", "-log-level=info", "-log-format=plain", "-controller-namespace=linkerd", "-identity-trust-domain=sumicare.local", "-identity-issuance-lifetime=24h0m0s", "-identity-clock-skew-allowance=20s", "-identity-scheme=linkerd.io/tls", "-enable-pprof=false", "-kube-apiclient-qps=100", "-kube-apiclient-burst=200"]

          port {
            name           = "ident-grpc"
            container_port = 8080
          }

          port {
            name           = "ident-admin"
            container_port = 9990
          }

          env {
            name  = "LINKERD_DISABLED"
            value = "linkerd-await cannot block the identity controller"
          }

          volume_mount {
            name       = "identity-issuer"
            mount_path = "/var/run/linkerd/identity/issuer"
          }

          volume_mount {
            name       = "trust-roots"
            mount_path = "/var/run/linkerd/identity/trust-roots/"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9990"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9990"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "linkerd-proxy"
          image = "cr.l5d.io/linkerd/proxy:edge-25.8.5"

          port {
            name           = "linkerd-proxy"
            container_port = 4143
          }

          port {
            name           = "linkerd-admin"
            container_port = 4191
          }

          env {
            name = "_pod_name"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "_pod_ns"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "_pod_uid"

            value_from {
              field_ref {
                field_path = "metadata.uid"
              }
            }
          }

          env {
            name = "_pod_ip"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "_pod_nodeName"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "_pod_containerName"
            value = "linkerd-proxy"
          }

          env {
            name  = "LINKERD2_PROXY_CORES"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_CORES_MIN"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_REQUIRE_TLS"
            value = "8080"
          }

          env {
            name  = "LINKERD2_PROXY_SHUTDOWN_ENDPOINT_ENABLED"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_LOG"
            value = "warn,linkerd=info,hickory=error,[{headers}]=off,[{request}]=off"
          }

          env {
            name  = "LINKERD2_PROXY_LOG_FORMAT"
            value = "plain"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_ADDR"
            value = "linkerd-dst-headless.linkerd.svc.cluster.local.:8086"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_ADDR"
            value = "linkerd-policy.linkerd.svc.cluster.local.:8090"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_WORKLOAD"
            value = "{\"ns\":\"$(_pod_ns)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DEFAULT_POLICY"
            value = "all-unauthenticated"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_CLUSTER_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_INITIAL_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_IDLE_TIMEOUT"
            value = "5m"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_LIFETIME"
            value = "1h"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_CONNECT_TIMEOUT"
            value = "100ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_TIMEOUT"
            value = "1000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "5s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "90s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_LISTEN_ADDR"
            value = "0.0.0.0:4190"
          }

          env {
            name  = "LINKERD2_PROXY_ADMIN_LISTEN_ADDR"
            value = "0.0.0.0:4191"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDR"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDRS"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_LISTEN_ADDR"
            value = "0.0.0.0:4143"
          }

          env {
            name = "LINKERD2_PROXY_INBOUND_IPS"

            value_from {
              field_ref {
                field_path = "status.podIPs"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS"
            value = "8080,9990"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_SUFFIXES"
            value = "svc.cluster.local."
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_METRICS_HOSTNAME_LABELS"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_DISABLE_PROTOCOL_DETECTION"
            value = "25,587,3306,4444,5432,6379,9300,11211"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_CONTEXT"
            value = "{\"ns\":\"$(_pod_ns)\", \"nodeName\":\"$(_pod_nodeName)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name = "_pod_sa"

            value_from {
              field_ref {
                field_path = "spec.serviceAccountName"
              }
            }
          }

          env {
            name  = "_l5d_ns"
            value = "linkerd"
          }

          env {
            name  = "_l5d_trustdomain"
            value = "sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_DIR"
            value = "/var/run/linkerd/identity/end-entity"
          }

          env {
            name = "LINKERD2_PROXY_IDENTITY_TRUST_ANCHORS"

            value_from {
              config_map_key_ref {
                name = "linkerd-identity-trust-roots"
                key  = "ca-bundle.crt"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_TOKEN_FILE"
            value = "/var/run/secrets/tokens/linkerd-identity-token"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_ADDR"
            value = "localhost.:8080"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_LOCAL_NAME"
            value = "$(_pod_sa).$(_pod_ns).serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_NAME"
            value = "linkerd-identity.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          volume_mount {
            name       = "linkerd-identity-end-entity"
            mount_path = "/var/run/linkerd/identity/end-entity"
          }

          volume_mount {
            name       = "linkerd-identity-token"
            mount_path = "/var/run/secrets/tokens"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "4191"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "4191"
            }

            initial_delay_seconds = 2
            timeout_seconds       = 1
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2102
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "linkerd-identity"

        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_service" "linkerd_dst" {
  metadata {
    name      = "linkerd-dst"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8086
      target_port = "8086"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "linkerd_dst_headless" {
  metadata {
    name      = "linkerd-dst-headless"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8086
      target_port = "8086"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "linkerd_sp_validator" {
  metadata {
    name      = "linkerd-sp-validator"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "sp-validator"
      port        = 443
      target_port = "sp-validator"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "linkerd_policy" {
  metadata {
    name      = "linkerd-policy"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "grpc"
      port        = 8090
      target_port = "8090"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "linkerd_policy_validator" {
  metadata {
    name      = "linkerd-policy-validator"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "policy-https"
      port        = 443
      target_port = "policy-https"
    }

    selector = {
      "linkerd.io/control-plane-component" = "destination"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "linkerd_destination" {
  metadata {
    name      = "linkerd-destination"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "destination"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "destination"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "linkerd.io/control-plane-component" = "destination"
        "linkerd.io/control-plane-ns"        = "linkerd"
        "linkerd.io/proxy-deployment"        = "linkerd-destination"
      }
    }

    template {
      metadata {
        labels = {
          "linkerd.io/control-plane-component" = "destination"
          "linkerd.io/control-plane-ns"        = "linkerd"
          "linkerd.io/proxy-deployment"        = "linkerd-destination"
          "linkerd.io/workload-ns"             = "linkerd"
        }

        annotations = {
          "checksum/config"                                = "ee072d8649691d597d0c68bbf5e65073d6b371c3192d416097a0eaf1cabbbf2a"
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true"
          "config.linkerd.io/default-inbound-policy"       = "all-unauthenticated"
          "linkerd.io/created-by"                          = "linkerd/cli edge-25.8.5"
          "linkerd.io/proxy-version"                       = "edge-25.8.5"
          "linkerd.io/trust-root-sha256"                   = "8ed6f788dd7a1b21b02b80d69712e94d600b840f4633b50979208e057954e943"
        }
      }

      spec {
        volume {
          name = "sp-tls"

          secret {
            secret_name = "linkerd-sp-validator-k8s-tls"
          }
        }

        volume {
          name = "policy-tls"

          secret {
            secret_name = "linkerd-policy-validator-k8s-tls"
          }
        }

        volume {
          name = "kube-api-access"

          projected {
            sources {
              service_account_token {
                expiration_seconds = 3607
                path               = "token"
              }
            }

            sources {
              config_map {
                name = "kube-root-ca.crt"

                items {
                  key  = "ca.crt"
                  path = "ca.crt"
                }
              }
            }

            sources {
              downward_api {
                items {
                  path = "namespace"

                  field_ref {
                    api_version = "v1"
                    field_path  = "metadata.namespace"
                  }
                }
              }
            }

            default_mode = "0644"
          }
        }

        volume {
          name      = "linkerd-proxy-init-xtables-lock"
          empty_dir = {}
        }

        volume {
          name = "linkerd-identity-token"

          projected {
            sources {
              service_account_token {
                audience           = "identity.l5d.io"
                expiration_seconds = 86400
                path               = "linkerd-identity-token"
              }
            }
          }
        }

        volume {
          name = "linkerd-identity-end-entity"

          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name  = "linkerd-init"
          image = "cr.l5d.io/linkerd/proxy-init:v2.4.3"
          args  = ["--firewall-bin-path", "iptables-nft", "--firewall-save-bin-path", "iptables-nft-save", "--ipv6=false", "--incoming-proxy-port", "4143", "--outgoing-proxy-port", "4140", "--proxy-uid", "2102", "--inbound-ports-to-ignore", "4190,4191,4567,4568", "--outbound-ports-to-ignore", "443,6443"]

          volume_mount {
            name       = "linkerd-proxy-init-xtables-lock"
            mount_path = "/run"
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW"]
            }

            run_as_user               = 65534
            run_as_group              = 65534
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "linkerd-proxy"
          image = "cr.l5d.io/linkerd/proxy:edge-25.8.5"

          port {
            name           = "linkerd-proxy"
            container_port = 4143
          }

          port {
            name           = "linkerd-admin"
            container_port = 4191
          }

          env {
            name = "_pod_name"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "_pod_ns"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "_pod_uid"

            value_from {
              field_ref {
                field_path = "metadata.uid"
              }
            }
          }

          env {
            name = "_pod_ip"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "_pod_nodeName"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "_pod_containerName"
            value = "linkerd-proxy"
          }

          env {
            name  = "LINKERD2_PROXY_CORES"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_CORES_MIN"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_SHUTDOWN_ENDPOINT_ENABLED"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_LOG"
            value = "warn,linkerd=info,hickory=error,[{headers}]=off,[{request}]=off"
          }

          env {
            name  = "LINKERD2_PROXY_LOG_FORMAT"
            value = "plain"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_ADDR"
            value = "localhost.:8086"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_ADDR"
            value = "localhost.:8090"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_WORKLOAD"
            value = "{\"ns\":\"$(_pod_ns)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DEFAULT_POLICY"
            value = "all-unauthenticated"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_CLUSTER_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_INITIAL_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_IDLE_TIMEOUT"
            value = "5m"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_LIFETIME"
            value = "1h"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_CONNECT_TIMEOUT"
            value = "100ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_TIMEOUT"
            value = "1000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "5s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "90s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_LISTEN_ADDR"
            value = "0.0.0.0:4190"
          }

          env {
            name  = "LINKERD2_PROXY_ADMIN_LISTEN_ADDR"
            value = "0.0.0.0:4191"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDR"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDRS"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_LISTEN_ADDR"
            value = "0.0.0.0:4143"
          }

          env {
            name = "LINKERD2_PROXY_INBOUND_IPS"

            value_from {
              field_ref {
                field_path = "status.podIPs"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS"
            value = "8086,8090,8443,9443,9990,9996,9997"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_SUFFIXES"
            value = "svc.cluster.local."
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_METRICS_HOSTNAME_LABELS"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_DISABLE_PROTOCOL_DETECTION"
            value = "25,587,3306,4444,5432,6379,9300,11211"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_CONTEXT"
            value = "{\"ns\":\"$(_pod_ns)\", \"nodeName\":\"$(_pod_nodeName)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name = "_pod_sa"

            value_from {
              field_ref {
                field_path = "spec.serviceAccountName"
              }
            }
          }

          env {
            name  = "_l5d_ns"
            value = "linkerd"
          }

          env {
            name  = "_l5d_trustdomain"
            value = "sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_DIR"
            value = "/var/run/linkerd/identity/end-entity"
          }

          env {
            name = "LINKERD2_PROXY_IDENTITY_TRUST_ANCHORS"

            value_from {
              config_map_key_ref {
                name = "linkerd-identity-trust-roots"
                key  = "ca-bundle.crt"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_TOKEN_FILE"
            value = "/var/run/secrets/tokens/linkerd-identity-token"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_ADDR"
            value = "linkerd-identity-headless.linkerd.svc.cluster.local.:8080"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_LOCAL_NAME"
            value = "$(_pod_sa).$(_pod_ns).serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_NAME"
            value = "linkerd-identity.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          volume_mount {
            name       = "linkerd-identity-end-entity"
            mount_path = "/var/run/linkerd/identity/end-entity"
          }

          volume_mount {
            name       = "linkerd-identity-token"
            mount_path = "/var/run/secrets/tokens"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "4191"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "4191"
            }

            initial_delay_seconds = 2
            timeout_seconds       = 1
          }

          lifecycle {
            post_start {
              exec {
                command = ["/usr/lib/linkerd/linkerd-await", "--timeout=2m", "--port=4191"]
              }
            }
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2102
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "destination"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["destination", "-addr=:8086", "-controller-namespace=linkerd", "-outbound-transport-mode=transport-header", "-enable-h2-upgrade=true", "-log-level=info", "-log-format=plain", "-enable-endpoint-slices=true", "-cluster-domain=cluster.local", "-identity-trust-domain=sumicare.local", "-default-opaque-ports=25,587,3306,4444,5432,6379,9300,11211", "-enable-ipv6=false", "-enable-pprof=false", "--meshed-http2-client-params={\"keep_alive\":{\"interval\":{\"seconds\":10},\"timeout\":{\"seconds\":3},\"while_idle\":true}}"]

          port {
            name           = "dest-grpc"
            container_port = 8086
          }

          port {
            name           = "dest-admin"
            container_port = 9996
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9996"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9996"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "sp-validator"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["sp-validator", "-log-level=info", "-log-format=plain", "-enable-pprof=false"]

          port {
            name           = "sp-validator"
            container_port = 8443
          }

          port {
            name           = "spval-admin"
            container_port = 9997
          }

          volume_mount {
            name       = "sp-tls"
            read_only  = true
            mount_path = "/var/run/linkerd/tls"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9997"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9997"
            }

            timeout_seconds   = 1
            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name    = "policy"
          image   = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          command = ["/linkerd-policy-controller"]
          args    = ["--admin-addr=0.0.0.0:9990", "--control-plane-namespace=linkerd", "--grpc-addr=0.0.0.0:8090", "--server-addr=0.0.0.0:9443", "--server-tls-key=/var/run/linkerd/tls/tls.key", "--server-tls-certs=/var/run/linkerd/tls/tls.crt", "--cluster-networks=10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8", "--identity-domain=sumicare.local", "--cluster-domain=cluster.local", "--default-policy=all-unauthenticated", "--log-level=info", "--log-format=plain", "--default-opaque-ports=25,587,3306,4444,5432,6379,9300,11211", "--global-egress-network-namespace=linkerd-egress", "--probe-networks=0.0.0.0/0,::/0"]

          port {
            name           = "policy-grpc"
            container_port = 8090
          }

          port {
            name           = "policy-admin"
            container_port = 9990
          }

          port {
            name           = "policy-https"
            container_port = 9443
          }

          volume_mount {
            name       = "policy-tls"
            read_only  = true
            mount_path = "/var/run/linkerd/tls"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "policy-admin"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "policy-admin"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "linkerd-destination"

        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_cron_job_v1" "linkerd_heartbeat" {
  metadata {
    name      = "linkerd-heartbeat"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "heartbeat"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "heartbeat"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    schedule           = "40 10 * * *"
    concurrency_policy = "Replace"

    job_template {
      metadata {}

      spec {
        template {
          metadata {
            labels = {
              "linkerd.io/control-plane-component" = "heartbeat"
              "linkerd.io/workload-ns"             = "linkerd"
            }

            annotations = {
              "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
            }
          }

          spec {
            volume {
              name = "kube-api-access"

              projected {
                sources {
                  service_account_token {
                    expiration_seconds = 3607
                    path               = "token"
                  }
                }

                sources {
                  config_map {
                    name = "kube-root-ca.crt"

                    items {
                      key  = "ca.crt"
                      path = "ca.crt"
                    }
                  }
                }

                sources {
                  downward_api {
                    items {
                      path = "namespace"

                      field_ref {
                        api_version = "v1"
                        field_path  = "metadata.namespace"
                      }
                    }
                  }
                }

                default_mode = "0644"
              }
            }

            container {
              name  = "heartbeat"
              image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
              args  = ["heartbeat", "-controller-namespace=linkerd", "-log-level=info", "-log-format=plain", "-prometheus-url=http://prometheus.linkerd-viz.svc.cluster.local:9090"]

              env {
                name  = "LINKERD_DISABLED"
                value = "the heartbeat controller does not use the proxy"
              }

              volume_mount {
                name       = "kube-api-access"
                read_only  = true
                mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
              }

              image_pull_policy = "IfNotPresent"

              security_context {
                capabilities {
                  drop = ["ALL"]
                }

                run_as_user               = 2103
                run_as_non_root           = true
                read_only_root_filesystem = true

                seccomp_profile {
                  type = "RuntimeDefault"
                }
              }
            }

            restart_policy = "Never"

            node_selector = {
              "kubernetes.io/os" = "linux"
            }

            service_account_name = "linkerd-heartbeat"

            security_context {
              seccomp_profile {
                type = "RuntimeDefault"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "linkerd_proxy_injector" {
  metadata {
    name      = "linkerd-proxy-injector"
    namespace = "linkerd"

    labels = {
      "app.kubernetes.io/name"             = "proxy-injector"
      "app.kubernetes.io/part-of"          = "Linkerd"
      "app.kubernetes.io/version"          = "edge-25.8.5"
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "linkerd.io/created-by" = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "linkerd.io/control-plane-component" = "proxy-injector"
      }
    }

    template {
      metadata {
        labels = {
          "linkerd.io/control-plane-component" = "proxy-injector"
          "linkerd.io/control-plane-ns"        = "linkerd"
          "linkerd.io/proxy-deployment"        = "linkerd-proxy-injector"
          "linkerd.io/workload-ns"             = "linkerd"
        }

        annotations = {
          "checksum/config"                                = "03de1737c6d16354996e4d3115f40b59efc332c2dcac3e2ffdc442b4e7ba6c2c"
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true"
          "config.linkerd.io/default-inbound-policy"       = "all-unauthenticated"
          "config.linkerd.io/opaque-ports"                 = "8443"
          "linkerd.io/created-by"                          = "linkerd/cli edge-25.8.5"
          "linkerd.io/proxy-version"                       = "edge-25.8.5"
          "linkerd.io/trust-root-sha256"                   = "8ed6f788dd7a1b21b02b80d69712e94d600b840f4633b50979208e057954e943"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "linkerd-config"
          }
        }

        volume {
          name = "trust-roots"

          config_map {
            name = "linkerd-identity-trust-roots"
          }
        }

        volume {
          name = "tls"

          secret {
            secret_name = "linkerd-proxy-injector-k8s-tls"
          }
        }

        volume {
          name = "kube-api-access"

          projected {
            sources {
              service_account_token {
                expiration_seconds = 3607
                path               = "token"
              }
            }

            sources {
              config_map {
                name = "kube-root-ca.crt"

                items {
                  key  = "ca.crt"
                  path = "ca.crt"
                }
              }
            }

            sources {
              downward_api {
                items {
                  path = "namespace"

                  field_ref {
                    api_version = "v1"
                    field_path  = "metadata.namespace"
                  }
                }
              }
            }

            default_mode = "0644"
          }
        }

        volume {
          name      = "linkerd-proxy-init-xtables-lock"
          empty_dir = {}
        }

        volume {
          name = "linkerd-identity-token"

          projected {
            sources {
              service_account_token {
                audience           = "identity.l5d.io"
                expiration_seconds = 86400
                path               = "linkerd-identity-token"
              }
            }
          }
        }

        volume {
          name = "linkerd-identity-end-entity"

          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name  = "linkerd-init"
          image = "cr.l5d.io/linkerd/proxy-init:v2.4.3"
          args  = ["--firewall-bin-path", "iptables-nft", "--firewall-save-bin-path", "iptables-nft-save", "--ipv6=false", "--incoming-proxy-port", "4143", "--outgoing-proxy-port", "4140", "--proxy-uid", "2102", "--inbound-ports-to-ignore", "4190,4191,4567,4568", "--outbound-ports-to-ignore", "443,6443"]

          volume_mount {
            name       = "linkerd-proxy-init-xtables-lock"
            mount_path = "/run"
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW"]
            }

            run_as_user               = 65534
            run_as_group              = 65534
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "linkerd-proxy"
          image = "cr.l5d.io/linkerd/proxy:edge-25.8.5"

          port {
            name           = "linkerd-proxy"
            container_port = 4143
          }

          port {
            name           = "linkerd-admin"
            container_port = 4191
          }

          env {
            name = "_pod_name"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "_pod_ns"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "_pod_uid"

            value_from {
              field_ref {
                field_path = "metadata.uid"
              }
            }
          }

          env {
            name = "_pod_ip"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name = "_pod_nodeName"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "_pod_containerName"
            value = "linkerd-proxy"
          }

          env {
            name  = "LINKERD2_PROXY_CORES"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_CORES_MIN"
            value = "1"
          }

          env {
            name  = "LINKERD2_PROXY_SHUTDOWN_ENDPOINT_ENABLED"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_LOG"
            value = "warn,linkerd=info,hickory=error,[{headers}]=off,[{request}]=off"
          }

          env {
            name  = "LINKERD2_PROXY_LOG_FORMAT"
            value = "plain"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_ADDR"
            value = "linkerd-dst-headless.linkerd.svc.cluster.local.:8086"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_ADDR"
            value = "linkerd-policy.linkerd.svc.cluster.local.:8090"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_WORKLOAD"
            value = "{\"ns\":\"$(_pod_ns)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DEFAULT_POLICY"
            value = "all-unauthenticated"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_CLUSTER_NETWORKS"
            value = "10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,fd00::/8"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_INITIAL_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_IDLE_TIMEOUT"
            value = "5m"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_STREAM_LIFETIME"
            value = "1h"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_CONNECT_TIMEOUT"
            value = "100ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_TIMEOUT"
            value = "1000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "5s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_DISCOVERY_IDLE_TIMEOUT"
            value = "90s"
          }

          env {
            name  = "LINKERD2_PROXY_CONTROL_LISTEN_ADDR"
            value = "0.0.0.0:4190"
          }

          env {
            name  = "LINKERD2_PROXY_ADMIN_LISTEN_ADDR"
            value = "0.0.0.0:4191"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDR"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_LISTEN_ADDRS"
            value = "127.0.0.1:4140"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_LISTEN_ADDR"
            value = "0.0.0.0:4143"
          }

          env {
            name = "LINKERD2_PROXY_INBOUND_IPS"

            value_from {
              field_ref {
                field_path = "status.podIPs"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS"
            value = "8443,9995"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_PROFILE_SUFFIXES"
            value = "svc.cluster.local."
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_KEEPALIVE"
            value = "10000ms"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_ACCEPT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_CONNECT_USER_TIMEOUT"
            value = "30s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_METRICS_HOSTNAME_LABELS"
            value = "false"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_INTERVAL"
            value = "10s"
          }

          env {
            name  = "LINKERD2_PROXY_OUTBOUND_SERVER_HTTP2_KEEP_ALIVE_TIMEOUT"
            value = "3s"
          }

          env {
            name  = "LINKERD2_PROXY_INBOUND_PORTS_DISABLE_PROTOCOL_DETECTION"
            value = "25,587,3306,4444,5432,6379,9300,11211"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_CONTEXT"
            value = "{\"ns\":\"$(_pod_ns)\", \"nodeName\":\"$(_pod_nodeName)\", \"pod\":\"$(_pod_name)\"}\n"
          }

          env {
            name = "_pod_sa"

            value_from {
              field_ref {
                field_path = "spec.serviceAccountName"
              }
            }
          }

          env {
            name  = "_l5d_ns"
            value = "linkerd"
          }

          env {
            name  = "_l5d_trustdomain"
            value = "sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_DIR"
            value = "/var/run/linkerd/identity/end-entity"
          }

          env {
            name = "LINKERD2_PROXY_IDENTITY_TRUST_ANCHORS"

            value_from {
              config_map_key_ref {
                name = "linkerd-identity-trust-roots"
                key  = "ca-bundle.crt"
              }
            }
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_TOKEN_FILE"
            value = "/var/run/secrets/tokens/linkerd-identity-token"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_ADDR"
            value = "linkerd-identity-headless.linkerd.svc.cluster.local.:8080"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_LOCAL_NAME"
            value = "$(_pod_sa).$(_pod_ns).serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_IDENTITY_SVC_NAME"
            value = "linkerd-identity.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_DESTINATION_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          env {
            name  = "LINKERD2_PROXY_POLICY_SVC_NAME"
            value = "linkerd-destination.linkerd.serviceaccount.identity.linkerd.sumicare.local"
          }

          volume_mount {
            name       = "linkerd-identity-end-entity"
            mount_path = "/var/run/linkerd/identity/end-entity"
          }

          volume_mount {
            name       = "linkerd-identity-token"
            mount_path = "/var/run/secrets/tokens"
          }

          liveness_probe {
            http_get {
              path = "/live"
              port = "4191"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "4191"
            }

            initial_delay_seconds = 2
            timeout_seconds       = 1
          }

          lifecycle {
            post_start {
              exec {
                command = ["/usr/lib/linkerd/linkerd-await", "--timeout=2m", "--port=4191"]
              }
            }
          }

          termination_message_policy = "FallbackToLogsOnError"
          image_pull_policy          = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2102
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        container {
          name  = "proxy-injector"
          image = "cr.l5d.io/linkerd/controller:edge-25.8.5"
          args  = ["proxy-injector", "-log-level=info", "-log-format=plain", "-linkerd-namespace=linkerd", "-enable-pprof=false"]

          port {
            name           = "proxy-injector"
            container_port = 8443
          }

          port {
            name           = "injector-admin"
            container_port = 9995
          }

          volume_mount {
            name       = "config"
            mount_path = "/var/run/linkerd/config"
          }

          volume_mount {
            name       = "trust-roots"
            mount_path = "/var/run/linkerd/identity/trust-roots"
          }

          volume_mount {
            name       = "tls"
            read_only  = true
            mount_path = "/var/run/linkerd/tls"
          }

          volume_mount {
            name       = "kube-api-access"
            read_only  = true
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = "9995"
            }

            initial_delay_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = "9995"
            }

            failure_threshold = 7
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 2103
            run_as_non_root           = true
            read_only_root_filesystem = true

            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "linkerd-proxy-injector"

        security_context {
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_service" "linkerd_proxy_injector" {
  metadata {
    name      = "linkerd-proxy-injector"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-component" = "proxy-injector"
      "linkerd.io/control-plane-ns"        = "linkerd"
    }

    annotations = {
      "config.linkerd.io/opaque-ports" = "443"
      "linkerd.io/created-by"          = "linkerd/cli edge-25.8.5"
    }
  }

  spec {
    port {
      name        = "proxy-injector"
      port        = 443
      target_port = "proxy-injector"
    }

    selector = {
      "linkerd.io/control-plane-component" = "proxy-injector"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_secret" "linkerd_config_overrides" {
  metadata {
    name      = "linkerd-config-overrides"
    namespace = "linkerd"

    labels = {
      "linkerd.io/control-plane-ns" = "linkerd"
    }
  }

  data = {
    linkerd-config-overrides = "identity:\n  externalCA: true\n  issuer:\n    tls:\n      crtPEM: |\n        -----BEGIN CERTIFICATE-----\n        MIIBmzCCAUKgAwIBAgIBATAKBggqhkjOPQQDAjAmMSQwIgYDVQQDExtpZGVudGl0\n        eS5saW5rZXJkLm9mbXMubG9jYWwwHhcNMjUxMTA1MTAzMDExWhcNMjYxMTA1MTAz\n        MDMxWjAmMSQwIgYDVQQDExtpZGVudGl0eS5saW5rZXJkLm9mbXMubG9jYWwwWTAT\n        BgcqhkjOPQIBBggqhkjOPQMBBwNCAASTEeOpy8Qt7kv7o/FQRLvMWQDV3agsnqOC\n        pH1RTtIYWaTP7GuEBaOS+YLcKgvHLTrYD81crdL7pISbE32PmtU9o2EwXzAOBgNV\n        HQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMA8GA1Ud\n        EwEB/wQFMAMBAf8wHQYDVR0OBBYEFO0/eutH7RT9Inz6VWE4E/BQTYDoMAoGCCqG\n        SM49BAMCA0cAMEQCICU4TkBHtZVTRK4Np1bbUsmt3Jx3qKnCjk0ct73IVXT6AiBh\n        oNOKDopMm6+EmFOJ4CDxq6gByYjr5RlxGbFCmuNd7g==\n        -----END CERTIFICATE-----\n      keyPEM: |\n        -----BEGIN EC PRIVATE KEY-----\n        MHcCAQEEIKclSBIbFAOr+3cB7BJL3pKV2hocUZyOrjfiYpYDS5YmoAoGCCqGSM49\n        AwEHoUQDQgAEkxHjqcvELe5L+6PxUES7zFkA1d2oLJ6jgqR9UU7SGFmkz+xrhAWj\n        kvmC3CoLxy062A/NXK3S+6SEmxN9j5rVPQ==\n        -----END EC PRIVATE KEY-----\nidentityTrustAnchorsPEM: |\n  -----BEGIN CERTIFICATE-----\n  MIIBmzCCAUKgAwIBAgIBATAKBggqhkjOPQQDAjAmMSQwIgYDVQQDExtpZGVudGl0\n  eS5saW5rZXJkLm9mbXMubG9jYWwwHhcNMjUxMTA1MTAzMDExWhcNMjYxMTA1MTAz\n  MDMxWjAmMSQwIgYDVQQDExtpZGVudGl0eS5saW5rZXJkLm9mbXMubG9jYWwwWTAT\n  BgcqhkjOPQIBBggqhkjOPQMBBwNCAASTEeOpy8Qt7kv7o/FQRLvMWQDV3agsnqOC\n  pH1RTtIYWaTP7GuEBaOS+YLcKgvHLTrYD81crdL7pISbE32PmtU9o2EwXzAOBgNV\n  HQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMA8GA1Ud\n  EwEB/wQFMAMBAf8wHQYDVR0OBBYEFO0/eutH7RT9Inz6VWE4E/BQTYDoMAoGCCqG\n  SM49BAMCA0cAMEQCICU4TkBHtZVTRK4Np1bbUsmt3Jx3qKnCjk0ct73IVXT6AiBh\n  oNOKDopMm6+EmFOJ4CDxq6gByYjr5RlxGbFCmuNd7g==\n  -----END CERTIFICATE-----\nidentityTrustDomain: sumicare.local\n"
  }
}

