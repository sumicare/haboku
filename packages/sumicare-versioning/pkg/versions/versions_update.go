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

package versions

import (
	"bytes"
	"encoding/json"
	"fmt"
	"maps"
	"os"
	"strings"
	"sync"

	"sumi.care/util/sumicare-versioning/pkg"
)

// GetPreservedVersion returns a preserved version for packages that don't follow
// standard semver resolution. Returns an empty string if the package should use
// normal semver-based version fetching.
//
// Special handling:
//   - "rust": Always returns "nightly" (Rust nightly toolchain)
//   - "debian": Preserves existing non-semver versions containing hyphens
//     (e.g., "trixie-20251117-slim") to avoid overwriting codename-based tags
func GetPreservedVersion(packageName, currentVersion string) string {
	switch packageName {
	case "rust":
		return "nightly"
	case "debian":
		// Preserve debian versions that don't follow semver (contain hyphens with dates/codenames)
		if strings.Contains(currentVersion, "-") {
			return currentVersion
		}
	}

	return ""
}

// GetProjectFetchers returns the mapping of package names to their [VersionFetcher] functions.
// This is the central registry of all packages that have automated version tracking.
//
// Each fetcher function retrieves the latest version(s) from the package's upstream source
// (typically GitHub releases or tags).
func GetProjectFetchers() map[string]VersionFetcher {
	projects := pkg.GetProjects()
	fetchers := make(map[string]VersionFetcher, len(projects))

	//nolint:gocritic // rangeValCopy: map of structs
	for name, config := range projects {
		// capture loop variable
		fetchers[name] = func(limit int) ([]string, error) {
			return pkg.GetVersion(&config, limit)
		}
	}

	return fetchers
}

// FindMissingProjects returns a list of package names that are registered in
// [GetProjectFetchers] but don't have entries in the provided versions map.
func FindMissingProjects(versions VersionsFile) []string {
	var missing []string
	for projectName := range GetProjectFetchers() {
		if _, ok := versions[projectName]; !ok {
			missing = append(missing, projectName)
		}
	}

	return missing
}

// FetchMissingVersions fetches versions for projects missing from the versions map
// and adds them to the map. Uses [GetProjectFetchers] to get the fetcher functions.
//
// Returns the list of project names that were missing (regardless of fetch success).
func FetchMissingVersions(versions VersionsFile) []string {
	return FetchMissingVersionsWithFetchers(versions, GetProjectFetchers())
}

// FetchMissingVersionsWithFetchers fetches versions using the provided fetchers map.
// Fetches are performed in parallel using goroutines for better performance.
//
// Successfully fetched versions are added directly to the versions map.
// Failed fetches are silently skipped (the project remains missing from the map).
func FetchMissingVersionsWithFetchers(versions VersionsFile, fetchers map[string]VersionFetcher) []string {
	var missingProjects []string
	for name := range fetchers {
		if _, ok := versions[name]; !ok {
			missingProjects = append(missingProjects, name)
		}
	}

	if len(missingProjects) == 0 {
		return missingProjects
	}

	var (
		mu sync.Mutex
		wg sync.WaitGroup
	)

	for _, name := range missingProjects {
		// capture loop variable
		wg.Go(func() {
			fetchedVersions, err := fetchers[name](1)
			if err != nil || len(fetchedVersions) == 0 {
				return
			}

			mu.Lock()

			versions[name] = fetchedVersions[0]

			mu.Unlock()
		})
	}

	wg.Wait()

	return missingProjects
}

// UpdateVersionsJSON merges the given versions into the existing versions.json file.
// Existing versions are preserved; new versions are added or updated.
// The file is written with sorted keys and pretty-printed JSON.
func UpdateVersionsJSON(versions VersionsFile) error {
	existing := make(VersionsFile)
	if data, err := os.ReadFile(VersionsFileName); err == nil {
		err := json.Unmarshal(data, &existing)
		if err != nil {
			return fmt.Errorf("unmarshal existing versions: %w", err)
		}
	}

	maps.Copy(existing, versions)

	var buf bytes.Buffer

	enc := json.NewEncoder(&buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")

	err := enc.Encode(existing)
	if err != nil {
		return fmt.Errorf("encode versions: %w", err)
	}

	err = os.WriteFile(VersionsFileName, buf.Bytes(), FilePermissions)
	if err != nil {
		return fmt.Errorf("write versions file: %w", err)
	}

	return nil
}
