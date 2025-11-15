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

// Core type definitions for version management operations.
type (
	// VersionsFile represents the contents of versions.json, mapping package names
	// to their version strings (e.g., {"compute-keda": "2.11.0", "storage-cnpg": "1.22.0"}).
	VersionsFile map[string]string

	// PackageJSON represents the minimal structure of a package.json file
	// needed for repository root detection.
	PackageJSON struct {
		// Name is the package name (e.g., "@sumicare/terraform-kubernetes-modules").
		Name string `json:"name"`

		// Version is the package version (typically "1.0.0" for the monorepo root).
		Version string `json:"version"`
	}

	// VersionFetcher is a function signature for fetching versions from upstream sources.
	// Implementations fetch from GitHub, Docker Hub, or other version sources.
	//
	// The limit parameter specifies the maximum number of versions to return.
	// Versions should be returned in descending order (newest first).
	VersionFetcher func(limit int) ([]string, error)

	// VersionChange records the result of a version update operation.
	// It tracks both the old and new values to enable reporting and rollback.
	VersionChange struct {
		// OldVersion is the version before the update (empty if newly added).
		OldVersion string

		// NewVersion is the version after the update.
		NewVersion string

		// Changed indicates whether the version actually changed.
		// False when OldVersion equals NewVersion.
		Changed bool
	}
)
