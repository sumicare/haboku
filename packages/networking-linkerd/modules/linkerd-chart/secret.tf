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

