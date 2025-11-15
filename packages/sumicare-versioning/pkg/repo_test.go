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
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("Repos", func() {
	It("returns non-empty map with valid GitHub URLs", func() {
		repos := Repos()
		Expect(repos).NotTo(BeEmpty())

		for key, url := range repos {
			Expect(url).To(ContainSubstring("github.com"), "repo %s", key)
			Expect(url).To(HaveSuffix(".git"), "repo %s", key)
		}
	})
})
