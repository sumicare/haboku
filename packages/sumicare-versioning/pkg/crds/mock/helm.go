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
	"archive/tar"
	"bytes"
	"compress/gzip"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"

	"go.yaml.in/yaml/v3"
)

//nolint:godoclint // internal constants and methods don't need godoc
const defaultTarFileMode = 0o644

type (
	// HelmChart represents a Helm chart in the repository.
	HelmChart struct {
		CRDs          map[string]string
		Name, Version string
	}

	// HelmMockServer provides a mock Helm chart repository server for testing.
	HelmMockServer struct {
		Server *httptest.Server
		Charts map[string]*HelmChart
	}
)

// NewHelmMockServer creates a new mock Helm chart repository server.
func NewHelmMockServer() *HelmMockServer {
	mock := &HelmMockServer{Charts: make(map[string]*HelmChart)}

	mock.Server = httptest.NewServer(http.HandlerFunc(func(writer http.ResponseWriter, req *http.Request) {
		switch {
		case req.URL.Path == "/index.yaml":
			mock.serveIndex(writer)
		case strings.HasSuffix(req.URL.Path, ".tgz"):
			mock.serveChart(writer, req)
		default:
			writer.WriteHeader(http.StatusNotFound)
		}
	}))

	return mock
}

// serveIndex serves the index.yaml file.
func (mockServer *HelmMockServer) serveIndex(writer http.ResponseWriter) {
	type entry struct {
		Name    string   `yaml:"name"`
		Version string   `yaml:"version"`
		URLs    []string `yaml:"urls"`
	}

	index := struct {
		Entries    map[string][]entry `yaml:"entries"`
		APIVersion string             `yaml:"apiVersion"`
	}{APIVersion: "v1", Entries: make(map[string][]entry)}

	for name, chart := range mockServer.Charts {
		index.Entries[name] = []entry{{
			Name: name, Version: chart.Version,
			URLs: []string{fmt.Sprintf("%s/%s-%s.tgz", mockServer.Server.URL, name, chart.Version)},
		}}
	}

	writer.Header().Set("Content-Type", "application/x-yaml")
	writer.WriteHeader(http.StatusOK)

	_ = yaml.NewEncoder(writer).Encode(index) //nolint:errcheck // mock server
}

// serveChart serves a Helm chart archive.
func (mockServer *HelmMockServer) serveChart(writer http.ResponseWriter, req *http.Request) {
	fileName := strings.TrimSuffix(strings.TrimPrefix(req.URL.Path, "/"), ".tgz")

	var chart *HelmChart
	for name, c := range mockServer.Charts {
		if fileName == name+"-"+c.Version {
			chart = c
			break
		}
	}

	if chart == nil {
		writer.WriteHeader(http.StatusNotFound)
		return
	}

	archive, err := mockServer.buildArchive(chart)
	if err != nil {
		writer.WriteHeader(http.StatusInternalServerError)
		return
	}

	writer.Header().Set("Content-Type", "application/gzip")

	_, _ = writer.Write(archive) //nolint:errcheck // mock server
}

// buildArchive builds a Helm chart archive.
func (*HelmMockServer) buildArchive(chart *HelmChart) ([]byte, error) {
	var buf bytes.Buffer

	gzw := gzip.NewWriter(&buf)
	tw := tar.NewWriter(gzw)

	writeFile := func(name string, content []byte) error {
		hdr := &tar.Header{Name: name, Mode: defaultTarFileMode, Size: int64(len(content))}

		err := tw.WriteHeader(hdr)
		if err != nil {
			return fmt.Errorf("write header: %w", err)
		}

		_, err = tw.Write(content)
		if err != nil {
			return fmt.Errorf("write content: %w", err)
		}

		return nil
	}

	chartYAML := fmt.Sprintf("apiVersion: v2\nname: %s\nversion: %s\n", chart.Name, chart.Version)

	err := writeFile(chart.Name+"/Chart.yaml", []byte(chartYAML))
	if err != nil {
		return nil, fmt.Errorf("write chart.yaml: %w", err)
	}

	for fileName, content := range chart.CRDs {
		err = writeFile(chart.Name+"/crds/"+fileName, []byte(content))
		if err != nil {
			return nil, fmt.Errorf("write file: %w", err)
		}
	}

	err = tw.Close()
	if err != nil {
		return nil, fmt.Errorf("close tar: %w", err)
	}

	err = gzw.Close()
	if err != nil {
		return nil, fmt.Errorf("close gzip: %w", err)
	}

	return buf.Bytes(), nil
}

// AddChart adds a chart to the mock server.
func (mockServer *HelmMockServer) AddChart(name, version string) {
	mockServer.Charts[name] = &HelmChart{Name: name, Version: version, CRDs: make(map[string]string)}
}

// AddCRDToChart adds a CRD to a chart.
func (mockServer *HelmMockServer) AddCRDToChart(chartName, fileName, crdName string) {
	if chart, ok := mockServer.Charts[chartName]; ok {
		chart.CRDs[fileName] = generateCRD(crdName)
	}
}

// URL returns the base URL of the mock server.
func (mockServer *HelmMockServer) URL() string { return mockServer.Server.URL }

// Close shuts down the mock server.
func (mockServer *HelmMockServer) Close() { mockServer.Server.Close() }
