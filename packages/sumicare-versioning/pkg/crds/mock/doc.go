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

// Package mock provides HTTP test servers for testing CRD downloading functionality.
// It includes mocks for GitHub API, Helm chart repositories, and direct URL downloads.
package mock

import (
	"fmt"
	"strings"
)

// generateCRD creates a CRD YAML string for the given name.
func generateCRD(crdName string) string {
	kind := strings.Split(crdName, ".")[0]

	return fmt.Sprintf(`apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: %s
spec:
  group: example.com
  names:
    kind: %s
    plural: %ss
  scope: Namespaced
  versions:
    - name: v1
      served: true
      storage: true
`, crdName, kind, strings.ToLower(kind))
}
