#!/usr/bin/env bash
set -euo pipefail

# WARNING: left for future reference, may be used to update existing charts

cd "$(dirname "$0")" || exit 1

rm -f ../output.tf

curl https://storage.googleapis.com/tekton-releases/operator/latest/release.yaml |
  awk '
    BEGIN {
        skip_resource = 0
        resource_content = ""
        current_api_version = ""
        current_kind = ""
    }
    /^---$/ {
        if (!skip_resource && resource_content != "" && current_kind != "") {
            print resource_content
        }
        resource_content = ""
        skip_resource = 0
        current_api_version = ""
        current_kind = ""
    }
    /^apiVersion:/ {
        current_api_version = $2
        resource_content = resource_content $0 "\n"
        next
    }
    /^kind:/ {
        current_kind = $2
        resource_content = resource_content $0 "\n"
        
        # Skip CRDs and custom resources (keep only standard k8s resources)
        is_crd = (index(current_api_version, "apiextensions.k8s.io") > 0)
        has_domain = (index(current_api_version, ".") > 0 && index(current_api_version, "/") > 0)
        is_standard_api = (current_api_version ~ /^(v1|apps\/v1|batch\/v1|policy\/v1|autoscaling\/v[12])$/ || \
                          index(current_api_version, "rbac.authorization.k8s.io") > 0 || \
                          index(current_api_version, "networking.k8s.io") > 0)
        is_non_standard_kind = (current_kind == "ServiceMonitor" || current_kind == "CiliumNetworkPolicy" || \
                                current_kind == "Certificate" || current_kind == "Issuer" || \
                                current_kind == "ClusterIssuer" || current_kind == "CertificateRequest")
        
        # Skip if: CRD, or custom resource (has domain but not standard k8s API), or non-standard kind
        if (is_crd || (has_domain && !is_standard_api) || is_non_standard_kind) {
            skip_resource = 1
        }
        next
    }
    !skip_resource {
        resource_content = resource_content $0 "\n"
    }
    END {
        if (!skip_resource && resource_content != "" && current_kind != "") {
            print resource_content
        }
    }' | k2tf --include-unsupported -o ../output.tf

# Extract custom resources from helm template
curl https://storage.googleapis.com/tekton-releases/operator/latest/release.yaml |
  awk '
        BEGIN {
            include_resource = 0
            resource_content = ""
            current_api_version = ""
            current_kind = ""
        }
        /^---$/ {
            if (include_resource && resource_content != "") {
                print resource_content
            }
            resource_content = ""
            include_resource = 0
            current_api_version = ""
            current_kind = ""
        }
        /^apiVersion:/ {
            current_api_version = $2
            resource_content = resource_content $0 "\n"
        }
        /^kind:/ {
            current_kind = $2
            resource_content = resource_content $0 "\n"
            
            # Include if:
            # 1. API version contains a domain (e.g., keda.sh, monitoring.coreos.com) - custom resources
            # 2. Non-standard kinds like ServiceMonitor, CiliumNetworkPolicy, etc.
            # Exclude:
            # 1. CRDs themselves (apiextensions.k8s.io)
            # 2. Standard k8s resources (v1, apps/v1, batch/v1, etc. without domain)
            
            is_crd = (index(current_api_version, "apiextensions.k8s.io") > 0)
            has_domain = (index(current_api_version, ".") > 0 && index(current_api_version, "/") > 0)
            # Check for standard k8s APIs (without domain or with k8s.io domain)
            is_standard_api = (current_api_version ~ /^(v1|apps\/v1|batch\/v1|policy\/v1|autoscaling\/v[12])$/ || \
                              index(current_api_version, "rbac.authorization.k8s.io") > 0 || \
                              index(current_api_version, "networking.k8s.io") > 0)
            
            # Include custom resources (has domain, not CRD, not standard k8s API)
            if (!is_crd && has_domain && !is_standard_api) {
                include_resource = 1
                resource_content = "---\n" resource_content
            }
            next
        }
        include_resource || current_api_version == "" {
            resource_content = resource_content $0 "\n"
        }
        END {
            if (include_resource && resource_content != "") {
                print resource_content
            }
        }' | tfk8s --strip >../cr.tf
