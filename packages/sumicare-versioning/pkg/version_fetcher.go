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

package pkg

import (
	"fmt"
	"os"
	"sort"
	"strings"

	"github.com/Masterminds/semver/v3"

	"sumi.care/util/sumicare-versioning/pkg/github"
)

// Version fetching configuration constants.
const (
	// DefaultVersionLimit is the default number of versions to return when not specified.
	DefaultVersionLimit = 5

	// FetchMultiplier is applied to the requested limit when fetching from GitHub.
	// This accounts for filtering out non-version tags (e.g., helm-chart/*, edge-*).
	FetchMultiplier = 100

	// FetchLimit is the maximum number of tags/releases to fetch from GitHub.
	// Set to 5000 to handle repositories with many historical tags (e.g., PostgreSQL).
	FetchLimit = 5000
)

// githubClientFactory creates GitHub clients. Override in tests to inject mock servers.
//
//nolint:gochecknoglobals // Required for test injection.
var githubClientFactory = github.NewClient

// fetchVersionsWith is a shared helper for fetching and filtering versions from GitHub.
// It fetches version strings using the provided fetch function, filters to stable semver
// versions after stripping the prefix, sorts in descending order, and returns the top N.
func fetchVersionsWith(
	repo, prefix string,
	limit int,
	fetch func(client *github.Client, repo, authToken string, limit *int) ([]string, error),
) ([]string, error) {
	effectiveLimit := limit
	if effectiveLimit <= 0 {
		effectiveLimit = DefaultVersionLimit
	}

	client := githubClientFactory()
	fetchLimit := min(effectiveLimit*FetchMultiplier, FetchLimit)

	authToken := os.Getenv("GITHUB_TOKEN")

	items, err := fetch(client, repo, authToken, &fetchLimit)
	if err != nil {
		return nil, fmt.Errorf("error fetching GitHub items: %w", err)
	}

	var validVersions []*semver.Version
	for _, raw := range items {
		versionStr := strings.TrimPrefix(raw, prefix)

		parsedVersion, err := semver.NewVersion(versionStr)
		if err != nil {
			continue
		}

		if parsedVersion.Prerelease() == "" {
			validVersions = append(validVersions, parsedVersion)
		}
	}

	sort.Slice(validVersions, func(i, j int) bool {
		return validVersions[i].GreaterThan(validVersions[j])
	})

	result := make([]string, 0, effectiveLimit)
	for i := 0; i < len(validVersions) && i < effectiveLimit; i++ {
		result = append(result, validVersions[i].String())
	}

	return result, nil
}

// FetchGitHubReleasesWithPrefix fetches and filters versions from GitHub releases with a custom prefix.
// Similar to FetchGitHubVersionsWithPrefix but uses releases instead of tags.
//
// Parameters:
//   - repo: GitHub repository URL
//   - prefix: prefix to remove from release tags (e.g., "v")
//   - limit: number of versions to return (default: 5)
//
// Returns filtered, sorted versions without prefix, or error.
func FetchGitHubReleasesWithPrefix(repo, prefix string, limit int) ([]string, error) {
	versions, err := fetchVersionsWith(repo, prefix, limit, (*github.Client).GetReleases)
	if err != nil {
		return nil, fmt.Errorf("fetch releases with prefix: %w", err)
	}

	return versions, nil
}

// FetchGitHubTagsWithPrefix fetches and filters versions from GitHub tags with a custom prefix.
func FetchGitHubTagsWithPrefix(repo, prefix string, limit int) ([]string, error) {
	versions, err := fetchVersionsWith(repo, prefix, limit, (*github.Client).GetTags)
	if err != nil {
		return nil, fmt.Errorf("fetch tags with prefix: %w", err)
	}

	return versions, nil
}

// FetchGitHubTagsWithTransform fetches tags and applies a transform function before semver parsing.
// Useful for repositories with non-standard version formats (e.g., PostgreSQL's REL_X_Y).
func FetchGitHubTagsWithTransform(repo, prefix string, limit int, transform func(string) string) ([]string, error) {
	effectiveLimit := limit
	if effectiveLimit <= 0 {
		effectiveLimit = DefaultVersionLimit
	}

	client := githubClientFactory()
	fetchLimit := min(effectiveLimit*FetchMultiplier, FetchLimit)
	authToken := os.Getenv("GITHUB_TOKEN")

	items, err := client.GetTags(repo, authToken, &fetchLimit)
	if err != nil {
		return nil, fmt.Errorf("fetch tags: %w", err)
	}

	var validVersions []*semver.Version
	for _, raw := range items {
		versionStr := strings.TrimPrefix(raw, prefix)
		if transform != nil {
			versionStr = transform(versionStr)
		}

		parsedVersion, err := semver.NewVersion(versionStr)
		if err != nil {
			continue
		}

		if parsedVersion.Prerelease() == "" {
			validVersions = append(validVersions, parsedVersion)
		}
	}

	sort.Slice(validVersions, func(i, j int) bool {
		return validVersions[i].GreaterThan(validVersions[j])
	})

	result := make([]string, 0, effectiveLimit)
	for i := 0; i < len(validVersions) && i < effectiveLimit; i++ {
		result = append(result, validVersions[i].String())
	}

	return result, nil
}
