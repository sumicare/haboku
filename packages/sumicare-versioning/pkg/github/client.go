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

package github

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"regexp"
	"strings"
	"time"
)

// API configuration constants.
const (
	// APIVersion is the GitHub REST API version header value.
	// See: https://docs.github.com/en/rest/overview/api-versions
	APIVersion = "2022-11-28"

	// httpTimeout is the default timeout for HTTP requests.
	httpTimeout = 30 * time.Second
)

// Sentinel errors for GitHub API operations.
var (
	// ErrInvalidURL indicates the provided URL is not a valid GitHub repository URL.
	ErrInvalidURL = errors.New("invalid GitHub repository URL")

	// ErrHTTPRequest indicates an HTTP request to the GitHub API failed.
	ErrHTTPRequest = errors.New("HTTP request failed")
)

// Client provides methods to interact with the GitHub REST API.
// It handles authentication, pagination, and rate limiting.
type Client struct {
	httpClient *http.Client
	apiURL     string // Configurable for testing with mock servers.
}

// NewClient creates a new GitHub API client with default settings.
// The client uses a 30-second timeout for all requests.
func NewClient() *Client {
	return &Client{
		httpClient: &http.Client{
			Timeout: httpTimeout,
		},
		apiURL: "https://api.github.com",
	}
}

// NewClientWithURL creates a new GitHub client with a custom API URL (for testing).
func NewClientWithURL(apiURL string) *Client {
	return &Client{
		httpClient: &http.Client{
			Timeout: httpTimeout,
		},
		apiURL: apiURL,
	}
}

// GetOwnerRepoFrom extracts owner and repository name from a given URL.
//
// Accepts URLs in the following formats:
// - `git@github.com:owner/repo.git`
// - `https://github.com/owner/repo.git`
// - `https://github.com/owner/repo`
//
// Returns owner and repository names. If the URL is invalid, returns empty strings.
func GetOwnerRepoFrom(url string) (string, string) {
	const expectedParts = 2

	cleaned := strings.Replace(url, "git@github.com:", "", 1)

	cleaned = strings.Replace(cleaned, "https://github.com/", "", 1)

	parts := strings.Split(cleaned, "/")
	if len(parts) != expectedParts {
		return "", ""
	}

	owner := parts[0]
	repo := strings.TrimSuffix(parts[1], ".git")

	return owner, repo
}

// parseNextLink extracts the "next" page URL from a GitHub API Link header.
// Returns an empty string if no next link is found.
func parseNextLink(linkHeader string) string {
	if linkHeader == "" {
		return ""
	}

	re := regexp.MustCompile(`<([^>]+)>;\s*rel="next"`)

	matches := re.FindStringSubmatch(linkHeader)
	if len(matches) > 1 {
		return matches[1]
	}

	return ""
}

// fetchPageByURL fetches a single page from the GitHub API and decodes the JSON response.
// Returns the URL of the next page (from Link header) or empty string if no more pages.
func (client *Client) fetchPageByURL(url, authToken string, result any) (string, error) {
	req, _ := http.NewRequestWithContext(context.Background(), http.MethodGet, url, http.NoBody) //nolint:errcheck // URL is validated
	req.Header.Set("X-Github-Api-Version", APIVersion)
	req.Header.Set("Accept", "application/vnd.github.v3+json")

	if authToken != "" {
		req.Header.Set("Authorization", "Bearer "+authToken)
	}

	resp, err := client.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("http request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body) //nolint:errcheck // best effort for error message
		return "", fmt.Errorf("%w: %d %s", ErrHTTPRequest, resp.StatusCode, string(body))
	}

	if err := json.NewDecoder(resp.Body).Decode(result); err != nil {
		return "", fmt.Errorf("decode response: %w", err)
	}

	return parseNextLink(resp.Header.Get("Link")), nil
}

// fetchAll fetches all items from a paginated GitHub API endpoint up to the specified limit.
// It handles pagination automatically by following Link headers.
func (client *Client) fetchAll(owner, repo, endpoint, authToken string, limit *int) ([]json.RawMessage, error) {
	if limit != nil && *limit <= 0 {
		return nil, nil
	}

	url := fmt.Sprintf("%s/repos/%s/%s/%s?per_page=100&sort=created&direction=desc", client.apiURL, owner, repo, endpoint)

	var acc []json.RawMessage

	for url != "" {
		var items []json.RawMessage

		nextURL, err := client.fetchPageByURL(url, authToken, &items)
		if err != nil {
			return nil, fmt.Errorf("fetch page: %w", err)
		}

		if len(items) == 0 {
			break
		}

		if limit != nil && len(acc)+len(items) > *limit {
			items = items[:*limit-len(acc)]
		}

		acc = append(acc, items...)

		if limit != nil && len(acc) >= *limit {
			break
		}

		url = nextURL
	}

	return acc, nil
}

// getGithubToken retrieves the GitHub token from environment variable.
func getGithubToken() string { return os.Getenv("GITHUB_TOKEN") }
