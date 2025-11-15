//
// Copyright (c) 2025 Sumicare
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package chunks

import "strings"

// Certificate duration constants.
const (
	// DefaultTLSDuration is 1 year.
	DefaultTLSDuration = "8760h0m0s"
	// DefaultTLSRenewBefore is ~8 months.
	DefaultTLSRenewBefore = "5840h0m0s"
	// DefaultCADuration is 5 years.
	DefaultCADuration = "43800h0m0s"
	// DefaultCARenewBefore is ~20 months.
	DefaultCARenewBefore = "14600h0m0s"
	// DefaultKeyAlgorithm is RSA.
	DefaultKeyAlgorithm = "RSA"
	// DefaultKeySize is 2048 bits.
	DefaultKeySize = "2048"
)

// TerraformResourceTLSCertificate generates a cert-manager TLS Certificate resource.
// Parameters:
//   - appName: the application name (e.g., "descheduler")
//   - namespace: namespace reference (e.g., "local.namespace" or "var.namespace")
//   - services: comma-separated service names for DNS entries (e.g., "" for app_name only, or "operator,metrics-apiserver")
//   - secretSuffix: suffix for secret name (e.g., "tls" -> "${local.app_name}-tls")
//   - issuerVar: variable for issuer name (e.g., "var.issuer_name")
//   - issuerFallback: fallback suffix for issuer (e.g., "issuer" -> "${local.app_name}-issuer")
//   - usages: comma-separated usages (e.g., "server auth" or "server auth,client auth")
func TerraformResourceTLSCertificate(appName, namespace, services, secretSuffix, issuerVar, issuerFallback, usages string) string {
	// Build DNS names block
	dnsLines := buildDNSNames(namespace, services)

	// Build usages block
	usagesBlock := ""
	if usages != "" {
		var usageLines []string
		for u := range strings.SplitSeq(usages, ",") {
			usageLines = append(usageLines, `        "`+strings.TrimSpace(u)+`",`)
		}

		usagesBlock = `
      usages = [
` + strings.Join(usageLines, "\n") + `
      ]`
	}

	return `resource "kubernetes_manifest" "certificate_` + appName + `_tls" {
  for_each = var.deploy_custom_resources ? toset(["` + appName + `"]) : toset([])

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      labels    = local.labels
      name      = "${local.app_name}-tls-certificates"
      namespace = ` + namespace + `
    }

    spec = {
      commonName = local.app_name
      dnsNames = [
` + dnsLines + `
      ]
      duration = "` + DefaultTLSDuration + `"
      issuerRef = {
        group = "cert-manager.io"
        kind  = "Issuer"
        name  = ` + issuerVar + ` != null ? ` + issuerVar + ` : "${local.app_name}-` + issuerFallback + `"
      }
      privateKey = {
        algorithm = "` + DefaultKeyAlgorithm + `"
        size      = ` + DefaultKeySize + `
      }
      renewBefore    = "` + DefaultTLSRenewBefore + `"
      secretName     = "${local.app_name}-` + secretSuffix + `"
      secretTemplate = {}` + usagesBlock + `
    }
  }
}`
}

// TerraformResourceCACertificate generates a cert-manager CA Certificate resource.
// Parameters:
//   - appName: the application name (e.g., "descheduler")
//   - namespace: namespace reference (e.g., "local.namespace" or "var.namespace")
//   - nameSuffix: suffix for cert name (e.g., "ca" -> "${local.app_name}-ca")
//   - secretName: secret name expression (e.g., "${local.app_name}-ca" or "${var.org}-ca")
//   - issuerVar: variable for issuer name (e.g., "var.selfsigned_issuer_name")
//   - issuerFallback: fallback suffix for issuer (e.g., "selfsigned-issuer")
func TerraformResourceCACertificate(appName, namespace, nameSuffix, secretName, issuerVar, issuerFallback string) string {
	return `resource "kubernetes_manifest" "certificate_` + appName + `_ca" {
  for_each = var.deploy_custom_resources ? toset(["` + appName + `"]) : toset([])

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      labels    = local.labels
      name      = "` + nameSuffix + `"
      namespace = ` + namespace + `
    }
    spec = {
      commonName = local.app_name
      duration   = "` + DefaultCADuration + `"
      isCA       = true
      issuerRef = {
        group = "cert-manager.io"
        kind  = "Issuer"
        name  = ` + issuerVar + ` != null ? ` + issuerVar + ` : "${local.app_name}-` + issuerFallback + `"
      }
      privateKey = {
        algorithm = "` + DefaultKeyAlgorithm + `"
        size      = ` + DefaultKeySize + `
      }
      renewBefore    = "` + DefaultCARenewBefore + `"
      secretName     = "` + secretName + `"
      secretTemplate = {}
    }
  }
}`
}

// buildDNSNames generates DNS name entries for the given services.
// If services is empty, uses local.app_name as the service name.
// Each service gets 3 entries: base, .svc, .svc.cluster_domain.
func buildDNSNames(namespace, services string) string {
	var dnsLines []string

	if services == "" {
		// Default: use app_name as the service
		dnsLines = append(dnsLines,
			`        "${local.app_name}.${`+namespace+`}",`,
			`        "${local.app_name}.${`+namespace+`}.svc",`,
			`        "${local.app_name}.${`+namespace+`}.svc.${var.cluster_domain}",`,
		)
	} else {
		// Multiple services specified
		for svc := range strings.SplitSeq(services, ",") {
			svc = strings.TrimSpace(svc)
			if svc == "" {
				continue
			}

			dnsLines = append(dnsLines,
				`        "${local.app_name}-`+svc+`.${`+namespace+`}",`,
				`        "${local.app_name}-`+svc+`.${`+namespace+`}.svc",`,
				`        "${local.app_name}-`+svc+`.${`+namespace+`}.svc.${var.cluster_domain}",`,
			)
		}
	}

	return strings.Join(dnsLines, "\n")
}

// TerraformResourceTLSCertificates generates both TLS and CA certificate resources.
// Parameters:
//   - appName: the application name (e.g., "descheduler")
//   - namespace: namespace reference (e.g., "local.namespace" or "var.namespace")
//   - services: comma-separated service names for DNS entries (e.g., "" for app_name only)
//   - tlsSecretSuffix: suffix for TLS secret (e.g., "tls")
//   - tlsIssuerVar: variable for TLS issuer (e.g., "var.issuer_name")
//   - tlsIssuerFallback: fallback for TLS issuer (e.g., "issuer")
//   - tlsUsages: comma-separated usages (e.g., "server auth")
//   - caNameSuffix: name suffix for CA cert (e.g., "${local.app_name}-ca")
//   - caSecretName: secret name for CA (e.g., "${local.app_name}-ca" or "${var.org}-ca")
//   - caIssuerVar: variable for CA issuer (e.g., "var.selfsigned_issuer_name")
//   - caIssuerFallback: fallback for CA issuer (e.g., "selfsigned-issuer")
//
//nolint:revive // argument-limit: convenience wrapper combining TLS and CA certificates
func TerraformResourceTLSCertificates(
	appName, namespace, services, tlsSecretSuffix, tlsIssuerVar, tlsIssuerFallback, tlsUsages, caNameSuffix, caSecretName, caIssuerVar, caIssuerFallback string,
) string {
	tlsCert := TerraformResourceTLSCertificate(appName, namespace, services, tlsSecretSuffix, tlsIssuerVar, tlsIssuerFallback, tlsUsages)
	caCert := TerraformResourceCACertificate(appName, namespace, caNameSuffix, caSecretName, caIssuerVar, caIssuerFallback)

	return tlsCert + "\n\n" + caCert
}
