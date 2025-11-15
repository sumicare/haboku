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

import "time"

// Constants for CRD downloading and extraction operations.
const (
	// DirectoryPermissions defines the Unix permission mode for created directories.
	// Uses 0755 (rwxr-xr-x) to allow owner full access and read/execute for others.
	DirectoryPermissions = 0o755

	// FilePermission defines the Unix permission mode for created files.
	// Uses 0600 (rw-------) to restrict access to the owner only.
	FilePermission = 0o600

	// defaultDownloaderTimeout is the HTTP client timeout for all download operations.
	// Set to 30 seconds to allow for large file downloads while preventing hung connections.
	defaultDownloaderTimeout = 30 * time.Second

	// maxConcurrentDownloads limits parallel download operations to prevent
	// overwhelming remote servers and local resources.
	maxConcurrentDownloads = 10

	// defaultBufferSize is the buffer size for YAML scanner operations.
	// Set to 10MB to handle large CRD files that may contain extensive schemas.
	defaultBufferSize = 10 * 1024 * 1024

	// githubAPIBase is the base URL for GitHub REST API v3 endpoints.
	githubAPIBase = "https://api.github.com"

	// githubRawBase is the base URL for raw file content from GitHub repositories.
	githubRawBase = "https://raw.githubusercontent.com"

	// githubTokenEnvVar is the environment variable name for GitHub personal access token.
	// When set, requests include authentication to avoid rate limiting.
	//
	//nolint:gosec // This is the environment variable name, not a credential.
	githubTokenEnvVar = "GITHUB_TOKEN"

	// autoGenLicenseHeader is prepended to all generated Terraform files.
	// It includes the Apache 2.0 license header and a warning not to edit manually.
	autoGenLicenseHeader = `#
# Copyright 2025 Sumicare
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

###           DO NOT EDIT            ###
# This file is automagically generated #

`
)
