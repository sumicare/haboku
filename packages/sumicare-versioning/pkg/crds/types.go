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

// Type definitions for CRD downloading and extraction operations.
//
// These types define the configuration and data structures used throughout
// the crds package for downloading CRDs from various sources.
type (
	// Source represents a fully-resolved CRD source ready for downloading.
	// It contains all the information needed to fetch CRDs and write them
	// to the target directory.
	//
	// A Source is typically created from a [SourceConfig] via the toSource method,
	// which computes the target directory based on package naming conventions.
	Source struct {
		// HelmRepo specifies the Helm repository to download from.
		// Mutually exclusive with GitHubDir and CRDURLs.
		HelmRepo *HelmRepo

		// GitHubDir specifies the GitHub directory to download from.
		// Mutually exclusive with HelmRepo and CRDURLs.
		GitHubDir *GitHubCRDDir

		// CRDURLs maps output filenames to direct download URLs.
		// Mutually exclusive with HelmRepo and GitHubDir.
		CRDURLs map[string]string

		// Name is the short name of the component (e.g., "keda", "cert-manager").
		Name string

		// TargetDir is the absolute path where CRD files will be written.
		TargetDir string

		// ChartName is the Helm chart name when using HelmRepo.
		ChartName string

		// ChartVersion is the specific chart version to download.
		// If empty, the latest version is used.
		ChartVersion string

		// SkipDownload indicates that this source should be skipped entirely.
		// Useful for temporarily disabling problematic sources.
		SkipDownload bool

		// AllowEmptyCRDs indicates that empty CRD sets are acceptable.
		// When true, an empty crds.tf placeholder is created instead of failing.
		AllowEmptyCRDs bool
	}

	// GitHubCRDDir represents a GitHub repository directory containing CRD files.
	// It provides configuration for downloading CRDs directly from GitHub
	// using the GitHub API for directory listing and raw content endpoints
	// for file downloads.
	GitHubCRDDir struct {
		// Owner is the GitHub repository owner (user or organization).
		Owner string

		// Repo is the GitHub repository name.
		Repo string

		// Path is the directory path within the repository (e.g., "config/crd/bases").
		Path string

		// Ref is the Git reference (branch, tag, or commit SHA).
		// Defaults to "main" if empty.
		Ref string

		// FilePattern is a glob pattern to filter files (e.g., "*.yaml", "*-crd.yaml").
		// Defaults to "*.yaml" if empty.
		FilePattern string

		// FilterCRDsOnly, when true, filters downloaded YAML files to only include
		// documents with kind: CustomResourceDefinition. Useful for directories
		// that contain mixed resource types.
		FilterCRDsOnly bool

		// StripHelmTemplates, when true, removes Helm template syntax ({{ }})
		// from downloaded files. Useful for CRDs stored in Helm chart templates
		// directories that contain Helm-specific annotations.
		StripHelmTemplates bool
	}

	// HelmRepo represents a Helm chart repository configuration.
	// It supports both traditional HTTP repositories and OCI registries,
	// though OCI registry support is limited.
	HelmRepo struct {
		// Name is a human-readable repository name for logging purposes.
		Name string

		// URL is the repository base URL.
		// For HTTP repos: "https://charts.example.com/"
		// For OCI repos: "oci://registry.example.com/charts"
		URL string

		// IsOCI indicates whether this is an OCI registry.
		// OCI registries have limited support and may create placeholder files.
		IsOCI bool
	}

	// HelmRepoIndex represents the index.yaml structure of a Helm repository.
	// This is the standard format used by Helm to list available charts.
	HelmRepoIndex struct {
		// Entries maps chart names to their available versions.
		Entries map[string][]HelmChartMetadata `yaml:"entries"`

		// APIVersion is the Helm repository API version (typically "v1").
		APIVersion string `yaml:"apiVersion"`
	}

	// HelmChartMetadata represents metadata for a single chart version
	// as found in the Helm repository index.yaml file.
	HelmChartMetadata struct {
		// Name is the chart name.
		Name string `yaml:"name"`

		// Version is the chart version (SemVer).
		Version string `yaml:"version"`

		// AppVersion is the version of the application packaged in the chart.
		AppVersion string `yaml:"appVersion"`

		// Digest is the SHA256 digest of the chart archive.
		Digest string `yaml:"digest"`

		// Description is a brief description of the chart.
		Description string `yaml:"description"`

		// URLs contains download URLs for the chart archive.
		// Usually contains a single URL, either absolute or relative to the repo.
		URLs []string `yaml:"urls"`
	}

	// ChartYAML represents the Chart.yaml file structure found inside
	// a Helm chart archive. Used for parsing chart metadata after extraction.
	ChartYAML struct {
		// APIVersion is the chart API version ("v1" or "v2").
		APIVersion string `yaml:"apiVersion"`

		// Name is the chart name.
		Name string `yaml:"name"`

		// Version is the chart version.
		Version string `yaml:"version"`

		// AppVersion is the application version.
		AppVersion string `yaml:"appVersion"`

		// Description is the chart description.
		Description string `yaml:"description"`
	}
)
