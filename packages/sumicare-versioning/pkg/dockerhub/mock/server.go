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

//nolint:errcheck // mock server - error checking not critical
package mock

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
)

type (
	// Tag represents a Docker image tag.
	Tag struct {
		Name string `json:"name"`
	}

	// TagsResponse represents the response from Docker Hub tags API.
	TagsResponse struct {
		Next    string `json:"next,omitempty"`
		Results []Tag  `json:"results"`
	}

	// Server is a mock Docker Hub server for testing.
	Server struct {
		*httptest.Server

		tags        map[string][]string // repo -> tags
		errorCode   int
		errorAfter  int // return error after N requests
		requests    int
		invalidJSON bool // return invalid JSON
	}
)

// NewServer creates a new mock Docker Hub server.
func NewServer() *Server {
	s := &Server{tags: make(map[string][]string)}

	s.Server = httptest.NewServer(http.HandlerFunc(s.handler))

	return s
}

// AddTags adds tags for a repository.
func (s *Server) AddTags(repo string, tags ...string) { s.tags[repo] = append(s.tags[repo], tags...) }

// SetError configures the server to return an error status code.
func (s *Server) SetError(code int) { s.errorCode = code }

// SetErrorAfter configures the server to return an error after N requests.
func (s *Server) SetErrorAfter(n, code int) { s.errorAfter, s.errorCode = n, code }

// SetInvalidJSON configures the server to return invalid JSON.
func (s *Server) SetInvalidJSON() { s.invalidJSON = true }

// URL returns the server URL.
func (s *Server) URL() string { return s.Server.URL }

// handler processes incoming requests.
func (server *Server) handler(writer http.ResponseWriter, req *http.Request) {
	server.requests++

	if server.errorAfter > 0 && server.requests > server.errorAfter {
		writer.WriteHeader(server.errorCode)
		return
	}

	if server.errorCode != 0 && server.errorAfter == 0 {
		writer.WriteHeader(server.errorCode)
		return
	}

	// Parse repo from path: /repositories/{repo}/tags
	path := req.URL.Path

	path = strings.TrimPrefix(path, "/repositories/")
	path = strings.TrimSuffix(path, "/tags")

	tags, ok := server.tags[path]
	if !ok {
		writer.WriteHeader(http.StatusNotFound)
		return
	}

	writer.Header().Set("Content-Type", "application/json")

	if server.invalidJSON {
		_, _ = writer.Write([]byte("invalid json"))
		return
	}

	resp := TagsResponse{}
	for _, t := range tags {
		resp.Results = append(resp.Results, Tag{Name: t})
	}

	_ = json.NewEncoder(writer).Encode(resp) //nolint:errchkjson // mock server
}
