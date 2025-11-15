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
	"regexp"
	"strings"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

// GetDebianVersion tests verify fetching Debian slim image tags from Docker Hub.
// These tests ensure proper filtering and sorting of Debian release tags.
var _ = Describe("GetDebianVersion", func() {
	// Verify that Debian slim versions are fetched correctly from DockerHub.
	It("fetches Debian slim versions from DockerHub", func() {
		versions, err := GetDebianVersion(5)
		Expect(err).NotTo(HaveOccurred())
		Expect(versions).NotTo(BeEmpty())

		for _, v := range versions {
			Expect(strings.HasSuffix(v, "-slim")).To(BeTrue())
		}
	})
})

// GetPostgresVersion tests verify fetching PostgreSQL versions from GitHub tags.
// PostgreSQL uses REL_X_Y format which is transformed to X.Y format.
var _ = Describe("GetPostgresVersion", func() {
	var ctx *MockServerContext

	// Set up mock server with sample PostgreSQL tags.
	BeforeEach(func() {
		ctx = SetupMockServer()
		ctx.Server.AddTags("postgres", "postgres",
			"REL_18_1",
			"REL_18_0",
			"REL_17_7",
			"REL_17_6",
			"REL_16_10",
			"REL_18_BETA1",
			"REL_17_RC1",
			"invalid-tag",
			"REL7_4_9", // Old format without underscore after REL
		)
	})

	AfterEach(func() { ctx.Teardown() })

	It("fetches filtered PostgreSQL versions", func() {
		versions, err := GetPostgresVersion(5)
		Expect(err).NotTo(HaveOccurred())
		Expect(versions).NotTo(BeEmpty())

		// Verify all versions match the pattern X.Y or X.Y.Z
		versionPattern := regexp.MustCompile(`^\d+\.\d+(\.\d+)?$`)
		for _, v := range versions {
			Expect(versionPattern.MatchString(v)).To(BeTrue())
		}
	})

	It("returns versions in descending order", func() {
		versions, err := GetPostgresVersion(5)
		Expect(err).NotTo(HaveOccurred())
		Expect(len(versions)).To(BeNumerically(">=", 3))

		// 18.1 should be first, then 18.0, then 17.x
		Expect(versions[0]).To(Equal("18.1"))
		Expect(versions[1]).To(Equal("18.0"))
		Expect(strings.HasPrefix(versions[2], "17.")).To(BeTrue())
	})

	It("filters out beta and RC versions", func() {
		versions, err := GetPostgresVersion(10)
		Expect(err).NotTo(HaveOccurred())

		for _, v := range versions {
			Expect(strings.Contains(v, "BETA")).To(BeFalse())
			Expect(strings.Contains(v, "RC")).To(BeFalse())
		}
	})

	It("filters out old format tags", func() {
		versions, err := GetPostgresVersion(10)
		Expect(err).NotTo(HaveOccurred())

		// REL7_4_9 should be filtered out (doesn't start with REL_)
		for _, v := range versions {
			Expect(strings.HasPrefix(v, "7.")).To(BeFalse())
		}
	})

	It("returns non-semver format (X.Y not X.Y.0)", func() {
		versions, err := GetPostgresVersion(5)
		Expect(err).NotTo(HaveOccurred())
		Expect(versions[0]).To(Equal("18.1"))
		Expect(versions[0]).NotTo(Equal("18.1.0"))
	})

	It("uses default limit when zero", func() {
		versions, err := GetPostgresVersion(0)
		Expect(err).NotTo(HaveOccurred())
		Expect(len(versions)).To(BeNumerically("<=", DefaultVersionLimit))
	})

	It("returns error when server fails", func() {
		ctx.Server.Close()
		_, err := GetPostgresVersion(3)
		Expect(err).To(HaveOccurred())
	})
})

// GetRustFSVersion tests verify fetching RustFS versions from GitHub releases.
// RustFS uses semver with pre-release tags (e.g., 1.0.0-alpha.71).
var _ = Describe("GetRustFSVersion", func() {
	var ctx *MockServerContext

	// Set up mock server with sample RustFS releases.
	BeforeEach(func() {
		ctx = SetupMockServer()
		ctx.Server.AddReleases("rustfs", "rustfs",
			"1.0.0-alpha.71",
			"1.0.0-alpha.70",
			"1.0.0-alpha.69",
			"1.0.0-alpha.68",
			"1.0.0-alpha.67",
		)
	})

	AfterEach(func() { ctx.Teardown() })

	It("fetches RustFS versions including pre-releases", func() {
		versions, err := GetRustFSVersion(5)
		Expect(err).NotTo(HaveOccurred())
		Expect(versions).NotTo(BeEmpty())
	})

	It("returns versions in descending order", func() {
		versions, err := GetRustFSVersion(5)
		Expect(err).NotTo(HaveOccurred())
		Expect(versions[0]).To(Equal("1.0.0-alpha.71"))
		Expect(versions[1]).To(Equal("1.0.0-alpha.70"))
	})

	It("uses default limit when zero", func() {
		versions, err := GetRustFSVersion(0)
		Expect(err).NotTo(HaveOccurred())
		Expect(len(versions)).To(BeNumerically("<=", DefaultVersionLimit))
	})

	It("returns error when server fails", func() {
		ctx.Server.Close()
		_, err := GetRustFSVersion(3)
		Expect(err).To(HaveOccurred())
	})
})

// compareSemverWithPrerelease tests verify semver comparison including pre-releases.
var _ = Describe("compareSemverWithPrerelease", func() {
	It("compares major versions correctly", func() {
		Expect(compareSemverWithPrerelease("2.0.0-alpha.1", "1.0.0-alpha.1")).To(Equal(1))
		Expect(compareSemverWithPrerelease("1.0.0-alpha.1", "2.0.0-alpha.1")).To(Equal(-1))
	})

	It("compares minor versions correctly", func() {
		Expect(compareSemverWithPrerelease("1.1.0-alpha.1", "1.0.0-alpha.1")).To(Equal(1))
		Expect(compareSemverWithPrerelease("1.0.0-alpha.1", "1.1.0-alpha.1")).To(Equal(-1))
	})

	It("compares patch versions correctly", func() {
		Expect(compareSemverWithPrerelease("1.0.1-alpha.1", "1.0.0-alpha.1")).To(Equal(1))
		Expect(compareSemverWithPrerelease("1.0.0-alpha.1", "1.0.1-alpha.1")).To(Equal(-1))
	})

	It("compares pre-release numbers correctly", func() {
		Expect(compareSemverWithPrerelease("1.0.0-alpha.71", "1.0.0-alpha.70")).To(Equal(1))
		Expect(compareSemverWithPrerelease("1.0.0-alpha.70", "1.0.0-alpha.71")).To(Equal(-1))
		Expect(compareSemverWithPrerelease("1.0.0-alpha.71", "1.0.0-alpha.71")).To(Equal(0))
	})

	It("handles versions without pre-release", func() {
		Expect(compareSemverWithPrerelease("1.0.0", "1.0.0")).To(Equal(0))
		Expect(compareSemverWithPrerelease("2.0.0", "1.0.0")).To(Equal(1))
	})
})

// parseSemverParts tests verify parsing of semver strings into components.
var _ = Describe("parseSemverParts", func() {
	It("parses version with pre-release", func() {
		parts := parseSemverParts("1.0.0-alpha.71")
		Expect(parts).To(Equal([4]int{1, 0, 0, 71}))
	})

	It("parses version without pre-release", func() {
		parts := parseSemverParts("1.2.3")
		Expect(parts).To(Equal([4]int{1, 2, 3, 0}))
	})

	It("parses version with beta pre-release", func() {
		parts := parseSemverParts("2.0.0-beta.5")
		Expect(parts).To(Equal([4]int{2, 0, 0, 5}))
	})
})

// compareVersions tests verify version string comparison for PostgreSQL-style versions.
var _ = Describe("compareVersions", func() {
	It("compares major versions correctly", func() {
		Expect(compareVersions("18.0", "17.0")).To(Equal(1))
		Expect(compareVersions("17.0", "18.0")).To(Equal(-1))
		Expect(compareVersions("18.0", "18.0")).To(Equal(0))
	})

	It("compares minor versions correctly", func() {
		Expect(compareVersions("18.1", "18.0")).To(Equal(1))
		Expect(compareVersions("18.0", "18.1")).To(Equal(-1))
		Expect(compareVersions("17.7", "17.6")).To(Equal(1))
	})

	It("compares patch versions correctly", func() {
		Expect(compareVersions("17.6.1", "17.6.0")).To(Equal(1))
		Expect(compareVersions("17.6.0", "17.6.1")).To(Equal(-1))
		Expect(compareVersions("17.6.1", "17.6.1")).To(Equal(0))
	})

	It("handles versions with different lengths", func() {
		Expect(compareVersions("18.1", "18.1.0")).To(Equal(0))
		Expect(compareVersions("18.1.0", "18.1")).To(Equal(0))
		Expect(compareVersions("18.1.1", "18.1")).To(Equal(1))
		Expect(compareVersions("18.1", "18.1.1")).To(Equal(-1))
	})

	It("handles single digit versions", func() {
		Expect(compareVersions("9.6", "9.5")).To(Equal(1))
		Expect(compareVersions("10.0", "9.6")).To(Equal(1))
	})
})
