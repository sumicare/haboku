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

const (
	// newNewLine is a constant for a double newline.
	newNewLine = "\n\n"
	// localAppName is the Terraform local variable reference for app name.
	localAppName = "local.app_name"
)

// snakeToCamelCase converts snake_case to CamelCase.
func snakeToCamelCase(s string) string {
	parts := strings.Split(s, "_")
	for i, part := range parts {
		if part != "" {
			parts[i] = strings.ToUpper(string(part[0])) + part[1:]
		}
	}

	return strings.Join(parts, "")
}
