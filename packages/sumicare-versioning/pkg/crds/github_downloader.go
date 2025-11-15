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
	"encoding/json"
	"fmt"
	"io"
	"maps"
	"net/http"
	"os"
	"path"
	"strings"
)

// githubDownloader fetches CRD files from GitHub repository directories.
// It uses the GitHub REST API to list directory contents and raw.githubusercontent.com
// to download file contents.
//
// Authentication is supported via the GITHUB_TOKEN environment variable to avoid
// rate limiting on the GitHub API (60 requests/hour unauthenticated vs 5000/hour authenticated).
type githubDownloader struct {
	client     *http.Client
	token      string
	apiBaseURL string // Configurable for testing with mock servers.
	rawBaseURL string // Configurable for testing with mock servers.
}

// newGitHubDownloader creates a new GitHub downloader instance.
// It automatically reads the GITHUB_TOKEN environment variable for authentication.
// If no token is set, requests are made unauthenticated (subject to stricter rate limits).
func newGitHubDownloader() *githubDownloader {
	token := os.Getenv(githubTokenEnvVar)

	return &githubDownloader{
		client:     &http.Client{Timeout: defaultDownloaderTimeout},
		token:      token,
		apiBaseURL: githubAPIBase,
		rawBaseURL: githubRawBase,
	}
}

// download fetches CRD files from a GitHub repository directory.
// It lists the directory contents via the GitHub API, filters files by pattern,
// downloads matching files, and extracts CRD documents from multi-document YAML.
//
// The method applies optional transformations based on GitHubCRDDir configuration:
//   - FilterCRDsOnly: Only includes files containing CustomResourceDefinition resources
//   - StripHelmTemplates: Removes Helm template syntax ({{ }}) from content
//
// Returns a map of filename to YAML content for all extracted CRDs.
func (downloader *githubDownloader) download(ctx context.Context, dir *GitHubCRDDir) (map[string]string, error) {
	if dir == nil {
		return nil, ErrGitHubDirNil
	}

	ref := dir.Ref
	if ref == "" {
		ref = "main"
	}

	pattern := dir.FilePattern
	if pattern == "" {
		pattern = "*.yaml"
	}

	files, err := downloader.listDirectory(ctx, dir.Owner, dir.Repo, dir.Path, ref)
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrFailedToListDir, err)
	}

	var matchedFiles []string
	for _, filePath := range files {
		matched, err := path.Match(pattern, path.Base(filePath))
		if err != nil {
			return nil, fmt.Errorf("%w %q: %w", ErrInvalidPattern, pattern, err)
		}

		if matched {
			matchedFiles = append(matchedFiles, filePath)
		}
	}

	if len(matchedFiles) == 0 {
		return nil, fmt.Errorf("%w: %q in %s/%s/%s", ErrNoFilesMatch, pattern, dir.Owner, dir.Repo, dir.Path)
	}

	crds := make(map[string]string)
	for _, filePath := range matchedFiles {
		content, err := downloader.downloadFile(ctx, dir.Owner, dir.Repo, ref, filePath)
		if err != nil {
			return nil, fmt.Errorf("download %s: %w", filePath, err)
		}

		// If FilterCRDsOnly is enabled, only include files that contain CRDs
		if dir.FilterCRDsOnly {
			if !strings.Contains(content, "kind: CustomResourceDefinition") {
				continue
			}
		}

		// Strip Helm templates if requested
		if dir.StripHelmTemplates {
			content = stripHelmTemplates(content)
		}

		extracted, err := splitMultiDocYAML(content)
		if err != nil || len(extracted) == 0 {
			if strings.Contains(content, "kind: CustomResourceDefinition") {
				name := extractCRDName(content)

				crds[name+".yaml"] = content
			}

			continue
		}

		// Apply template stripping to extracted CRDs as well
		if dir.StripHelmTemplates {
			for k, v := range extracted {
				extracted[k] = stripHelmTemplates(v)
			}
		}

		maps.Copy(crds, extracted)
	}

	return crds, nil
}

// listDirectory retrieves the list of files in a GitHub repository directory.
// It uses the GitHub Contents API (GET /repos/{owner}/{repo}/contents/{path}).
// Only files are returned; subdirectories are excluded.
func (downloader *githubDownloader) listDirectory(ctx context.Context, owner, repo, dirPath, ref string) ([]string, error) {
	url := fmt.Sprintf("%s/repos/%s/%s/contents/%s?ref=%s", downloader.apiBaseURL, owner, repo, dirPath, ref)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, http.NoBody)
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrFailedToCreateReq, err)
	}

	req.Header.Set("Accept", "application/vnd.github.v3+json")

	// Add authentication token if available
	if downloader.token != "" {
		req.Header.Set("Authorization", "token "+downloader.token)
	}

	resp, err := downloader.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrFailedToListDir, err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, err := io.ReadAll(resp.Body)
		if err != nil {
			return nil, fmt.Errorf("%w %d: %w", ErrHTTPResponse, resp.StatusCode, err)
		}

		if body != nil {
			return nil, fmt.Errorf("%w %d: %s", ErrHTTPResponse, resp.StatusCode, string(body))
		}

		return nil, fmt.Errorf("%w %d", ErrHTTPResponse, resp.StatusCode)
	}

	var contents []struct {
		Name string `json:"name"`
		Path string `json:"path"`
		Type string `json:"type"`
	}

	err = json.NewDecoder(resp.Body).Decode(&contents)
	if err != nil {
		return nil, fmt.Errorf("%w: %w", ErrFailedToDecodeResp, err)
	}

	var files []string
	for i := range contents {
		if contents[i].Type == "file" {
			files = append(files, contents[i].Path)
		}
	}

	return files, nil
}

// downloadFile fetches the raw content of a file from GitHub.
// It uses raw.githubusercontent.com for direct file access without API rate limits.
func (downloader *githubDownloader) downloadFile(ctx context.Context, owner, repo, ref, filePath string) (string, error) {
	url := fmt.Sprintf("%s/%s/%s/%s/%s", downloader.rawBaseURL, owner, repo, ref, filePath)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, http.NoBody)
	if err != nil {
		return "", fmt.Errorf("%w: %w", ErrFailedToCreateReq, err)
	}

	// Add authentication token if available
	if downloader.token != "" {
		req.Header.Set("Authorization", "token "+downloader.token)
	}

	resp, err := downloader.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("%w: %w", ErrFailedToListDir, err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("%w %d", ErrHTTPResponse, resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("%w: %w", ErrFailedToReadResp, err)
	}

	return string(body), nil
}
