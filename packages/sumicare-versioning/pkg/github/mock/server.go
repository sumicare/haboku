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

package mock

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
)

type (
	// Release represents a GitHub release.
	Release struct {
		TagName string `json:"tag_name"`
	}

	// Tag represents a GitHub tag reference.
	Tag struct {
		Ref string `json:"ref"`
	}

	// Server is a mock GitHub API server for testing.
	Server struct {
		*httptest.Server

		releases map[string][]string // owner/repo -> tags
		tags     map[string][]string // owner/repo -> tags
	}
)

// NewServer creates a new mock GitHub API server.
func NewServer() *Server {
	server := &Server{
		releases: make(map[string][]string),
		tags:     make(map[string][]string),
	}

	server.Server = httptest.NewServer(http.HandlerFunc(server.handler))

	return server
}

// AddReleases adds releases for a repository.
func (server *Server) AddReleases(owner, repo string, tags ...string) {
	key := owner + "/" + repo

	server.releases[key] = append(server.releases[key], tags...)
}

// AddTags adds tags for a repository.
func (server *Server) AddTags(owner, repo string, tags ...string) {
	key := owner + "/" + repo

	server.tags[key] = append(server.tags[key], tags...)
}

// URL returns the server URL.
func (server *Server) URL() string { return server.Server.URL }

// numberOfParts is the expected number of parts in a GitHub API path like "/repos/{owner}/{repo}/releases".
const numberOfParts = 3

// handler processes incoming requests.
func (server *Server) handler(writer http.ResponseWriter, req *http.Request) {
	path := req.URL.Path

	// Parse: /repos/{owner}/{repo}/releases or /repos/{owner}/{repo}/git/refs/tags
	parts := strings.Split(strings.TrimPrefix(path, "/repos/"), "/")
	if len(parts) < numberOfParts {
		writer.WriteHeader(http.StatusNotFound)
		return
	}

	key := parts[0] + "/" + parts[1]
	endpoint := strings.Join(parts[2:], "/")

	writer.Header().Set("Content-Type", "application/json")

	switch endpoint {
	case "releases":
		tags := server.getReleases(key)
		if tags == nil {
			writer.WriteHeader(http.StatusNotFound)
			return
		}

		var releases []Release
		for _, t := range tags {
			releases = append(releases, Release{TagName: t})
		}

		if err := json.NewEncoder(writer).Encode(releases); err != nil {
			http.Error(writer, err.Error(), http.StatusInternalServerError)
			return
		}

	case "git/refs/tags":
		tags := server.getTags(key)
		if tags == nil {
			writer.WriteHeader(http.StatusNotFound)
			return
		}

		var refs []Tag
		for _, t := range tags {
			refs = append(refs, Tag{Ref: "refs/tags/" + t})
		}

		if err := json.NewEncoder(writer).Encode(refs); err != nil {
			http.Error(writer, err.Error(), http.StatusInternalServerError)
			return
		}

	default:
		writer.WriteHeader(http.StatusNotFound)
	}
}

// getReleases returns releases for a key, with wildcard fallback.
func (server *Server) getReleases(key string) []string {
	if tags, ok := server.releases[key]; ok {
		return tags
	}

	if tags, ok := server.releases["*/*"]; ok {
		return tags
	}

	return nil
}

// getTags returns tags for a key, with wildcard fallback.
func (server *Server) getTags(key string) []string {
	if tags, ok := server.tags[key]; ok {
		return tags
	}

	if tags, ok := server.tags["*/*"]; ok {
		return tags
	}

	return nil
}
