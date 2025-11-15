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
	"net/http"
	"net/http/httptest"
	"strings"
)

// URLMockServer provides a mock server for direct URL downloads.
type URLMockServer struct {
	Server  *httptest.Server
	Content map[string]string
}

// NewURLMockServer creates a new mock URL server.
func NewURLMockServer() *URLMockServer {
	mock := &URLMockServer{Content: make(map[string]string)}

	mock.Server = httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if content, ok := mock.Content[r.URL.Path]; ok {
			w.Header().Set("Content-Type", "text/plain")

			_, _ = w.Write([]byte(content)) //nolint:errcheck // mock server
		} else {
			w.WriteHeader(http.StatusNotFound)
		}
	}))

	return mock
}

// AddCRD adds a CRD to the mock server.
func (mockServer *URLMockServer) AddCRD(path, crdName string) {
	mockServer.Content[path] = generateCRD(crdName)
}

// AddMultiDocCRD adds a multi-document YAML with multiple CRDs.
func (mockServer *URLMockServer) AddMultiDocCRD(path string, crdNames ...string) {
	docs := make([]string, 0, len(crdNames))
	for _, name := range crdNames {
		docs = append(docs, strings.TrimSuffix(generateCRD(name), "\n"))
	}

	mockServer.Content[path] = strings.Join(docs, "\n---\n")
}

// AddMixedContent adds a multi-document YAML with CRDs and other resources.
func (mockServer *URLMockServer) AddMixedContent(path string, crdNames, otherResources []string) {
	docs := make([]string, 0, len(crdNames)+len(otherResources))
	for _, name := range crdNames {
		docs = append(docs, strings.TrimSuffix(generateCRD(name), "\n"))
	}

	for _, name := range otherResources {
		docs = append(docs, "apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: "+name+"\ndata:\n  key: value")
	}

	mockServer.Content[path] = strings.Join(docs, "\n---\n")
}

// AddContent adds raw content to the mock server.
func (mockServer *URLMockServer) AddContent(path, content string) { mockServer.Content[path] = content }

// URL returns the base URL of the mock server.
func (mockServer *URLMockServer) URL() string { return mockServer.Server.URL }

// GetURL returns the full URL for a path.
func (mockServer *URLMockServer) GetURL(path string) string { return mockServer.Server.URL + path }

// Close shuts down the mock server.
func (mockServer *URLMockServer) Close() { mockServer.Server.Close() }
