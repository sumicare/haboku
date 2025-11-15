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
	"net/http"
	"strings"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"sumi.care/util/sumicare-versioning/pkg/dockerhub/mock"
)

var _ = Describe("FetchImageTags", func() {
	var (
		server  *mock.Server
		origURL string
	)

	BeforeEach(func() {
		origURL = baseURL
		server = mock.NewServer()
		baseURL = server.URL()
	})

	AfterEach(func() {
		server.Close()
		baseURL = origURL
	})

	DescribeTable("fetches tags correctly",
		func(repo, serverRepo string, serverTags []string, filter func(string) bool, limit int, expected []string) {
			server.AddTags(serverRepo, serverTags...)
			tags, err := FetchImageTags(repo, filter, limit)
			Expect(err).NotTo(HaveOccurred())
			Expect(tags).To(Equal(expected))
		},
		Entry("with filter", "test/repo", "test/repo", []string{"v1.0", "v2.0", "latest"}, func(t string) bool { return strings.HasPrefix(t, "v") }, 10, []string{"v1.0", "v2.0"}),
		Entry("library prefix", "debian", "library/debian", []string{"12", "11"}, nil, 10, []string{"12", "11"}),
		Entry("respects limit", "test/repo", "test/repo", []string{"t1", "t2", "t3", "t4"}, nil, 2, []string{"t1", "t2"}),
	)

	DescribeTable("handles errors",
		func(setup func(), expectedErr string) {
			setup()
			_, err := FetchImageTags("test/repo", nil, 10)
			Expect(err).To(HaveOccurred())
			Expect(err.Error()).To(ContainSubstring(expectedErr))
		},
		Entry("HTTP 500", func() { server.AddTags("test/repo", "t1"); server.SetError(http.StatusInternalServerError) }, "500"),
		Entry("not found", func() {}, "404"),
		Entry("invalid JSON", func() { server.AddTags("test/repo", "t1"); server.SetInvalidJSON() }, "parse"),
		Entry("network error", func() { server.Close(); baseURL = "http://localhost:1" }, "connect"),
	)
})
