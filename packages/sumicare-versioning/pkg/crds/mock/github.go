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

//nolint:godoclint // internal constants don't need godoc
const (
	expectedContentsParts = 2
	minRawPathParts       = 4
)

type (
	// GitHubFile represents a file in a GitHub repository.
	GitHubFile struct {
		Name        string `json:"name"`
		Path        string `json:"path"`
		Type        string `json:"type"`
		DownloadURL string `json:"download_url"`
		Content     string `json:"-"` // Content is not part of the API response
	}

	// GitHubMockServer provides a mock GitHub API server for testing.
	GitHubMockServer struct {
		Server      *httptest.Server
		Files       map[string][]GitHubFile // path -> files
		FileContent map[string]string       // download_url path -> content
		AuthToken   string                  // Expected auth token
	}
)

// NewGitHubMockServer creates a new mock GitHub API server.
func NewGitHubMockServer() *GitHubMockServer {
	mock := &GitHubMockServer{
		Files:       make(map[string][]GitHubFile),
		FileContent: make(map[string]string),
	}

	mock.Server = httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, req *http.Request) {
		// Check authorization if token is set
		if mock.AuthToken != "" {
			authHeader := req.Header.Get("Authorization")

			expectedAuth := "token " + mock.AuthToken
			if authHeader != expectedAuth {
				writer.WriteHeader(http.StatusUnauthorized)
				return
			}
		}

		path := req.URL.Path

		// Handle GitHub API contents endpoint
		if strings.HasPrefix(path, "/repos/") && strings.Contains(path, "/contents/") {
			mock.handleContentsRequest(writer, req)
			return
		}

		// Handle raw file download
		if strings.HasPrefix(path, "/raw/") {
			mock.handleRawDownload(writer, req)
			return
		}

		writer.WriteHeader(http.StatusNotFound)
	}))

	return mock
}

// handleContentsRequest handles GitHub API contents requests.
func (mockServer *GitHubMockServer) handleContentsRequest(writer http.ResponseWriter, req *http.Request) {
	path := req.URL.Path

	// Extract the contents path from the URL
	// Format: /repos/{owner}/{repo}/contents/{path}
	parts := strings.Split(path, "/contents/")
	if len(parts) != expectedContentsParts {
		writer.WriteHeader(http.StatusNotFound)
		return
	}

	contentsPath := parts[1]

	files, ok := mockServer.Files[contentsPath]
	if !ok {
		writer.WriteHeader(http.StatusNotFound)
		return
	}

	writer.Header().Set("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)

	//nolint:errcheck,errchkjson // Ignore write errors in mock server
	_ = json.NewEncoder(writer).Encode(files)
}

// handleRawDownload handles raw file download requests.
func (mockServer *GitHubMockServer) handleRawDownload(writer http.ResponseWriter, req *http.Request) {
	path := req.URL.Path

	// The path format from github_downloader is: /raw/{owner}/{repo}/{ref}/{path}
	// We need to extract just the file path part
	parts := strings.Split(strings.TrimPrefix(path, "/raw/"), "/")
	if len(parts) < minRawPathParts {
		writer.WriteHeader(http.StatusNotFound)
		return
	}

	// Skip owner/repo/ref and join the rest as the file path
	filePath := strings.Join(parts[3:], "/")

	content, ok := mockServer.FileContent[filePath]
	if !ok {
		writer.WriteHeader(http.StatusNotFound)
		return
	}

	writer.Header().Set("Content-Type", "text/plain")
	writer.WriteHeader(http.StatusOK)

	//nolint:errcheck // Ignore write errors in mock server
	_, _ = writer.Write([]byte(content))
}

// AddCRDFile adds a CRD file to the mock server.
func (mockServer *GitHubMockServer) AddCRDFile(dirPath, fileName, crdName string) {
	filePath := dirPath + "/" + fileName

	mockServer.Files[dirPath] = append(mockServer.Files[dirPath], GitHubFile{
		Name: fileName, Path: filePath, Type: "file",
		DownloadURL: mockServer.Server.URL + "/raw/" + filePath,
	})
	mockServer.FileContent[filePath] = generateCRD(crdName)
}

// AddDirectory adds a directory entry to the mock server.
func (mockServer *GitHubMockServer) AddDirectory(parentPath, dirName string) {
	mockServer.Files[parentPath] = append(mockServer.Files[parentPath], GitHubFile{
		Name: dirName, Path: parentPath + "/" + dirName, Type: "dir",
	})
}

// SetAuthToken sets the expected authorization token.
func (mockServer *GitHubMockServer) SetAuthToken(token string) { mockServer.AuthToken = token }

// URL returns the base URL of the mock server.
func (mockServer *GitHubMockServer) URL() string { return mockServer.Server.URL }

// Close shuts down the mock server.
func (mockServer *GitHubMockServer) Close() { mockServer.Server.Close() }
