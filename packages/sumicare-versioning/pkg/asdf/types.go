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

// ToolUpdateResult represents the outcome of updating a single asdf-managed tool.
// It tracks version changes and installation status for reporting purposes.
type ToolUpdateResult struct {
	// Name is the asdf plugin/tool name (e.g., "golang", "nodejs", "terraform").
	Name string

	// OldVersion is the version before the update (from .tool-versions).
	OldVersion string

	// NewVersion is the version after the update (latest available or preserved).
	NewVersion string

	// Changed indicates whether the version was actually changed.
	// False when OldVersion equals NewVersion.
	Changed bool

	// Installed indicates whether the new version was installed via `asdf install`.
	// False if the version was already installed or installation was skipped.
	Installed bool
}
