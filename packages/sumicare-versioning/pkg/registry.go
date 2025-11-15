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
	"errors"
	"fmt"
	"strings"
)

var (
	// ErrDockerHubNotImplemented is returned when trying to use the generic DockerHub fetcher.
	ErrDockerHubNotImplemented = errors.New("generic DockerHub fetcher not implemented, use Custom")
	// ErrCustomFetcherNil is returned when a Custom fetcher is specified but the function is nil.
	ErrCustomFetcherNil = errors.New("custom fetcher function is nil")
	// ErrUnknownFetcherType is returned when an unknown fetcher type is encountered.
	ErrUnknownFetcherType = errors.New("unknown fetcher type")
)

// FetcherType defines the strategy for fetching versions.
type (
	FetcherType string

	// ProjectConfig defines how to fetch versions for a specific project.
	ProjectConfig struct {
		Transform func(string) string
		Custom    func(limit int) ([]string, error)
		URL       string
		Fetcher   FetcherType
		Prefix    string
		Fixed     string
	}
)

const (
	// FetcherGitHubReleases fetches versions from GitHub releases.
	FetcherGitHubReleases FetcherType = "GitHubReleases"
	// FetcherGitHubTags fetches versions from GitHub tags.
	FetcherGitHubTags FetcherType = "GitHubTags"
	// FetcherDockerHub fetches versions from Docker Hub tags.
	FetcherDockerHub FetcherType = "DockerHub"
	// FetcherFixed returns a fixed version string.
	FetcherFixed FetcherType = "Fixed"
	// FetcherCustom uses a custom function to fetch versions.
	FetcherCustom FetcherType = "Custom"
)

// UnderscoreToDot converts underscore-separated versions to dot-separated (e.g., "17_2" -> "17.2").
func UnderscoreToDot(s string) string {
	return strings.ReplaceAll(s, "_", ".")
}

// GetVersion fetches the latest versions based on the project configuration.
func GetVersion(config *ProjectConfig, limit int) ([]string, error) {
	switch config.Fetcher {
	case FetcherGitHubReleases:
		prefix := "v"
		if config.Prefix != "" {
			prefix = config.Prefix
		}

		versions, err := FetchGitHubReleasesWithPrefix(config.URL, prefix, limit)
		if err != nil {
			return nil, fmt.Errorf("fetch github releases: %w", err)
		}

		return versions, nil

	case FetcherGitHubTags:
		prefix := "v"
		if config.Prefix != "" {
			prefix = config.Prefix
		}

		if config.Transform != nil {
			versions, err := FetchGitHubTagsWithTransform(config.URL, prefix, limit, config.Transform)
			if err != nil {
				return nil, fmt.Errorf("fetch github tags with transform: %w", err)
			}

			return versions, nil
		}

		versions, err := FetchGitHubTagsWithPrefix(config.URL, prefix, limit)
		if err != nil {
			return nil, fmt.Errorf("fetch github tags: %w", err)
		}

		return versions, nil

	case FetcherDockerHub:
		// Currently only implemented for Debian which has specific logic
		// If generic DockerHub support is needed, we'd implement it here.
		// For now, we use the Custom fetcher for Debian.
		return nil, ErrDockerHubNotImplemented

	case FetcherFixed:
		return []string{config.Fixed}, nil

	case FetcherCustom:
		if config.Custom == nil {
			return nil, ErrCustomFetcherNil
		}

		versions, err := config.Custom(limit)
		if err != nil {
			return nil, fmt.Errorf("custom fetcher: %w", err)
		}

		return versions, nil

	default:
		return nil, fmt.Errorf("%w: %s", ErrUnknownFetcherType, config.Fetcher)
	}
}
