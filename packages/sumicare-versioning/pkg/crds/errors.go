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

import "errors"

// Sentinel errors for CRD downloading operations.
var (
	// ErrNoSourceConfigured indicates that a [Source] has no download method configured.
	// At least one of HelmRepo, GitHubDir, or CRDURLs must be set.
	ErrNoSourceConfigured = errors.New("no CRD source configured")

	// ErrDownloadFailed is a wrapper error indicating one or more CRD downloads failed.
	// The underlying errors provide details about specific failures.
	ErrDownloadFailed = errors.New("errors downloading CRDs")

	// ErrHTTPResponse indicates an HTTP request returned a non-200 status code.
	// The error message includes the status code and response body when available.
	ErrHTTPResponse = errors.New("HTTP error response")

	// ErrGitHubDirNil indicates the [GitHubCRDDir] configuration is nil.
	ErrGitHubDirNil = errors.New("GitHubCRDDir is nil")

	// ErrNoFilesMatch indicates no files in the GitHub directory matched the file pattern.
	ErrNoFilesMatch = errors.New("no files matching pattern in repository")

	// ErrFailedToListDir indicates the GitHub API directory listing request failed.
	ErrFailedToListDir = errors.New("failed to list directory")

	// ErrFailedToCreateReq indicates an HTTP request could not be constructed.
	ErrFailedToCreateReq = errors.New("failed to create request")

	// ErrFailedToDecodeResp indicates JSON decoding of an API response failed.
	ErrFailedToDecodeResp = errors.New("failed to decode response body")

	// ErrFailedToReadResp indicates reading the HTTP response body failed.
	ErrFailedToReadResp = errors.New("failed to read response body")

	// ErrInvalidPattern indicates the file glob pattern is malformed.
	ErrInvalidPattern = errors.New("invalid pattern")

	// ErrOCIUnsupported indicates OCI registry URLs are not supported for CRD extraction.
	// OCI charts require the helm CLI for proper authentication and pulling.
	ErrOCIUnsupported = errors.New("OCI registries not supported")

	// ErrChartNotFound indicates the requested chart was not found in the repository index.
	ErrChartNotFound = errors.New("chart not found")

	// ErrNoChartURL indicates the chart entry in index.yaml has no download URLs.
	ErrNoChartURL = errors.New("no URL found for chart")

	// ErrInvalidPath indicates a path traversal attempt was detected during archive extraction.
	// This is a security measure to prevent writing files outside the target directory.
	ErrInvalidPath = errors.New("invalid path")

	// ErrNoCRDsFound indicates no CustomResourceDefinition resources were found
	// in the chart's crds/ or templates/ directories.
	ErrNoCRDsFound = errors.New("no CRDs found in chart")

	// ErrFileTooLarge indicates a single file in the archive exceeds the maximum allowed size.
	// This prevents decompression bombs from consuming excessive memory.
	ErrFileTooLarge = errors.New("file exceeds maximum size limit")

	// ErrArchiveTooLarge indicates the total extracted content exceeds the maximum allowed size.
	// This prevents decompression bombs from consuming excessive disk space.
	ErrArchiveTooLarge = errors.New("archive exceeds maximum size limit")

	// ErrFileSizeMismatch indicates the extracted file size doesn't match the tar header.
	// This may indicate archive corruption or a truncated download.
	ErrFileSizeMismatch = errors.New("file size mismatch")
)
