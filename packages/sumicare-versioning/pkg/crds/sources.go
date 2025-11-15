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

import (
	"path/filepath"
	"strings"
)

// Default values for GitHub source configurations.
const (
	// mainRef is the default Git reference for GitHub repositories.
	mainRef = "main"

	// yamlPattern is the default glob pattern for matching YAML files.
	yamlPattern = "*.yaml"
)

// SourceConfig defines the CRD source configuration for a single package.
// It specifies where to download CRDs from and any special handling requirements.
//
// Package naming follows the convention: <category>-<name>
// (e.g., "compute-kamaji", "security-cert-manager", "storage-cnpg").
//
// Only one of HelmRepo, GitHubDir, or CRDURLs should be set per configuration.
type SourceConfig struct {
	// HelmRepo specifies a Helm chart repository source.
	HelmRepo *HelmRepo

	// GitHubDir specifies a GitHub repository directory source.
	GitHubDir *GitHubCRDDir

	// CRDURLs specifies direct URL sources (filename -> URL).
	CRDURLs map[string]string

	// Package is the full package name (e.g., "compute-kamaji").
	Package string

	// ChartName is the Helm chart name when using HelmRepo.
	ChartName string

	// SkipDownload skips this source entirely when true.
	SkipDownload bool

	// AllowEmptyCRDs creates an empty placeholder instead of failing when no CRDs are found.
	AllowEmptyCRDs bool
}

// GetAllSources returns all configured CRD sources with computed target directories.
//
// Target directories follow the convention:
//
//	{packagesRoot}/{package}/modules/{name}-crds/
//
// For example, "compute-kamaji" becomes "packages/compute-kamaji/modules/kamaji-crds/".
func GetAllSources(packagesRoot string) []Source {
	configs := getAllSourceConfigs()
	sources := make([]Source, 0, len(configs))

	for i := range configs {
		sources = append(sources, configs[i].toSource(packagesRoot))
	}

	return sources
}

// toSource converts a SourceConfig to a fully-resolved [Source] with computed target directory.
// The name is extracted from the package by removing the category prefix (e.g., "compute-kamaji" -> "kamaji").
func (config *SourceConfig) toSource(packagesRoot string) Source {
	// Extract name from package: "compute-kamaji" -> "kamaji"
	name := config.Package
	if idx := strings.Index(config.Package, "-"); idx != -1 {
		name = config.Package[idx+1:]
	}

	return Source{
		Name:           name,
		TargetDir:      filepath.Join(packagesRoot, config.Package, "modules", name+"-crds"),
		HelmRepo:       config.HelmRepo,
		ChartName:      config.ChartName,
		GitHubDir:      config.GitHubDir,
		CRDURLs:        config.CRDURLs,
		SkipDownload:   config.SkipDownload,
		AllowEmptyCRDs: config.AllowEmptyCRDs,
	}
}

// getAllSourceConfigs returns the complete list of CRD source configurations.
// This is the central registry of all packages that have CRDs to download.
//
// Sources are organized by category: Compute, Development, GitOps, MLOps,
// Networking, Observability, Security, and Storage.
func getAllSourceConfigs() []SourceConfig {
	return []SourceConfig{
		// Compute
		{
			Package:   "compute-kamaji",
			GitHubDir: &GitHubCRDDir{Owner: "clastix", Repo: "kamaji", Path: "charts/kamaji/crds", Ref: "master", FilePattern: yamlPattern},
		},

		// Development
		{
			Package: "development-atlas-operator",
			// Use GitHub URL instead of OCI registry
			GitHubDir: &GitHubCRDDir{Owner: "ariga", Repo: "atlas-operator", Path: "charts/atlas-operator/templates/crds", Ref: "master", FilePattern: yamlPattern},
		},
		{
			Package: "development-tekton-dashboard",
			// Dashboard CRDs are in config/ directory, filter for CRDs only
			GitHubDir: &GitHubCRDDir{Owner: "tektoncd", Repo: "dashboard", Path: "config", Ref: mainRef, FilePattern: yamlPattern, FilterCRDsOnly: true},
		},
		{
			Package: "development-tekton-pipeline",
			// Pipeline CRDs are in config/300-crds/
			GitHubDir: &GitHubCRDDir{Owner: "tektoncd", Repo: "pipeline", Path: "config/300-crds", Ref: mainRef, FilePattern: yamlPattern},
		},
		{
			Package: "development-tekton-triggers",
			// Triggers CRDs are in config/ directory, filter for CRDs only
			GitHubDir: &GitHubCRDDir{Owner: "tektoncd", Repo: "triggers", Path: "config", Ref: mainRef, FilePattern: yamlPattern, FilterCRDsOnly: true},
		},
		{
			Package: "development-theia",
			GitHubDir: &GitHubCRDDir{
				Owner:              "eclipse-theia",
				Repo:               "theia-cloud-helm",
				Path:               "charts/theia-cloud-crds/templates",
				Ref:                "main",
				FilePattern:        "*-resource.yaml",
				FilterCRDsOnly:     true,
				StripHelmTemplates: true,
			},
		},

		// GitOps
		{
			Package:   "gitops-argo-cd",
			GitHubDir: &GitHubCRDDir{Owner: "argoproj", Repo: "argo-cd", Path: "manifests/crds", Ref: "master", FilePattern: "*-crd.yaml"},
		},
		{
			Package: "gitops-argo-events",
			CRDURLs: map[string]string{
				"argo-events-crds.yaml": "https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml",
			},
		},
		{
			Package:   "gitops-argo-rollouts",
			GitHubDir: &GitHubCRDDir{Owner: "argoproj", Repo: "argo-rollouts", Path: "manifests/crds", Ref: "master", FilePattern: "*-crd.yaml"},
		},
		{
			Package:   "gitops-argo-workflows",
			GitHubDir: &GitHubCRDDir{Owner: "argoproj", Repo: "argo-workflows", Path: "manifests/base/crds/full", Ref: "main", FilePattern: yamlPattern},
		},

		// MLOps
		{
			Package: "mlops-volcano",
			CRDURLs: map[string]string{
				"volcano-crds.yaml": "https://raw.githubusercontent.com/volcano-sh/volcano/master/installer/volcano-development.yaml",
			},
		},

		// Networking
		{
			Package:   "networking-external-dns",
			HelmRepo:  &HelmRepo{Name: "external-dns", URL: "https://kubernetes-sigs.github.io/external-dns/"},
			ChartName: "external-dns",
		},
		{
			Package:   "networking-gateway-api",
			GitHubDir: &GitHubCRDDir{Owner: "kubernetes-sigs", Repo: "gateway-api", Path: "config/crd/experimental", Ref: mainRef, FilePattern: yamlPattern},
		},

		// Security
		{
			Package:   "security-cert-manager",
			GitHubDir: &GitHubCRDDir{Owner: "cert-manager", Repo: "cert-manager", Path: "deploy/crds", Ref: "master", FilePattern: yamlPattern},
		},
		{
			Package:   "security-falco",
			GitHubDir: &GitHubCRDDir{Owner: "falcosecurity", Repo: "falco-operator", Path: "config/crd/bases", Ref: mainRef, FilePattern: yamlPattern},
		},
		{
			Package: "security-kyverno",
			// Use GitHub URL for Kyverno CRDs
			GitHubDir: &GitHubCRDDir{Owner: "kyverno", Repo: "kyverno", Path: "charts/kyverno/charts/crds", Ref: mainRef, FilePattern: yamlPattern},
		},

		// Storage
		{
			Package:   "storage-cnpg",
			GitHubDir: &GitHubCRDDir{Owner: "cloudnative-pg", Repo: "cloudnative-pg", Path: "config/crd/bases", Ref: "main", FilePattern: yamlPattern},
		},
		{
			Package:   "storage-velero",
			HelmRepo:  &HelmRepo{Name: "vmware-tanzu", URL: "https://vmware-tanzu.github.io/helm-charts"},
			ChartName: "velero",
		},
	}
}

// GetSourceByName finds a source by its short name (e.g., "keda", "cert-manager").
// Returns nil if no matching source is found.
func GetSourceByName(packagesRoot, name string) *Source {
	nameLower := strings.ToLower(name)

	sources := GetAllSources(packagesRoot)
	for i := range sources {
		if strings.EqualFold(sources[i].Name, nameLower) {
			return &sources[i]
		}
	}

	return nil
}

// GetSourceByPackage finds a source by its full package name (e.g., "compute-keda").
// Returns nil if no matching source is found.
func GetSourceByPackage(packagesRoot, pkg string) *Source {
	pkgName := strings.ToLower(pkg)

	sourceConfigs := getAllSourceConfigs()
	for i := range sourceConfigs {
		if strings.EqualFold(sourceConfigs[i].Package, pkgName) {
			src := sourceConfigs[i].toSource(packagesRoot)

			return &src
		}
	}

	return nil
}
