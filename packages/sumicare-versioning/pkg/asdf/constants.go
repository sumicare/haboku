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

package asdf

// Constants for asdf tool version management.
const (
	// toolVersionsFile is the default .tool-versions file path relative to the repository root.
	toolVersionsFile = ".tool-versions"

	// DirectoryPermissions is the Unix permission mode for created directories (rwxr-xr-x).
	DirectoryPermissions = 0o755

	// FilePermission is the Unix permission mode for created files (rw-------).
	FilePermission = 0o600
)
