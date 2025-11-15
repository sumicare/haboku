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
	"archive/tar"
	"compress/gzip"
	"context"
	"fmt"
	"io"
	"maps"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"go.yaml.in/yaml/v3"
)

// helmDownloader fetches and extracts CRDs from Helm chart repositories.
//
// It downloads chart archives directly via HTTP without requiring the helm CLI,
// then extracts CRD files from the archive's crds/ and templates/ directories.
//
// # Security
//
// The downloader implements several security measures:
//   - Decompression bomb protection via [maxTotalSize] limit on extracted content
//   - Path traversal prevention by validating all paths stay within the temp directory
//   - File size validation by comparing extracted bytes to tar header size
type helmDownloader struct {
	client *http.Client
}

// newHelmDownloader creates a new Helm chart downloader with default HTTP timeout.
func newHelmDownloader() *helmDownloader {
	return &helmDownloader{
		client: &http.Client{Timeout: defaultDownloaderTimeout},
	}
}

// download fetches a Helm chart and extracts its CRDs.
//
// The download process:
//  1. Fetches the repository index.yaml to locate the chart URL
//  2. Downloads the chart archive (.tgz)
//  3. Extracts the archive to a temporary directory
//  4. Scans crds/ and templates/ directories for CRD files
//  5. Returns a map of CRD filenames to their YAML content
//
// Returns [ErrOCIUnsupported] for OCI registry URLs, which require the helm CLI.
func (downloader *helmDownloader) download(ctx context.Context, repo *HelmRepo, chartName, chartVersion string) (map[string]string, error) {
	if repo.IsOCI {
		return nil, ErrOCIUnsupported
	}

	// Fetch repo index
	indexURL := strings.TrimSuffix(repo.URL, "/") + "/index.yaml"

	chartURL, err := downloader.getChartURL(ctx, indexURL, chartName, chartVersion)
	if err != nil {
		return nil, fmt.Errorf("failed to get chart URL: %w", err)
	}

	// Download and extract
	archivePath, err := downloader.downloadArchive(ctx, chartURL)
	if err != nil {
		return nil, fmt.Errorf("failed to download archive: %w", err)
	}
	defer os.Remove(archivePath)

	extractDir, err := downloader.extractArchive(archivePath)
	if err != nil {
		return nil, fmt.Errorf("failed to extract archive: %w", err)
	}
	defer os.RemoveAll(extractDir)

	//nolint:wrapcheck // Error from extractCRDs is already descriptive.
	return downloader.extractCRDs(extractDir)
}

// getChartURL retrieves the download URL for a specific chart version from the repository index.
// If version is empty, returns the URL for the latest version (first entry in index).
func (downloader *helmDownloader) getChartURL(ctx context.Context, indexURL, chartName, version string) (string, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, indexURL, http.NoBody)
	if err != nil {
		return "", fmt.Errorf("failed to create request: %w", err)
	}

	resp, err := downloader.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to fetch index: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("%w %d", ErrHTTPResponse, resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read response body: %w", err)
	}

	var index struct {
		Entries map[string][]struct {
			Version string   `yaml:"version"`
			URLs    []string `yaml:"urls"`
		} `yaml:"entries"`
	}

	err = yaml.Unmarshal(body, &index)
	if err != nil {
		return "", fmt.Errorf("failed to unmarshal index: %w", err)
	}

	entries, ok := index.Entries[chartName]
	if !ok || len(entries) == 0 {
		return "", fmt.Errorf("%w: %q", ErrChartNotFound, chartName)
	}

	var chart *struct {
		Version string   `yaml:"version"`
		URLs    []string `yaml:"urls"`
	}

	if version == "" {
		chart = &entries[0]
	} else {
		for i := range entries {
			if entries[i].Version == version {
				chart = &entries[i]
				break
			}
		}
	}

	if chart == nil || len(chart.URLs) == 0 {
		return "", fmt.Errorf("%w: %q", ErrNoChartURL, chartName)
	}

	chartURL := chart.URLs[0]
	if !strings.HasPrefix(chartURL, "http") {
		baseURL := strings.TrimSuffix(indexURL, "/index.yaml")

		chartURL = baseURL + "/" + chartURL
	}

	return chartURL, nil
}

// downloadArchive downloads a chart archive to a temporary file.
// Returns the path to the temporary file, which the caller must delete.
func (downloader *helmDownloader) downloadArchive(ctx context.Context, url string) (string, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, http.NoBody)
	if err != nil {
		return "", fmt.Errorf("failed to create request: %w", err)
	}

	resp, err := downloader.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to download archive: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("%w %d", ErrHTTPResponse, resp.StatusCode)
	}

	tmpFile, err := os.CreateTemp("", "helm-chart-*.tgz")
	if err != nil {
		return "", fmt.Errorf("failed to create temp file: %w", err)
	}
	defer tmpFile.Close()

	_, err = io.Copy(tmpFile, resp.Body)
	if err != nil {
		os.Remove(tmpFile.Name())
		return "", fmt.Errorf("failed to copy archive: %w", err)
	}

	return tmpFile.Name(), nil
}

// maxTotalSize is the maximum allowed total size for extracted archive contents (100MB).
// This protects against decompression bombs while allowing for large chart archives.
const maxTotalSize = defaultBufferSize * 10

// extractArchive safely extracts a Helm chart archive (tar.gz) to a temporary directory.
//
// Security measures:
//   - Path traversal: All paths are cleaned and validated to stay within the temp directory
//   - File size: Individual files are limited to [defaultBufferSize] bytes
//   - Archive size: Total extracted content is limited to [maxTotalSize] bytes
//   - Size validation: Extracted bytes are compared to tar header to detect truncation
//
// Returns the path to the extracted directory, which the caller must delete.
func (*helmDownloader) extractArchive(archivePath string) (string, error) {
	file, err := os.Open(archivePath)
	if err != nil {
		return "", fmt.Errorf("failed to open archive: %w", err)
	}
	defer file.Close()

	gzr, err := gzip.NewReader(file)
	if err != nil {
		return "", fmt.Errorf("failed to create gzip reader: %w", err)
	}
	defer gzr.Close()

	tmpDir, err := os.MkdirTemp("", "helm-chart-*")
	if err != nil {
		return "", fmt.Errorf("failed to create temp dir: %w", err)
	}

	tr := tar.NewReader(io.LimitReader(gzr, maxTotalSize))

	var totalExtracted int64

	for {
		header, err := tr.Next()
		if err == io.EOF {
			break
		}

		if err != nil {
			os.RemoveAll(tmpDir)
			return "", fmt.Errorf("failed to read archive: %w", err)
		}

		// Clean the path first and check for traversal attempts
		cleanedPath := filepath.Clean(header.Name)
		if strings.HasPrefix(cleanedPath, "..") || strings.HasPrefix(cleanedPath, "/") || strings.Contains(cleanedPath, "../") {
			os.RemoveAll(tmpDir)
			return "", fmt.Errorf("%w: %s", ErrInvalidPath, header.Name)
		}

		target := filepath.Join(tmpDir, cleanedPath)
		if !strings.HasPrefix(filepath.Clean(target), filepath.Clean(tmpDir)+string(os.PathSeparator)) {
			os.RemoveAll(tmpDir)
			return "", fmt.Errorf("%w: %s", ErrInvalidPath, header.Name)
		}

		switch header.Typeflag {
		case tar.TypeDir:
			err := os.MkdirAll(target, DirectoryPermissions)
			if err != nil {
				os.RemoveAll(tmpDir)
				return "", fmt.Errorf("failed to create directory: %w", err)
			}

		case tar.TypeReg:
			if header.Size > defaultBufferSize {
				os.RemoveAll(tmpDir)
				return "", fmt.Errorf("%w: %s", ErrFileTooLarge, header.Name)
			}

			totalExtracted += header.Size
			if totalExtracted > maxTotalSize {
				os.RemoveAll(tmpDir)
				return "", ErrArchiveTooLarge
			}

			err := os.MkdirAll(filepath.Dir(target), DirectoryPermissions)
			if err != nil {
				os.RemoveAll(tmpDir)
				return "", fmt.Errorf("failed to create directory: %w", err)
			}

			outFile, err := os.Create(target)
			if err != nil {
				os.RemoveAll(tmpDir)
				return "", fmt.Errorf("failed to create file: %w", err)
			}

			// Secure copy with size validation
			limitedReader := io.LimitReader(tr, header.Size)

			written, err := io.Copy(outFile, limitedReader)
			if err != nil {
				outFile.Close()
				os.RemoveAll(tmpDir)

				return "", fmt.Errorf("failed to copy file: %w", err)
			}

			if written != header.Size {
				outFile.Close()
				os.RemoveAll(tmpDir)

				return "", fmt.Errorf("%w: expected %d bytes, got %d", ErrFileSizeMismatch, header.Size, written)
			}

			outFile.Close()
		}
	}

	return tmpDir, nil
}

// extractCRDs searches for CRD files in a Helm chart directory structure.
// It scans both the standard crds/ directory (for Helm v3 charts) and the
// templates/ directory (for charts that include CRDs as templates).
//
// Only files containing "kind: CustomResourceDefinition" are included.
// Multi-document YAML files are split into individual CRD documents.
//
// Returns [ErrNoCRDsFound] if no CRDs are found in either directory.
func (downloader *helmDownloader) extractCRDs(chartDir string) (map[string]string, error) {
	// Find chart root
	entries, err := os.ReadDir(chartDir)
	if err != nil {
		return nil, fmt.Errorf("failed to read chart directory: %w", err)
	}

	var chartRoot string
	for _, entry := range entries {
		if entry.IsDir() {
			chartRoot = filepath.Join(chartDir, entry.Name())
			break
		}
	}

	if chartRoot == "" {
		chartRoot = chartDir
	}

	crds := make(map[string]string)

	// Check crds/ directory
	crdsDir := filepath.Join(chartRoot, "crds")

	info, err := os.Stat(crdsDir)
	if err == nil && info.IsDir() {
		err := downloader.readCRDsFromDir(crdsDir, crds)
		if err != nil {
			return nil, fmt.Errorf("failed to read existing chart crds directory: %w", err)
		}
	}

	// Check templates/ directory
	templatesDir := filepath.Join(chartRoot, "templates")

	info, err = os.Stat(templatesDir)
	if err == nil && info.IsDir() {
		err := downloader.readCRDsFromDir(templatesDir, crds)
		if err != nil {
			return nil, fmt.Errorf("failed to read existing chart templates directory: %w", err)
		}
	}

	if len(crds) == 0 {
		return nil, ErrNoCRDsFound
	}

	return crds, nil
}

// readCRDsFromDir recursively scans a directory for YAML files containing CRDs.
// Found CRDs are added to the provided map with their extracted names as keys.
func (*helmDownloader) readCRDsFromDir(dir string, crds map[string]string) error {
	//nolint:wrapcheck // we're fine
	return filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		if !strings.HasSuffix(info.Name(), ".yaml") && !strings.HasSuffix(info.Name(), ".yml") {
			return nil
		}

		content, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("failed to read file: %w", err)
		}

		if !strings.Contains(string(content), "kind: CustomResourceDefinition") {
			return nil
		}

		extracted, err := splitMultiDocYAML(string(content))
		if err != nil {
			return fmt.Errorf("failed to split YAML: %w", err)
		}

		maps.Copy(crds, extracted)

		return nil
	})
}
