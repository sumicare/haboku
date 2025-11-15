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
	"strings"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

// testCase represents a common test case structure for Docker Hub API table-driven tests.
type testCase struct {
	fetchFunc     func(string, func(string) bool, int) ([]string, error)
	filter        func(string) bool
	repository    string
	errorContains string
	limit         int
	expectError   bool
	expectEmpty   bool
}

// isRateLimitError checks if error is a 429 rate limit error.
func isRateLimitError(err error) bool {
	return err != nil && strings.Contains(err.Error(), "429")
}

// TestDockerHubSuite runs the Docker Hub test suite.
func TestDockerHubSuite(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Docker Hub Suite")
}

var _ = Describe("Docker Hub API", func() {
	DescribeTable("fetch functions",
		func(tc testCase) {
			result, err := tc.fetchFunc(tc.repository, tc.filter, tc.limit)

			// Skip on rate limit
			if isRateLimitError(err) {
				Skip("DockerHub rate limit (429)")
			}

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
				} else {
					Expect(result).NotTo(BeEmpty(), "result is not empty")
					if tc.limit > 0 {
						Expect(len(result)).To(BeNumerically("<=", tc.limit), "result length is less than or equal to limit")
					}
				}
			}
		},
		Entry("FetchImageTags - invalid repository", testCase{
			fetchFunc:     FetchImageTags,
			repository:    "invalid/repo/name/extra",
			filter:        nil,
			limit:         5,
			expectError:   true,
			errorContains: "unexpected status code",
		}),
		Entry("FetchImageTags - limit of 0", testCase{
			fetchFunc:   FetchImageTags,
			repository:  "debian",
			filter:      nil,
			limit:       0,
			expectEmpty: true,
		}),
		Entry("FetchImageTags - debian with no filter", testCase{
			fetchFunc:  FetchImageTags,
			repository: "debian",
			filter:     nil,
			limit:      5,
		}),
		Entry("FetchImageTags - debian with slim filter", testCase{
			fetchFunc:  FetchImageTags,
			repository: "debian",
			filter: func(tag string) bool {
				return tag != "" && tag[len(tag)-1] != 'm' // Simple filter
			},
			limit: 5,
		}),
		Entry("FetchImageTags - alpine with no filter", testCase{
			fetchFunc:  FetchImageTags,
			repository: "alpine",
			filter:     nil,
			limit:      5,
		}),
	)
})
