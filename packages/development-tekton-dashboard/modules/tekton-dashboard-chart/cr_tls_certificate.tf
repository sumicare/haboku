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


resource "kubernetes_manifest" "certificate_tekton_operator_tls_certificates" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      labels    = local.labels
      name      = "${local.app_name}-tls-certificates"
      namespace = var.namespace
    }

    "spec" = {
      commonName = "${local.app_name}"
      dnsNames = [
        "${local.app_name}-webhook.${var.namespace}",
        "${local.app_name}-webhook.${var.namespace}.svc",
        "${local.app_name}-webhook.${var.namespace}.svc.${var.cluster_domain}",
      ]
      duration = "8760h0m0s"
      issuerRef = {
        group = "cert-manager.io"
        kind  = "Issuer"
        name  = "${local.app_name}-issuer"
      }
      privateKey = {
        algorithm = "RSA"
        size      = 2048
      }
      renewBefore    = "5840h0m0s"
      secretName     = "${local.app_name}-webhook-certs"
      secretTemplate = {}
      usages = [
        "server auth",
        "client auth",
      ]
    }
  }
}

resource "kubernetes_manifest" "certificate_tekton_operator_ca" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      labels    = local.labels
      name      = "${local.app_name}-ca"
      namespace = var.namespace
    }
    spec = {
      commonName = "${local.app_name}"
      duration   = "43800h0m0s"
      isCA       = true
      issuerRef = {
        group = "cert-manager.io"
        kind  = "Issuer"
        name  = "${local.app_name}-selfsigned-issuer"
      }
      privateKey = {
        algorithm = "RSA"
        size      = 2048
      }
      renewBefore    = "14600h0m0s"
      secretName     = "${var.org}-ca"
      secretTemplate = {}
    }
  }
}
