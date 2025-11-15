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

// Test suite for asdf sync functionality.
// Tests cover parsing, syncing, and plugin management operations.

var _ = Describe("asdf sync", func() {
	// Test parseToolVersions function with various inputs.
	It("parseToolVersions parses content and handles edge cases", func() {
		testPath := filepath.Join(GinkgoT().TempDir(), ".tool-versions")
		err := os.WriteFile(testPath, []byte("# Comment\ngolang 1.25.4\nmalformed\nnodejs 25.2.0\n"), 0o600)
		Expect(err).NotTo(HaveOccurred())

		versions, _ := parseToolVersions(testPath)
		Expect(versions).To(HaveLen(2))
		Expect(versions["golang"]).To(Equal("1.25.4"))

		v2, _ := parseToolVersions("/nonexistent")
		Expect(v2).To(BeEmpty())
	})

	It("GetAsdfVersions and GetAsdfVersionsForFile read versions", func() {
		tmpDir := GinkgoT().TempDir()
		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()
		Expect(os.Chdir(tmpDir)).To(Succeed())

		Expect(os.WriteFile(toolVersionsFile, []byte("golang 1.25.4\n"), 0o600)).To(Succeed())
		Expect(GetAsdfVersions()).To(HaveKeyWithValue("golang", "1.25.4"))

		customPath := filepath.Join(tmpDir, "custom")
		Expect(os.WriteFile(customPath, []byte("nodejs 20.0.0\n"), 0o600)).To(Succeed())
		Expect(GetAsdfVersionsForFile(customPath)).To(HaveKeyWithValue("nodejs", "20.0.0"))
		Expect(GetAsdfVersionsForFile("/nonexistent")).To(BeEmpty())
	})

	It("GetVersions returns version or error", func() {
		tmpDir := GinkgoT().TempDir()
		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()
		Expect(os.Chdir(tmpDir)).To(Succeed())

		Expect(os.WriteFile(toolVersionsFile, []byte("golang 1.25.4\n"), 0o600)).To(Succeed())
		versions, err := GetVersions("golang")
		Expect(err).NotTo(HaveOccurred())
		Expect(versions).To(Equal([]string{"1.25.4"}))
		_, err = GetVersions("missing")
		Expect(err).To(HaveOccurred())
	})

	It("InstallPlugins and InstallPluginsForFile check plugins", func() {
		tmpDir := GinkgoT().TempDir()
		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()
		Expect(os.Chdir(tmpDir)).To(Succeed())

		asdfDir := filepath.Join(tmpDir, "asdf")
		GinkgoT().Setenv("ASDF_DATA_DIR", asdfDir)

		Expect(os.WriteFile(toolVersionsFile, []byte("golang 1.25.4\n"), 0o600)).To(Succeed())
		Expect(errors.Is(InstallPlugins(), ErrPluginNotFound)).To(BeTrue())

		Expect(os.MkdirAll(filepath.Join(asdfDir, "plugins", "golang"), 0o755)).To(Succeed())
		Expect(InstallPlugins()).To(Succeed())

		Expect(os.WriteFile(toolVersionsFile, []byte(""), 0o600)).To(Succeed())
		Expect(InstallPluginsForFile(toolVersionsFile)).To(Succeed())
	})

	It("SyncToolVersionsFiles syncs versions", func() {
		tmpDir := GinkgoT().TempDir()
		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()
		Expect(os.Chdir(tmpDir)).To(Succeed())

		Expect(os.WriteFile(toolVersionsFile, []byte("golang 1.25.4\n"), 0o600)).To(Succeed())
		target := filepath.Join(tmpDir, "target")
		Expect(os.WriteFile(target, []byte("# comment\ngolang 1.20.0\nmalformed\n"), 0o600)).To(Succeed())

		Expect(SyncToolVersionsFiles(target)).To(Succeed())
		data, err := os.ReadFile(target)
		Expect(err).NotTo(HaveOccurred())
		Expect(string(data)).To(ContainSubstring("golang 1.25.4"))

		Expect(SyncToolVersionsFiles()).To(Succeed())
		Expect(os.WriteFile(toolVersionsFile, []byte(""), 0o600)).To(Succeed())
		Expect(SyncToolVersionsFiles(target)).To(Succeed())
		Expect(SyncToolVersionsFiles("/nonexistent")).To(Succeed())
	})

	It("copyDir and copyFile handle files", func() {
		tmpDir := GinkgoT().TempDir()
		src := filepath.Join(tmpDir, "src")
		dst := filepath.Join(tmpDir, "dst")

		Expect(os.MkdirAll(filepath.Join(src, "sub"), 0o755)).To(Succeed())
		Expect(os.WriteFile(filepath.Join(src, "f.txt"), []byte("x"), 0o600)).To(Succeed())
		Expect(os.WriteFile(filepath.Join(src, "sub", "g.txt"), []byte("y"), 0o600)).To(Succeed())

		Expect(copyDir(src, dst)).To(Succeed())
		Expect(filepath.Join(dst, "sub", "g.txt")).To(BeAnExistingFile())

		fileNotDir := filepath.Join(tmpDir, "file")
		Expect(os.WriteFile(fileNotDir, []byte("x"), 0o600)).To(Succeed())
		Expect(copyDir(fileNotDir, filepath.Join(tmpDir, "d"))).ToNot(Succeed())
		Expect(copyDir("/nonexistent", filepath.Join(tmpDir, "d"))).ToNot(Succeed())

		copyFile(filepath.Join(src, "f.txt"), filepath.Join(tmpDir, "copy"))
		data, err := os.ReadFile(filepath.Join(tmpDir, "copy"))
		Expect(err).NotTo(HaveOccurred())
		Expect(string(data)).To(Equal("x"))
		copyFile("/nonexistent", filepath.Join(tmpDir, "x")) // no error
	})

	It("getAsdfDataDir respects env or defaults", func() {
		GinkgoT().Setenv("ASDF_DATA_DIR", "/custom")
		Expect(getAsdfDataDir()).To(Equal("/custom"))

		Expect(os.Unsetenv("ASDF_DATA_DIR")).To(Succeed())
		home, err := os.UserHomeDir()
		Expect(err).NotTo(HaveOccurred())
		Expect(getAsdfDataDir()).To(Equal(filepath.Join(home, ".asdf")))
	})
})
