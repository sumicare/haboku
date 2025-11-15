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
	"context"
	"fmt"
	"os"
	"path/filepath"
	"sync"

	"golang.org/x/sync/errgroup"
)

// Downloader orchestrates CRD downloading from multiple source types.
// It coordinates three specialized downloaders for different source types:
// Helm repositories, GitHub directories, and direct URLs.
//
// Downloader handles concurrent downloads with configurable limits and
// provides automatic cleanup of existing files before downloading.
type Downloader struct {
	helm   *helmDownloader
	github *githubDownloader
	url    *urlDownloader
}

// NewDownloader creates a new [Downloader] instance with all specialized
// downloaders initialized. The GitHub downloader automatically reads
// the GITHUB_TOKEN environment variable for authentication.
func NewDownloader() *Downloader {
	return &Downloader{
		helm:   newHelmDownloader(),
		github: newGitHubDownloader(),
		url:    newURLDownloader(),
	}
}

// DownloadAll downloads CRDs for all configured sources to their target directories.
// It first cleans up existing YAML files and crds.tf from target directories,
// then downloads fresh copies from the configured sources.
//
// The packagesRoot parameter specifies the base directory containing package
// subdirectories (typically "packages").
//
// Returns an error if cleanup fails or if any downloads fail.
func (downloader *Downloader) DownloadAll(ctx context.Context, packagesRoot string) error {
	sources := GetAllSources(packagesRoot)

	err := downloader.cleanupExistingFiles(sources)
	if err != nil {
		return fmt.Errorf("failed to clean up existing files: %w", err)
	}

	//nolint:wrapcheck // Error is already descriptive from DownloadSources.
	return downloader.DownloadSources(ctx, sources)
}

// cleanupExistingFiles removes all YAML files and crds.tf from target directories.
// This ensures a clean state before downloading new CRD files, preventing stale
// files from previous downloads from remaining.
func (*Downloader) cleanupExistingFiles(sources []Source) error {
	for i := range sources {
		// Skip if directory doesn't exist yet
		_, err := os.Stat(sources[i].TargetDir)
		if os.IsNotExist(err) {
			continue
		}

		// Find all YAML files in the directory
		files, err := filepath.Glob(filepath.Join(sources[i].TargetDir, "*.yaml"))
		if err != nil {
			return fmt.Errorf("failed to list YAML files in %s: %w", sources[i].TargetDir, err)
		}

		// Also find the crds.tf file
		tfFile := filepath.Join(sources[i].TargetDir, "crds.tf")

		_, err = os.Stat(tfFile)
		if err == nil {
			files = append(files, tfFile)
		}

		// Remove all found files
		for _, file := range files {
			err := os.Remove(file)
			if err != nil {
				return fmt.Errorf("failed to remove file %s: %w", file, err)
			}
		}
	}

	return nil
}

// DownloadSources downloads CRDs for the specified sources concurrently.
// It uses an errgroup with a concurrency limit to prevent overwhelming
// remote servers while maximizing throughput.
//
// Errors from individual sources are collected and returned as a combined error.
// The download continues even if some sources fail, ensuring maximum coverage.
func (downloader *Downloader) DownloadSources(ctx context.Context, sources []Source) error {
	group, groupCtx := errgroup.WithContext(ctx)
	group.SetLimit(maxConcurrentDownloads)

	var (
		mu   sync.Mutex
		errs []error
	)

	for i := range sources {
		// capture loop variable
		group.Go(func() error {
			err := downloader.DownloadSource(groupCtx, &sources[i])
			if err != nil {
				namedErr := fmt.Errorf("%s: %w", sources[i].Name, err)

				mu.Lock()

				errs = append(errs, namedErr)

				mu.Unlock()
			}

			return nil
		})
	}

	// Wait for all downloads to complete
	err := group.Wait()
	if err != nil {
		return fmt.Errorf("%w: %w", ErrDownloadFailed, err)
	}

	if len(errs) > 0 {
		return fmt.Errorf("%w: %v", ErrDownloadFailed, errs)
	}

	return nil
}

// DownloadSource downloads CRDs for a single source and writes them to the target directory.
// It handles the following source types:
//   - HelmRepo: Downloads and extracts CRDs from a Helm chart archive
//   - GitHubDir: Downloads CRD files from a GitHub repository directory
//   - CRDURLs: Downloads CRD files from direct URLs
//
// After downloading, it generates a crds.tf file containing Terraform kubernetes_manifest
// resources for each CRD.
//
// Special handling is provided for:
//   - OCI registries (creates placeholder files)
//   - Sources marked with SkipDownload (skipped entirely)
//   - Sources with AllowEmptyCRDs (creates empty placeholder on failure)
func (downloader *Downloader) DownloadSource(ctx context.Context, src *Source) error {
	var crds map[string]string

	// Skip known problematic packages
	if src.SkipDownload {
		fmt.Printf("Skipping CRD download for %s (marked as skip)\n", src.Name)
		return nil
	}

	// Check if OCI registry is used but not supported
	if src.HelmRepo != nil && src.HelmRepo.IsOCI {
		// Create empty directory and empty crds.tf for OCI repositories
		err := os.MkdirAll(src.TargetDir, DirectoryPermissions)
		if err != nil {
			return fmt.Errorf("create target dir: %w", err)
		}

		// Generate empty terraform file
		tfPath := filepath.Join(src.TargetDir, "crds.tf")
		emptyTF := "# OCI registries not supported for CRD extraction\n# CRDs will be installed by the Helm chart\n"

		err = os.WriteFile(tfPath, []byte(emptyTF), FilePermission)
		if err != nil {
			return fmt.Errorf("write crds.tf: %w", err)
		}

		fmt.Printf("Created placeholder for OCI registry chart %s/%s\n", src.Name, src.ChartName)

		return nil
	}

	err := os.MkdirAll(src.TargetDir, DirectoryPermissions)
	if err != nil {
		return fmt.Errorf("create target dir: %w", err)
	}

	switch {
	case src.HelmRepo != nil && src.ChartName != "":
		crds, err = downloader.helm.download(ctx, src.HelmRepo, src.ChartName, src.ChartVersion)
	case src.GitHubDir != nil:
		crds, err = downloader.github.download(ctx, src.GitHubDir)
	case len(src.CRDURLs) > 0:
		crds, err = downloader.url.download(ctx, src.CRDURLs)
	default:
		return ErrNoSourceConfigured
	}

	if err != nil {
		// For specific packages, create an empty crds.tf file instead of failing
		if src.AllowEmptyCRDs {
			fmt.Printf("No CRDs found for %s, creating empty crds.tf\n", src.Name)

			emptyTF := fmt.Sprintf("# No CRDs found for %s\n# This file is auto-generated\n", src.Name)
			tfPath := filepath.Join(src.TargetDir, "crds.tf")

			err = os.WriteFile(tfPath, []byte(emptyTF), FilePermission)
			if err != nil {
				return fmt.Errorf("write empty crds.tf: %w", err)
			}

			return nil
		}

		return fmt.Errorf("download CRDs: %w", err)
	}

	// Write CRD files
	for name, content := range crds {
		if content == "" {
			continue
		}

		filePath := filepath.Join(src.TargetDir, name)

		err = os.WriteFile(filePath, []byte(content), FilePermission)
		if err != nil {
			return fmt.Errorf("write %s: %w", name, err)
		}
	}

	// Generate crds.tf
	tfContent := generateTerraform(crds)

	tfPath := filepath.Join(src.TargetDir, "crds.tf")

	err = os.WriteFile(tfPath, []byte(tfContent), FilePermission)
	if err != nil {
		return fmt.Errorf("write crds.tf: %w", err)
	}

	return nil
}
