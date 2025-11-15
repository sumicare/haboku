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

import "errors"

// Sentinel errors for asdf operations.
var (
	// ErrPluginNotFound indicates a required asdf plugin is not installed.
	// Install the plugin with: asdf plugin add <name>.
	ErrPluginNotFound = errors.New("plugin not found")

	// ErrSourceNotDirectory indicates a path expected to be a directory is not.
	// Used during plugin directory copying operations.
	ErrSourceNotDirectory = errors.New("source is not a directory")

	// ErrFailedToDetermineLatestVersions indicates `asdf list all <tool>` failed
	// or returned no parseable versions for one or more tools.
	ErrFailedToDetermineLatestVersions = errors.New("failed to determine latest versions")

	// ErrNoVersionsFound indicates `asdf list all <tool>` returned no versions.
	// This may indicate the plugin is misconfigured or the tool has no releases.
	ErrNoVersionsFound = errors.New("no versions found")
)
