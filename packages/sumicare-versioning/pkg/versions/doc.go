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

// Package versions provides utilities for managing software versions in a monorepo.
//
// # Overview
//
// This package handles version management for Kubernetes-related software packages,
// including reading, writing, and synchronizing version information across:
//   - A central versions.json file containing all tracked versions
//   - Individual package.json files in each package directory
//
// # Version Sources
//
// Versions are fetched from various sources using [VersionFetcher] functions:
//   - GitHub releases and tags
//   - Docker Hub image tags
//   - Custom version endpoints
//
// # Synchronization
//
// The package supports two synchronization modes:
//   - Update: Fetches latest versions from upstream and updates all files
//   - Sync: Reads versions.json and propagates to package.json files
//
// # Package Naming
//
// Package names follow the convention: <category>-<name>
// (e.g., "compute-keda", "storage-cnpg", "observability-grafana-operator").
package versions
