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

package crds

import (
	"bufio"
	"fmt"
	"regexp"
	"strings"
)

// unknownCRDName is the fallback name used when a CRD's metadata.name cannot be extracted.
const unknownCRDName = "unknown-crd"

// ExtractCRDsFromContent parses multi-document YAML content and extracts
// individual CustomResourceDefinition documents.
//
// This is the public API for CRD extraction, wrapping the internal splitMultiDocYAML function.
// Each CRD is keyed by its metadata.name with a .yaml extension.
//
// Non-CRD documents in the input are silently ignored.
func ExtractCRDsFromContent(content string) (map[string]string, error) {
	//nolint:wrapcheck // Error propagation is intentional for this wrapper.
	return splitMultiDocYAML(content)
}

// splitMultiDocYAML splits multi-document YAML content (separated by "---") into
// individual CRD documents. Only documents with kind: CustomResourceDefinition
// are included in the result.
//
// Returns a map where keys are "{crd-name}.yaml" and values are the YAML content.
func splitMultiDocYAML(content string) (map[string]string, error) {
	crds := make(map[string]string)
	scanner := bufio.NewScanner(strings.NewReader(content))
	buf := make([]byte, 0, defaultBufferSize)
	scanner.Buffer(buf, defaultBufferSize)

	var docBuilder strings.Builder

	for scanner.Scan() {
		line := scanner.Text()
		if strings.TrimSpace(line) == "---" {
			// Process the completed document
			if doc := strings.TrimSpace(docBuilder.String()); doc != "" {
				// Only include CustomResourceDefinition resources
				if isCRD, name := extractCRDInfo(doc); isCRD {
					crds[name+".yaml"] = doc
				}
			}

			docBuilder.Reset()
		} else {
			docBuilder.WriteString(line)
			docBuilder.WriteString("\n")
		}
	}

	// Handle last document
	if doc := strings.TrimSpace(docBuilder.String()); doc != "" {
		if isCRD, name := extractCRDInfo(doc); isCRD {
			crds[name+".yaml"] = doc
		}
	}

	err := scanner.Err()
	if err != nil {
		return nil, fmt.Errorf("failed to split multi-document YAML: %w", err)
	}

	return crds, nil
}

// extractCRDInfo determines if a YAML document is a CustomResourceDefinition
// and extracts its name from metadata.name.
//
// Detection is based on:
//   - Presence of "kind: CustomResourceDefinition"
//   - Presence of "apiextensions.k8s.io" API group with "CustomResourceDefinition"
//
// Returns (true, name) for CRDs, or (false, "") for non-CRD documents.
func extractCRDInfo(content string) (bool, string) {
	isCRD := strings.Contains(content, "kind: CustomResourceDefinition")

	// Also check apiVersion to handle cases where kind might be on a different line
	if strings.Contains(content, "apiextensions.k8s.io") && strings.Contains(content, "CustomResourceDefinition") {
		isCRD = true
	}

	if !isCRD {
		return false, ""
	}

	return true, extractCRDName(content)
}

// extractCRDName extracts the CRD name from the metadata.name field in YAML content.
// It searches for the first "name:" field after "metadata:" to handle nested structures.
// Returns [unknownCRDName] if the name cannot be extracted.
func extractCRDName(content string) string {
	metadataIdx := strings.Index(content, "metadata:")
	if metadataIdx == -1 {
		return unknownCRDName
	}

	searchStart := metadataIdx + len("metadata:")

	nameIdx := strings.Index(content[searchStart:], "name:")
	if nameIdx == -1 {
		return unknownCRDName
	}

	nameIdx += searchStart

	lineStart := nameIdx + len("name:")

	lineEnd := strings.Index(content[lineStart:], "\n")
	if lineEnd == -1 {
		lineEnd = len(content) - lineStart
	}

	name := strings.TrimSpace(content[lineStart : lineStart+lineEnd])

	name = strings.Trim(name, "\"'")

	if name == "" {
		return unknownCRDName
	}

	return name
}

// helmTemplateLineRegex matches entire lines containing Helm template syntax ({{ ... }}).
var helmTemplateLineRegex = regexp.MustCompile(`(?m)^.*\{\{.*\}\}.*$\n?`)

// stripHelmTemplates removes lines containing Helm template syntax from YAML content.
// This is necessary for CRD files stored in Helm chart templates/ directories that
// contain Helm-specific annotations or conditional fields.
//
// The function also cleans up:
//   - Empty annotation blocks left after removing template lines
//   - Multiple consecutive blank lines
func stripHelmTemplates(content string) string {
	// Remove lines containing {{ ... }}
	result := helmTemplateLineRegex.ReplaceAllString(content, "")

	// Clean up any resulting empty annotation blocks
	// e.g., "annotations:\n  " with nothing after
	emptyAnnotationsRegex := regexp.MustCompile(`(?m)^\s*annotations:\s*$\n(\s*$\n)*`)

	result = emptyAnnotationsRegex.ReplaceAllString(result, "")

	// Remove multiple consecutive blank lines
	multiBlankRegex := regexp.MustCompile(`\n{3,}`)

	result = multiBlankRegex.ReplaceAllString(result, "\n\n")

	return strings.TrimSpace(result)
}

// generateTerraform creates Terraform configuration content for the given CRDs.
// It generates kubernetes_manifest resources that load CRD YAML files using yamldecode.
//
// The output includes the Apache 2.0 license header and a "DO NOT EDIT" warning.
// Resource names are derived from filenames with dots and hyphens replaced by underscores.
func generateTerraform(crds map[string]string) string {
	var sb strings.Builder
	sb.WriteString(autoGenLicenseHeader)

	for filename := range crds {
		resourceName := strings.TrimSuffix(filename, ".yaml")

		resourceName = strings.ReplaceAll(resourceName, ".", "_")
		resourceName = strings.ReplaceAll(resourceName, "-", "_")

		sb.WriteString(fmt.Sprintf(`resource "kubernetes_manifest" "customresourcedefinition_%s" {
  manifest = yamldecode(file("${path.module}/%s"))
}

`, resourceName, filename))
	}

	return sb.String()
}
