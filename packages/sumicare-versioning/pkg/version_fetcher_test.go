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

package pkg

import (
	"strings"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("Version Fetcher", func() {
	var ctx *MockServerContext

	BeforeEach(func() { ctx = SetupMockServer() })
	AfterEach(func() { ctx.Teardown() })

	Describe("FetchGitHubReleasesWithPrefix", func() {
		It("fetches and filters releases with default prefix", func() {
			ctx.Server.AddReleases("owner", "repo", "v1.0.0", "v2.0.0", "v1.5.0", "v2.1.0-rc1", "invalid")
			versions, err := FetchGitHubReleasesWithPrefix("https://github.com/owner/repo.git", "v", 3)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"2.0.0", "1.5.0", "1.0.0"}))
		})

		It("excludes pre-release versions", func() {
			ctx.Server.AddReleases("owner", "repo", "v1.0.0", "v2.0.0-alpha", "v2.0.0-beta.1", "v2.0.0-rc1")
			versions, err := FetchGitHubReleasesWithPrefix("https://github.com/owner/repo.git", "v", 5)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"1.0.0"}))
		})

		It("uses default limit when zero", func() {
			ctx.Server.AddReleases("owner", "repo", "v1.0.0", "v2.0.0", "v3.0.0", "v4.0.0", "v5.0.0", "v6.0.0")
			versions, err := FetchGitHubReleasesWithPrefix("https://github.com/owner/repo.git", "v", 0)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(HaveLen(5))
		})

		It("returns error for invalid URL", func() {
			_, err := FetchGitHubReleasesWithPrefix("invalid", "v", 3)
			Expect(err).To(HaveOccurred())
		})

		It("strips custom prefix", func() {
			ctx.Server.AddReleases("owner", "repo", "release-1.0.0", "release-2.0.0", "release-1.5.0")
			versions, err := FetchGitHubReleasesWithPrefix("https://github.com/owner/repo.git", "release-", 3)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"2.0.0", "1.5.0", "1.0.0"}))
		})
	})

	Describe("FetchGitHubTagsWithPrefix", func() {
		It("fetches and filters tags with default prefix", func() {
			ctx.Server.AddTags("owner", "repo", "v1.0.0", "v2.0.0", "v1.5.0", "v2.1.0-rc1", "invalid")
			versions, err := FetchGitHubTagsWithPrefix("https://github.com/owner/repo.git", "v", 3)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"2.0.0", "1.5.0", "1.0.0"}))
		})

		It("excludes pre-release versions", func() {
			ctx.Server.AddTags("owner", "repo", "v1.0.0", "v2.0.0-alpha", "v2.0.0-beta.1")
			versions, err := FetchGitHubTagsWithPrefix("https://github.com/owner/repo.git", "v", 5)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"1.0.0"}))
		})

		It("strips custom prefix", func() {
			ctx.Server.AddTags("owner", "repo", "ver_1.0.0", "ver_2.0.0", "ver_1.5.0")
			versions, err := FetchGitHubTagsWithPrefix("https://github.com/owner/repo.git", "ver_", 3)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"2.0.0", "1.5.0", "1.0.0"}))
		})
	})

	Describe("FetchGitHubTagsWithTransform", func() {
		It("transforms tags", func() {
			ctx.Server.AddTags("owner", "repo", "REL_1_0", "REL_2_0", "REL_1_5")
			transform := func(s string) string {
				return strings.ReplaceAll(s, "_", ".")
			}
			versions, err := FetchGitHubTagsWithTransform("https://github.com/owner/repo.git", "REL_", 3, transform)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"2.0.0", "1.5.0", "1.0.0"}))
		})
	})
})
