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

package crds

import (
	"context"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"sumi.care/util/sumicare-versioning/pkg/crds/mock"
)

var _ = Describe("URL Downloader", func() {
	var (
		downloader *urlDownloader
		mockServer *mock.URLMockServer
		ctx        context.Context
	)

	BeforeEach(func() {
		downloader = newURLDownloader()
		mockServer = mock.NewURLMockServer()
		ctx = context.Background()
	})

	AfterEach(func() { mockServer.Close() })

	Describe("newURLDownloader", func() {
		It("creates downloader with timeout", func() {
			d := newURLDownloader()
			Expect(d).NotTo(BeNil())
			Expect(d.client).NotTo(BeNil())
			Expect(d.client.Timeout).To(Equal(defaultDownloaderTimeout))
		})
	})

	Describe("download", func() {
		It("downloads single CRD", func() {
			mockServer.AddCRD("/crd.yaml", "tests.example.com")
			urls := map[string]string{"crd.yaml": mockServer.GetURL("/crd.yaml")}

			crds, err := downloader.download(ctx, urls)
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(1))
			Expect(crds).To(HaveKey("tests.example.com.yaml"))
		})

		It("downloads multi-document CRD", func() {
			mockServer.AddMultiDocCRD("/crds.yaml", "tests1.example.com", "tests2.example.com")
			urls := map[string]string{"crds.yaml": mockServer.GetURL("/crds.yaml")}

			crds, err := downloader.download(ctx, urls)
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(2))
			Expect(crds).To(HaveKey("tests1.example.com.yaml"))
			Expect(crds).To(HaveKey("tests2.example.com.yaml"))
		})

		It("filters CRDs from mixed content", func() {
			mockServer.AddMixedContent("/mixed.yaml", []string{"tests.example.com"}, []string{"configmap1"})
			urls := map[string]string{"mixed.yaml": mockServer.GetURL("/mixed.yaml")}

			crds, err := downloader.download(ctx, urls)
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(1))
			Expect(crds).To(HaveKey("tests.example.com.yaml"))
		})

		It("downloads from multiple URLs", func() {
			mockServer.AddCRD("/crd1.yaml", "tests1.example.com")
			mockServer.AddCRD("/crd2.yaml", "tests2.example.com")
			urls := map[string]string{
				"crd1.yaml": mockServer.GetURL("/crd1.yaml"),
				"crd2.yaml": mockServer.GetURL("/crd2.yaml"),
			}

			crds, err := downloader.download(ctx, urls)
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(2))
		})

		It("handles empty URLs map", func() {
			crds, err := downloader.download(ctx, make(map[string]string))
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(BeEmpty())
		})

		It("returns error for HTTP errors", func() {
			urls := map[string]string{"crd.yaml": mockServer.GetURL("/nonexistent")}
			_, err := downloader.download(ctx, urls)
			Expect(err).To(HaveOccurred())
		})
	})

	Describe("fetchURL", func() {
		It("fetches URL content", func() {
			mockServer.AddContent("/test", "test content")
			content, err := downloader.fetchURL(ctx, mockServer.GetURL("/test"))
			Expect(err).NotTo(HaveOccurred())
			Expect(content).To(Equal("test content"))
		})

		It("returns error for 404", func() {
			_, err := downloader.fetchURL(ctx, mockServer.GetURL("/nonexistent"))
			Expect(err).To(HaveOccurred())
			Expect(err.Error()).To(ContainSubstring("404"))
		})
	})
})
