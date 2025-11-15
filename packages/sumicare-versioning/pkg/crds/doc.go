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

// Package crds provides Kubernetes Custom Resource Definition (CRD) downloading
// and extraction capabilities without requiring external CLI tools like helm.
//
// # Overview
//
// This package supports downloading CRDs from multiple sources:
//   - Helm chart repositories (via HTTP, extracting from tar.gz archives)
//   - GitHub repositories (via GitHub API and raw content endpoints)
//   - Direct URLs (for standalone CRD YAML files)
//
// # Architecture
//
// The package uses a [Downloader] as the main entry point, which coordinates
// three specialized downloaders:
//   - [helmDownloader]: Fetches and extracts CRDs from Helm chart archives
//   - [githubDownloader]: Downloads CRDs from GitHub repository directories
//   - [urlDownloader]: Fetches CRDs from direct URLs
//
// # Security
//
// The package implements several security measures:
//   - Decompression bomb protection via size limits on archives
//   - Path traversal prevention when extracting archives
//   - File size validation during extraction
//   - GitHub token authentication support to avoid rate limiting
//
// # Usage
//
// Basic usage to download all configured CRDs:
//
//	downloader := crds.NewDownloader()
//	ctx := context.Background()
//	err := downloader.DownloadAll(ctx, "packages")
//
// The downloaded CRDs are written to target directories along with generated
// Terraform manifests (crds.tf) for declarative Kubernetes resource management.
//
// # Configuration
//
// CRD sources are configured in [sources.go] using [SourceConfig] structs.
// Each source specifies the package name, download method, and any special
// handling requirements (e.g., filtering for CRDs only, stripping Helm templates).
package crds
