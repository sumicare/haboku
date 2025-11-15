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

package dockerhub

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"
)

const (
	// dockerHubAPIURL is the base URL for Docker Hub API v2.
	dockerHubAPIURL = "https://hub.docker.com/v2"
	// defaultPageSize is the default number of results per page.
	defaultPageSize = 100
	// defaultHTTPTimeout is the default timeout for HTTP requests.
	defaultHTTPTimeout = 30 * time.Second
)

//nolint:gochecknoglobals // error sentinel and test override
var (
	// ErrUnexpectedStatusCode is returned when Docker Hub API returns a non-200 status code.
	ErrUnexpectedStatusCode = errors.New("unexpected status code from docker hub API")
	// baseURL allows overriding the Docker Hub API URL for testing.
	baseURL = dockerHubAPIURL
)

type (
	// TagsResponse represents the response from Docker Hub tags API.
	TagsResponse struct {
		Next     string `json:"next"`
		Previous string `json:"previous"`
		Results  []Tag  `json:"results"`
		Count    int    `json:"count"`
	}

	// Tag represents a Docker image tag.
	Tag struct {
		LastUpdated time.Time `json:"last_updated"`
		Name        string    `json:"name"`
		FullSize    int64     `json:"full_size"`
	}
)

// FetchImageTags fetches image tags from Docker Hub for a given repository.
func FetchImageTags(repository string, filter func(string) bool, limit int) ([]string, error) {
	repo := repository
	if !strings.Contains(repository, "/") {
		repo = "library/" + repository
	}

	client := &http.Client{Timeout: defaultHTTPTimeout}
	url := fmt.Sprintf("%s/repositories/%s/tags?page_size=%d", baseURL, repo, defaultPageSize)

	var tags []string

	for url != "" && len(tags) < limit {
		req, _ := http.NewRequestWithContext(context.Background(), http.MethodGet, url, http.NoBody) //nolint:errcheck // URL is validated

		resp, err := client.Do(req)
		if err != nil {
			return nil, fmt.Errorf("http request: %w", err)
		}

		if resp.StatusCode != http.StatusOK {
			resp.Body.Close()
			return nil, fmt.Errorf("%w: %d", ErrUnexpectedStatusCode, resp.StatusCode)
		}

		var tagsResp TagsResponse

		err = json.NewDecoder(resp.Body).Decode(&tagsResp)
		resp.Body.Close()

		if err != nil {
			return nil, fmt.Errorf("failed to parse response: %w", err)
		}

		for i := range tagsResp.Results {
			if filter != nil && !filter(tagsResp.Results[i].Name) {
				continue
			}

			tags = append(tags, tagsResp.Results[i].Name)
			if len(tags) >= limit {
				break
			}
		}

		url = tagsResp.Next
	}

	return tags, nil
}
