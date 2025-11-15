#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.." || exit 1

OUTPUT_FILE="output.tf"

if [ ! -f "$OUTPUT_FILE" ]; then
  echo "Error: $OUTPUT_FILE not found"
  exit 1
fi

echo "Splitting $OUTPUT_FILE into separate files..."

# Create other directory for unmatched resources if it doesn't exist
mkdir -p other

# Function to extract resources by type and write to file
extract_resources() {
  local resource_type=$1
  local output_file=$2
  local header=$3

  # Skip if file already exists
  if [ -f "$output_file" ]; then
    echo "  Skipped $output_file (already exists)"
    return
  fi

  # Use awk to extract resources of specific type
  awk -v type="$resource_type" -v header="$header" '
		BEGIN {
			in_resource = 0
			resource_content = ""
			brace_count = 0
			found_any = 0
		}
		/^resource "'"$resource_type"'"/ {
			in_resource = 1
			resource_content = $0 "\n"
			brace_count = 0
			next
		}
		in_resource {
			resource_content = resource_content $0 "\n"
			# Count braces to track nesting
			for (i = 1; i <= length($0); i++) {
				c = substr($0, i, 1)
				if (c == "{") brace_count++
				if (c == "}") brace_count--
			}
			# When we close the resource block
			if (brace_count < 0) {
				if (!found_any && header != "") {
					print header
				}
				print resource_content
				found_any = 1
				in_resource = 0
				resource_content = ""
				brace_count = 0
			}
		}
	' "$OUTPUT_FILE" >"$output_file"

  # Remove file if empty
  if [ ! -s "$output_file" ]; then
    rm -f "$output_file"
  else
    echo "  Created $output_file"
  fi
}

# Header comment
HEADER='/*
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

'

# Extract grouped resources
echo "Extracting grouped resources..."

# RBAC resources (ClusterRole, ClusterRoleBinding, Role, RoleBinding)
if [ ! -f rbac.tf ]; then
  {
    echo "$HEADER"
    awk '
			BEGIN {
				in_resource = 0
				resource_content = ""
				brace_count = 0
			}
			/^resource "kubernetes_(cluster_role|role)/ {
				in_resource = 1
				resource_content = $0 "\n"
				brace_count = 0
				next
			}
			in_resource {
				resource_content = resource_content $0 "\n"
				for (i = 1; i <= length($0); i++) {
					c = substr($0, i, 1)
					if (c == "{") brace_count++
					if (c == "}") brace_count--
				}
				if (brace_count < 0) {
					print resource_content
					in_resource = 0
					resource_content = ""
					brace_count = 0
				}
			}
		' "$OUTPUT_FILE"
  } >rbac.tf

  if [ -s rbac.tf ]; then
    echo "  Created rbac.tf"
  else
    rm -f rbac.tf
  fi
else
  echo "  Skipped rbac.tf (already exists)"
fi

# ServiceAccounts
extract_resources "kubernetes_service_account" "serviceaccount.tf" "$HEADER"

# Secrets
extract_resources "kubernetes_secret" "secret.tf" "$HEADER"

# ConfigMaps
extract_resources "kubernetes_config_map" "configmap.tf" "$HEADER"

# NetworkPolicies
extract_resources "kubernetes_network_policy" "networkpolicy.tf" "$HEADER"

# PodDisruptionBudgets
extract_resources "kubernetes_pod_disruption_budget" "pdb.tf" "$HEADER"

# Services
extract_resources "kubernetes_service" "service.tf" "$HEADER"

# Deployments
extract_resources "kubernetes_deployment" "deployment.tf" "$HEADER"

# StatefulSets
extract_resources "kubernetes_stateful_set" "statefulset.tf" "$HEADER"

# Ingresses
extract_resources "kubernetes_ingress" "ingress.tf" "$HEADER"

# HorizontalPodAutoscalers
extract_resources "kubernetes_horizontal_pod_autoscaler" "hpa.tf" "$HEADER"

# Extract remaining unmatched resources to other/ directory
echo ""
echo "Extracting unmatched resources to other/ directory..."

# List of already extracted resource types
EXTRACTED_TYPES=(
  "kubernetes_cluster_role"
  "kubernetes_cluster_role_binding"
  "kubernetes_role"
  "kubernetes_role_binding"
  "kubernetes_service_account"
  "kubernetes_secret"
  "kubernetes_config_map"
  "kubernetes_network_policy"
  "kubernetes_pod_disruption_budget"
  "kubernetes_service"
  "kubernetes_deployment"
  "kubernetes_stateful_set"
  "kubernetes_ingress"
  "kubernetes_horizontal_pod_autoscaler"
)

# Build regex pattern for extracted types
PATTERN=$(
  IFS="|"
  echo "${EXTRACTED_TYPES[*]}"
)

# Extract each unmatched resource to its own file
awk -v pattern="$PATTERN" -v header="$HEADER" '
	BEGIN {
		in_resource = 0
		resource_content = ""
		brace_count = 0
		resource_type = ""
		resource_name = ""
	}
	/^resource "/ {
		# Extract resource type and name
		match($0, /^resource "([^"]+)" "([^"]+)"/, arr)
		resource_type = arr[1]
		resource_name = arr[2]
		
		# Check if this type should be skipped (already extracted)
		if (resource_type ~ "^(" pattern ")$") {
			next
		}
		
		in_resource = 1
		resource_content = header "\n" $0 "\n"
		brace_count = 0
		next
	}
	in_resource {
		resource_content = resource_content $0 "\n"
		# Count braces to track nesting
		for (i = 1; i <= length($0); i++) {
			c = substr($0, i, 1)
			if (c == "{") brace_count++
			if (c == "}") brace_count--
		}
		# When we close the resource block
		if (brace_count < 0) {
			# Write to file: other/{resource_name}.tf
			filename = "other/" resource_name ".tf"
			# Check if file already exists
			if (system("test -f " filename) == 0) {
				print "  Skipped " filename " (already exists)"
			} else {
				print resource_content > filename
				close(filename)
				print "  Created " filename
			}
			in_resource = 0
			resource_content = ""
			brace_count = 0
		}
	}
' "$OUTPUT_FILE"

echo ""
echo "Removing extracted resources from $OUTPUT_FILE..."

# Create a temporary file with only non-extracted resources
TEMP_FILE="${OUTPUT_FILE}.tmp"

# Build pattern for all extracted types (including RBAC)
ALL_EXTRACTED_TYPES=(
  "kubernetes_cluster_role"
  "kubernetes_cluster_role_binding"
  "kubernetes_role"
  "kubernetes_role_binding"
  "kubernetes_service_account"
  "kubernetes_secret"
  "kubernetes_config_map"
  "kubernetes_network_policy"
  "kubernetes_pod_disruption_budget"
  "kubernetes_service"
  "kubernetes_deployment"
  "kubernetes_stateful_set"
  "kubernetes_ingress"
  "kubernetes_horizontal_pod_autoscaler"
)

ALL_PATTERN=$(
  IFS="|"
  echo "${ALL_EXTRACTED_TYPES[*]}"
)

# Keep only resources that were NOT extracted
awk -v pattern="$ALL_PATTERN" '
	BEGIN {
		in_resource = 0
		resource_content = ""
		brace_count = 0
		resource_type = ""
		skip_resource = 0
	}
	/^resource "/ {
		# Extract resource type
		match($0, /^resource "([^"]+)"/, arr)
		resource_type = arr[1]
		
		# Check if this type was extracted
		if (resource_type ~ "^(" pattern ")$") {
			skip_resource = 1
			in_resource = 1
			brace_count = 0
			next
		}
		
		# Not extracted, keep it
		skip_resource = 0
		in_resource = 1
		resource_content = $0 "\n"
		brace_count = 0
		next
	}
	in_resource {
		if (skip_resource) {
			# Count braces to know when resource ends
			for (i = 1; i <= length($0); i++) {
				c = substr($0, i, 1)
				if (c == "{") brace_count++
				if (c == "}") brace_count--
			}
			if (brace_count < 0) {
				in_resource = 0
				skip_resource = 0
				brace_count = 0
			}
		} else {
			# Keep this resource
			resource_content = resource_content $0 "\n"
			for (i = 1; i <= length($0); i++) {
				c = substr($0, i, 1)
				if (c == "{") brace_count++
				if (c == "}") brace_count--
			}
			if (brace_count < 0) {
				print resource_content
				in_resource = 0
				resource_content = ""
				brace_count = 0
			}
		}
		next
	}
	!in_resource {
		print
	}
' "$OUTPUT_FILE" >"$TEMP_FILE"

# Replace original file with cleaned version
mv "$TEMP_FILE" "$OUTPUT_FILE"

# Remove output.tf if it's empty (after trimming whitespace, linebreaks, and tabs)
if [[ -f "$OUTPUT_FILE" ]] && [[ -z "$(tr -d '[:space:]' <"$OUTPUT_FILE")" ]]; then
  rm "$OUTPUT_FILE"
  echo "  Removed empty $OUTPUT_FILE"
fi

echo ""
echo "Split complete!"
