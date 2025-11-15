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
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

// testCase represents a common test case structure for GitHub API table-driven tests.
type testCase struct {
	fetchFunc     func(*Client, string, string, *int) ([]string, error)
	url           string
	authToken     string
	limit         *int
	errorContains string
	expectError   bool
	expectEmpty   bool
	skipIfNoToken bool
}

// TestGithubSuite runs the Github test suite.
func TestGithubSuite(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Github Suite")
}

var _ = Describe("GitHub API", func() {
	var client *Client

	BeforeEach(func() {
		client = NewClient()
	})

	DescribeTable("fetch functions",
		func(tc testCase) {
			if tc.skipIfNoToken && getGithubToken() == "" {
				Skip("Integration test - requires GITHUB_TOKEN environment variable")
			}

			result, err := tc.fetchFunc(client, tc.url, tc.authToken, tc.limit)

			if tc.expectError {
				Expect(err).To(HaveOccurred(), "expected error")
				if tc.errorContains != "" {
					Expect(err.Error()).To(ContainSubstring(tc.errorContains), "error contains")
				}
				Expect(result).To(BeNil(), "result is nil")
			} else {
				Expect(err).NotTo(HaveOccurred(), "no error")
				if tc.expectEmpty {
					Expect(result).To(BeEmpty(), "result is empty")
				} else if tc.skipIfNoToken {
					Expect(result).NotTo(BeEmpty(), "result is not empty")
					if tc.limit != nil {
						Expect(len(result)).To(BeNumerically("<=", *tc.limit), "result length is less than or equal to limit")
					}
				}
			}
		},
		Entry("GetReleases - invalid URL", testCase{
			fetchFunc: func(c *Client, url, token string, limit *int) ([]string, error) {
				return c.GetReleases(url, token, limit)
			},
			url:           "invalid-url",
			expectError:   true,
			errorContains: "invalid GitHub repository URL",
		}),
		Entry("GetReleases - limit of 0", testCase{
			fetchFunc: func(c *Client, url, token string, limit *int) ([]string, error) {
				return c.GetReleases(url, token, limit)
			},
			url:         "https://github.com/kubernetes/kubernetes",
			limit:       func() *int { i := 0; return &i }(),
			expectEmpty: true,
		}),
		Entry("GetReleases - integration test", testCase{
			fetchFunc: func(c *Client, url, token string, limit *int) ([]string, error) {
				return c.GetReleases(url, token, limit)
			},
			url:           "https://github.com/kubernetes/kubernetes",
			limit:         func() *int { i := 5; return &i }(),
			skipIfNoToken: true,
		}),
		Entry("GetTags - invalid URL", testCase{
			fetchFunc:     func(c *Client, url, token string, limit *int) ([]string, error) { return c.GetTags(url, token, limit) },
			url:           "invalid-url",
			expectError:   true,
			errorContains: "invalid GitHub repository URL",
		}),
		Entry("GetTags - limit of 0", testCase{
			fetchFunc:   func(c *Client, url, token string, limit *int) ([]string, error) { return c.GetTags(url, token, limit) },
			url:         "https://github.com/kubernetes/kubernetes",
			limit:       func() *int { i := 0; return &i }(),
			expectEmpty: true,
		}),
		Entry("GetTags - integration test", testCase{
			fetchFunc:     func(c *Client, url, token string, limit *int) ([]string, error) { return c.GetTags(url, token, limit) },
			url:           "https://github.com/kubernetes/kubernetes",
			limit:         func() *int { i := 5; return &i }(),
			skipIfNoToken: true,
		}),
	)
})
