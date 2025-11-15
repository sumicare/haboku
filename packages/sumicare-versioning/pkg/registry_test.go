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
	"errors"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

// errTestCustom is a static error for testing custom fetcher failure.
var errTestCustom = errors.New("custom error")

var _ = Describe("Registry", func() {
	Describe("GetVersion", func() {
		It("returns error for DockerHub fetcher", func() {
			config := ProjectConfig{
				Fetcher: FetcherDockerHub,
			}
			_, err := GetVersion(&config, 1)
			Expect(err).To(MatchError(ErrDockerHubNotImplemented))
		})

		It("returns error for nil Custom fetcher", func() {
			config := ProjectConfig{
				Fetcher: FetcherCustom,
			}
			_, err := GetVersion(&config, 1)
			Expect(err).To(MatchError(ErrCustomFetcherNil))
		})

		It("returns error for unknown fetcher type", func() {
			config := ProjectConfig{
				Fetcher: FetcherType("Unknown"),
			}
			_, err := GetVersion(&config, 1)
			Expect(err).To(MatchError(ContainSubstring("unknown fetcher type")))
		})

		It("returns error when custom fetcher fails", func() {
			config := ProjectConfig{
				Fetcher: FetcherCustom,
				Custom: func(_ int) ([]string, error) {
					return nil, errTestCustom
				},
			}
			_, err := GetVersion(&config, 1)
			Expect(err).To(MatchError(ContainSubstring("custom fetcher: custom error")))
		})

		It("returns fixed version", func() {
			config := ProjectConfig{
				Fetcher: FetcherFixed,
				Fixed:   "1.2.3",
			}
			versions, err := GetVersion(&config, 1)
			Expect(err).NotTo(HaveOccurred())
			Expect(versions).To(Equal([]string{"1.2.3"}))
		})
	})
})
