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
package asdf

import (
	"errors"
	"os"
	"path/filepath"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

//nolint:godoclint // test error sentinels
var (
	errTestFail    = errors.New("fail")
	errTestUnknown = errors.New("unknown")
)

var _ = Describe("asdf update", func() {
	var (
		origExecutor  func(string, ...string) ([]byte, error)
		origInstaller func(string, string) error
	)
	BeforeEach(func() { origExecutor, origInstaller = commandExecutor, toolInstaller })
	AfterEach(func() { commandExecutor, toolInstaller = origExecutor, origInstaller })

	DescribeTable("selectLatestSemverVersion",
		func(lines []string, expected string, shouldErr bool) {
			v, err := selectLatestSemverVersion(lines, "tool")
			if shouldErr {
				Expect(err).To(HaveOccurred())
			} else {
				Expect(v).To(Equal(expected))
			}
		},
		Entry("stable over prerelease", []string{"2.0.0", "2.1.0-rc1", "2.1.0"}, "2.1.0", false),
		Entry("prerelease fallback", []string{"2.0.0-rc1", "2.0.0-dev"}, "2.0.0-rc1", false),
		Entry("highest stable", []string{"1.0.0", "2.0.0", "1.5.0"}, "2.0.0", false),
		Entry("with annotations", []string{"1.0.0 (installed)", "1.1.0"}, "1.1.0", false),
		Entry("fallback to last", []string{"invalid", "last"}, "last", false),
		Entry("empty lines error", []string{"", " "}, "", true),
	)

	DescribeTable("getPreservedVersion",
		func(pkg, current, expected string) { Expect(getPreservedVersion(pkg, current)).To(Equal(expected)) },
		Entry("rust", "rust", "1.70.0", "nightly"),
		Entry("debian", "debian", "trixie-slim", "trixie-slim"),
		Entry("other", "golang", "1.25.4", ""),
	)

	It("writeToolVersions writes sorted, skips empty", func() {
		testPath := filepath.Join(GinkgoT().TempDir(), ".tool-versions")
		Expect(writeToolVersions(testPath, map[string]string{"b": "2", "a": "1", "c": ""})).To(Succeed())
		data, err := os.ReadFile(testPath)
		Expect(err).NotTo(HaveOccurred())
		Expect(string(data)).To(Equal("a 1\nb 2\n"))
	})

	It("getLatestAsdfVersion parses output and handles errors", func() {
		commandExecutor = func(_ string, _ ...string) ([]byte, error) { return []byte("1.0.0\n2.0.0\n"), nil }
		version, err := getLatestAsdfVersion("golang")
		Expect(err).NotTo(HaveOccurred())
		Expect(version).To(Equal("2.0.0"))

		commandExecutor = func(_ string, _ ...string) ([]byte, error) { return nil, errTestFail }
		_, err = getLatestAsdfVersion("missing")
		Expect(err).To(HaveOccurred())
	})

	It("UpdateToolsToLatestForFile handles all cases", func() {
		tmpDir := GinkgoT().TempDir()
		testPath := filepath.Join(tmpDir, ".tool-versions")
		GinkgoT().Setenv("ASDF_DATA_DIR", tmpDir)
		toolInstaller = func(_, _ string) error { return nil }

		// Success
		commandExecutor = func(_ string, args ...string) ([]byte, error) {
			if len(args) >= 3 && args[2] == "golang" {
				return []byte("1.20.0\n1.25.0\n"), nil
			}

			return nil, errTestUnknown
		}
		Expect(os.WriteFile(testPath, []byte("golang 1.20.0\n"), 0o600)).To(Succeed())
		results, err := UpdateToolsToLatestForFile(testPath)
		Expect(err).NotTo(HaveOccurred())
		Expect(results[0].NewVersion).To(Equal("1.25.0"))
		Expect(results[0].Installed).To(BeTrue())

		// Preserved version
		Expect(os.WriteFile(testPath, []byte("rust 1.70.0\n"), 0o600)).To(Succeed())
		results, err = UpdateToolsToLatestForFile(testPath)
		Expect(err).NotTo(HaveOccurred())
		Expect(results[0].NewVersion).To(Equal("nightly"))

		// Install error
		toolInstaller = func(_, _ string) error { return errTestFail }
		commandExecutor = func(_ string, _ ...string) ([]byte, error) { return []byte("18.0.0\n20.0.0\n"), nil }
		Expect(os.WriteFile(testPath, []byte("nodejs 18.0.0\n"), 0o600)).To(Succeed())
		_, err = UpdateToolsToLatestForFile(testPath)
		Expect(err).To(HaveOccurred())

		// Version fetch error
		commandExecutor = func(_ string, _ ...string) ([]byte, error) { return nil, errTestFail }
		Expect(os.WriteFile(testPath, []byte("missing 1.0.0\n"), 0o600)).To(Succeed())
		results, _ = UpdateToolsToLatestForFile(testPath)
		Expect(results[0].Changed).To(BeFalse())

		// Empty file
		Expect(os.WriteFile(testPath, []byte(""), 0o600)).To(Succeed())
		results, _ = UpdateToolsToLatestForFile(testPath)
		Expect(results).To(BeEmpty())

		// Already installed
		toolInstaller = func(_, _ string) error { return nil }
		commandExecutor = func(_ string, _ ...string) ([]byte, error) { return []byte("1.0.0\n2.0.0\n"), nil }
		Expect(os.WriteFile(testPath, []byte("preinstalled 1.0.0\n"), 0o600)).To(Succeed())
		Expect(os.MkdirAll(filepath.Join(tmpDir, "installs", "preinstalled", "2.0.0"), 0o755)).To(Succeed())
		results, _ = UpdateToolsToLatestForFile(testPath)
		Expect(results[0].Installed).To(BeFalse())
	})

	It("UpdateToolsToLatest uses root file", func() {
		tmpDir := GinkgoT().TempDir()
		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()
		Expect(os.Chdir(tmpDir)).To(Succeed())

		Expect(os.WriteFile(toolVersionsFile, []byte(""), 0o600)).To(Succeed())
		results, err := UpdateToolsToLatest()
		Expect(err).NotTo(HaveOccurred())
		Expect(results).To(BeEmpty())

		commandExecutor = func(_ string, _ ...string) ([]byte, error) { return nil, errTestFail }
		Expect(os.WriteFile(toolVersionsFile, []byte("golang 1.20.0\n"), 0o600)).To(Succeed())
		_, err = UpdateToolsToLatest()
		Expect(err).To(HaveOccurred())
	})
})
