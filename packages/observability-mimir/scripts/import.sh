#!/usr/bin/env bash
set -euo pipefail

# WARNING: left for future reference, may be used to update existing charts

cd "$(dirname "$0")" || exit 1

rm -f ../output.tf

# Extract all other standard k8s resources (excluding ConfigMaps)
helm template grafana/mimir-distributed --namespace mimir --api-versions autoscaling.k8s.io/v1 --api-versions autoscaling/v2 --api-versions keda.sh/v1alpha1 --values values.yaml |
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
        
        # List of kinds that k2tf cannot parse (based on actual k2tf errors)
        unsupported_kinds = "CustomResourceDefinition|BackendTLSPolicy|Certificate|ExternalSecret|GRPCRoute|HTTPRoute|VerticalPodAutoscaler|ServiceMonitor|CiliumNetworkPolicy|Issuer|ClusterIssuer|CertificateRequest|FelixConfiguration"
        
        # Skip if kind is in unsupported list
        if (current_kind ~ "^(" unsupported_kinds ")$") {
            skip_resource = 1
        }
        
        # Skip ConfigMaps (handled separately with tfk8s)
        if (current_kind == "ConfigMap") {
            skip_resource = 1
        }
        
        # Also skip any custom API versions (contains domain but not standard k8s)
        has_domain = (index(current_api_version, ".") > 0 && index(current_api_version, "/") > 0)
        is_standard_api = (current_api_version ~ /^(v1|apps\/v1|batch\/v1|policy\/v1)$/ || \
                          index(current_api_version, "rbac.authorization.k8s.io") > 0 || \
                          index(current_api_version, "networking.k8s.io") > 0)
        
        if (has_domain && !is_standard_api) {
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
helm template grafana/mimir-distributed --namespace mimir --api-versions autoscaling.k8s.io/v1 --api-versions autoscaling/v2 --api-versions keda.sh/v1alpha1 --values values.yaml |
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
            
            # List of kinds that tfk8s/k2tf cannot parse (based on actual errors)
            unsupported_kinds = "CustomResourceDefinition|BackendTLSPolicy|Certificate|ExternalSecret|GRPCRoute|HTTPRoute|VerticalPodAutoscaler|ServiceMonitor|CiliumNetworkPolicy|Issuer|ClusterIssuer|CertificateRequest"
            
            # Skip unsupported kinds
            if (current_kind ~ "^(" unsupported_kinds ")$") {
                next
            }
            
            # Include if:
            # 1. API version contains a domain (e.g., keda.sh, monitoring.coreos.com) - custom resources
            # Exclude:
            # 1. CRDs themselves (apiextensions.k8s.io)
            # 2. Standard k8s resources (v1, apps/v1, batch/v1, etc. without domain)
            
            is_crd = (index(current_api_version, "apiextensions.k8s.io") > 0)
            has_domain = (index(current_api_version, ".") > 0 && index(current_api_version, "/") > 0)
            # Check for standard k8s APIs (without domain or with k8s.io domain)
            is_standard_api = (current_api_version ~ /^(v1|apps\/v1|batch\/v1|policy\/v1)$/ || \
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
