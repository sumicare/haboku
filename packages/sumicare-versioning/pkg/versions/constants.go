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

// Constants for version management operations.
const (
	// ExpectedPackageName is the package name in the root package.json that identifies
	// the repository root. Used by [EnsureCorrectDirectory] to locate the monorepo root.
	ExpectedPackageName = "@sumicare/terraform-kubernetes-modules"

	// RootPackageJSONPath is the relative path to the root package.json file.
	RootPackageJSONPath = "package.json"

	// VersionsFileName is the name of the central versions tracking file.
	VersionsFileName = "versions.json"

	// DirectoryPermissions is the Unix permission mode for created directories (rwxr-xr-x).
	DirectoryPermissions = 0o755

	// FilePermissions is the Unix permission mode for created files (rw-------).
	FilePermissions = 0o600
)
