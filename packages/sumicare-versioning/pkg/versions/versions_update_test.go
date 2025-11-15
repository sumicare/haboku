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

//nolint:errcheck // test file - error checking handled by test assertions
package versions_test

import (
	"encoding/json"
	"errors"
	"os"
	"path/filepath"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"sumi.care/util/sumicare-versioning/pkg/versions"
)

//nolint:godoclint,errname // test error sentinel
var errTestErr = errors.New("test error")

var _ = Describe("Versions Update", func() {
	It("EnsureCorrectDirectory navigates to root or fails", func() {
		tmpDir := GinkgoT().TempDir()
		rootDir := filepath.Join(tmpDir, "repo")
		subDir := filepath.Join(rootDir, "packages", "test")
		Expect(os.MkdirAll(subDir, 0o755)).To(Succeed())

		data, err := json.Marshal(versions.PackageJSON{Name: versions.ExpectedPackageName, Version: "1.0.0"})
		Expect(err).NotTo(HaveOccurred())
		Expect(os.WriteFile(filepath.Join(rootDir, "package.json"), data, 0o600)).To(Succeed())
		subData, err := json.Marshal(versions.PackageJSON{Name: "test", Version: "1.0.0"})
		Expect(err).NotTo(HaveOccurred())
		Expect(os.WriteFile(filepath.Join(subDir, "package.json"), subData, 0o600)).To(Succeed())

		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()

		Expect(os.Chdir(subDir)).To(Succeed())
		Expect(versions.EnsureCorrectDirectory()).To(Succeed())
		cwd, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		Expect(cwd).To(Equal(rootDir))

		Expect(os.Chdir(tmpDir)).To(Succeed())
		Expect(versions.EnsureCorrectDirectory()).ToNot(Succeed())
	})

	DescribeTable("GetPreservedVersion",
		func(pkg, current, expected string) {
			Expect(versions.GetPreservedVersion(pkg, current)).To(Equal(expected))
		},
		Entry("rust", "rust", "1.0.0", "nightly"),
		Entry("debian with hyphen", "debian", "trixie-slim", "trixie-slim"),
		Entry("debian without hyphen", "debian", "12", ""),
		Entry("other", "compute-keda", "2.0.0", ""),
	)

	It("GetProjectFetchers returns valid fetchers", func() {
		fetchers := versions.GetProjectFetchers()
		Expect(fetchers).NotTo(BeEmpty())
	})

	It("FindMissingProjects finds missing", func() {
		vf := versions.VersionsFile{"compute-keda": "1.0.0"}
		Expect(versions.FindMissingProjects(vf)).To(HaveLen(len(versions.GetProjectFetchers()) - 1))

		for p := range versions.GetProjectFetchers() {
			vf[p] = "1.0.0"
		}
		Expect(versions.FindMissingProjects(vf)).To(BeEmpty())
	})

	It("FetchMissingVersions uses default fetchers", func() {
		versions.FetchMissingVersions(versions.VersionsFile{})
	})

	It("FetchMissingVersionsWithFetchers handles all cases", func() {
		vf := versions.VersionsFile{"existing": "1.0.0"}
		fetchers := map[string]versions.VersionFetcher{
			"existing": func(_ int) ([]string, error) { return []string{"1.0.0"}, nil },
			"missing":  func(_ int) ([]string, error) { return []string{"2.0.0"}, nil },
		}
		versions.FetchMissingVersionsWithFetchers(vf, fetchers)
		Expect(vf["missing"]).To(Equal("2.0.0"))

		vf = versions.VersionsFile{}
		fetchers = map[string]versions.VersionFetcher{
			"error": func(_ int) ([]string, error) { return nil, errTestErr },
			"empty": func(_ int) ([]string, error) { return make([]string, 0), nil },
		}
		versions.FetchMissingVersionsWithFetchers(vf, fetchers)
		Expect(vf).NotTo(HaveKey("error"))

		vf = versions.VersionsFile{"pkg": "1.0.0"}
		fetchers = map[string]versions.VersionFetcher{"pkg": func(_ int) ([]string, error) { return []string{"1.0.0"}, nil }}
		Expect(versions.FetchMissingVersionsWithFetchers(vf, fetchers)).To(BeEmpty())
	})

	It("UpdateVersionsJSON creates and merges", func() {
		tmpDir := GinkgoT().TempDir()
		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()
		Expect(os.Chdir(tmpDir)).To(Succeed())

		Expect(versions.UpdateVersionsJSON(versions.VersionsFile{"a": "1.0"})).To(Succeed())
		Expect(versions.UpdateVersionsJSON(versions.VersionsFile{"b": "2.0"})).To(Succeed())

		data, err := os.ReadFile(versions.VersionsFileName)
		Expect(err).NotTo(HaveOccurred())
		var result versions.VersionsFile
		Expect(json.Unmarshal(data, &result)).To(Succeed())
		Expect(result).To(HaveKeyWithValue("a", "1.0"))
		Expect(result).To(HaveKeyWithValue("b", "2.0"))

		Expect(os.WriteFile(versions.VersionsFileName, []byte("invalid"), 0o600)).To(Succeed())
		Expect(versions.UpdateVersionsJSON(versions.VersionsFile{"x": "1.0"})).ToNot(Succeed())
	})
})
