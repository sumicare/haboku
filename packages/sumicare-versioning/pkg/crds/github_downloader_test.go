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
	"os"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"sumi.care/util/sumicare-versioning/pkg/crds/mock"
)

var _ = Describe("GitHub Downloader", func() {
	var (
		downloader *githubDownloader
		mockServer *mock.GitHubMockServer
		ctx        context.Context
	)

	BeforeEach(func() {
		downloader = newGitHubDownloader()
		mockServer = mock.NewGitHubMockServer()
		downloader.apiBaseURL = mockServer.URL()
		downloader.rawBaseURL = mockServer.URL() + "/raw"
		ctx = context.Background()
	})

	AfterEach(func() { mockServer.Close() })

	Describe("newGitHubDownloader", func() {
		It("creates downloader with timeout", func() {
			d := newGitHubDownloader()
			Expect(d).NotTo(BeNil())
			Expect(d.client).NotTo(BeNil())
			Expect(d.client.Timeout).To(Equal(defaultDownloaderTimeout))
		})

		It("reads token from environment", func() {
			os.Setenv(githubTokenEnvVar, "test-token")
			defer os.Unsetenv(githubTokenEnvVar)

			d := newGitHubDownloader()
			Expect(d.token).To(Equal("test-token"))
		})
	})

	Describe("download", func() {
		It("returns error for nil GitHubDir", func() {
			_, err := downloader.download(ctx, nil)
			Expect(err).To(Equal(ErrGitHubDirNil))
		})

		It("downloads CRDs from GitHub directory", func() {
			mockServer.AddCRDFile("crds", "test-crd.yaml", "tests.example.com")

			crds, err := downloader.download(ctx, &GitHubCRDDir{
				Owner: "test-owner", Repo: "test-repo", Path: "crds", Ref: "main",
			})
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(1))
			Expect(crds).To(HaveKey("tests.example.com.yaml"))
		})

		It("downloads multiple CRDs", func() {
			mockServer.AddCRDFile("crds", "test1.yaml", "tests1.example.com")
			mockServer.AddCRDFile("crds", "test2.yaml", "tests2.example.com")

			crds, err := downloader.download(ctx, &GitHubCRDDir{
				Owner: "test-owner", Repo: "test-repo", Path: "crds", Ref: "main",
			})
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(2))
		})

		It("filters files by pattern", func() {
			mockServer.AddCRDFile("crds", "test.yaml", "tests.example.com")

			crds, err := downloader.download(ctx, &GitHubCRDDir{
				Owner: "test-owner", Repo: "test-repo", Path: "crds", Ref: "main", FilePattern: "*.yaml",
			})
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(1))
		})

		It("returns error for non-existent directory", func() {
			_, err := downloader.download(ctx, &GitHubCRDDir{
				Owner: "test-owner", Repo: "test-repo", Path: "non-existent", Ref: "main",
			})
			Expect(err).To(HaveOccurred())
		})
	})

	Describe("authentication", func() {
		It("uses valid token", func() {
			mockServer.SetAuthToken("test-token")
			mockServer.AddCRDFile("crds", "test.yaml", "tests.example.com")
			downloader.token = "test-token"

			crds, err := downloader.download(ctx, &GitHubCRDDir{
				Owner: "test-owner", Repo: "test-repo", Path: "crds", Ref: "main",
			})
			Expect(err).NotTo(HaveOccurred())
			Expect(crds).To(HaveLen(1))
		})

		It("fails with invalid token", func() {
			mockServer.SetAuthToken("valid-token")
			mockServer.AddCRDFile("crds", "test.yaml", "tests.example.com")
			downloader.token = "invalid-token"

			_, err := downloader.download(ctx, &GitHubCRDDir{
				Owner: "test-owner", Repo: "test-repo", Path: "crds", Ref: "main",
			})
			Expect(err).To(HaveOccurred())
		})
	})
})
