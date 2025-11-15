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

package pkg

import "strings"

// Repos returns a map of repository URLs for different components.
func Repos() map[string]string {
	projConfigs := GetProjects()
	repos := make(map[string]string, len(projConfigs))

	//nolint:gocritic // rangeValCopy: map of structs, copying is acceptable here
	for name, config := range projConfigs {
		// Skip Fixed/empty URLs unless needed?
		// The original map included them.
		if config.URL == "" || !strings.HasPrefix(config.URL, "http") {
			continue
		}

		repos[name] = config.URL
	}

	return repos
}
