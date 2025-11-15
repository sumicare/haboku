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
	"encoding/json"
	"fmt"
	"sort"
	"strings"
)

type (
	// GitObject represents a Git object reference.
	GitObject struct {
		Sha  string `json:"sha"`
		Type string `json:"type"`
		URL  string `json:"url"`
	}

	// GitTagsResponse represents a GitHub tag reference.
	GitTagsResponse struct {
		Ref    string    `json:"ref"`
		NodeID string    `json:"node_id"`
		URL    string    `json:"url"`
		Object GitObject `json:"object"`
	}
)

// GetTags fetches tags from a repository URL.
func (client *Client) GetTags(url, authToken string, limit *int) ([]string, error) {
	owner, repo := GetOwnerRepoFrom(url)
	if owner == "" || repo == "" {
		return nil, fmt.Errorf("%w: %s", ErrInvalidURL, url)
	}

	token := authToken
	if token == "" {
		token = getGithubToken()
	}

	items, err := client.fetchAll(owner, repo, "git/refs/tags", token, limit)
	if err != nil {
		return nil, fmt.Errorf("fetch tags: %w", err)
	}

	tags := make([]string, 0, len(items))
	for _, item := range items {
		var t GitTagsResponse
		if json.Unmarshal(item, &t) == nil {
			tags = append(tags, strings.TrimPrefix(t.Ref, "refs/tags/"))
		}
	}

	sort.Slice(tags, func(i, j int) bool { return tags[i] > tags[j] })

	return tags, nil
}
