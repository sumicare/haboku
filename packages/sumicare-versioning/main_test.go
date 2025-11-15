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

package main

import (
	"os"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"sumi.care/util/sumicare-versioning/pkg/versions"
)

// TestMain is the entry point for the test suite.
func TestMain(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Main Suite")
}

// withTempDir creates a temp directory, changes to it, and returns a cleanup function.
func withTempDir() func() {
	origDir, err := os.Getwd()
	Expect(err).NotTo(HaveOccurred())
	Expect(os.Chdir(GinkgoT().TempDir())).To(Succeed())

	return func() {
		Expect(os.Chdir(origDir)).To(Succeed())
	}
}

var _ = Describe("Main", func() {
	Describe("getEnv", func() {
		It("returns fallback when unset, value when set, empty when empty", func() {
			Expect(getEnv("TEST_UNSET_VAR_12345", "default")).To(Equal("default"))

			os.Setenv("TEST_SET_VAR", "custom")
			defer os.Unsetenv("TEST_SET_VAR")
			Expect(getEnv("TEST_SET_VAR", "default")).To(Equal("custom"))

			os.Setenv("TEST_EMPTY_VAR", "")
			defer os.Unsetenv("TEST_EMPTY_VAR")
			Expect(getEnv("TEST_EMPTY_VAR", "default")).To(Equal(""))
		})
	})

	Describe("printVersionsJSONSummary", func() {
		It("handles various inputs", func() {
			printVersionsJSONSummary(make(map[string]versions.VersionChange))
			printVersionsJSONSummary(map[string]versions.VersionChange{"pkg1": {Changed: false}})
			printVersionsJSONSummary(map[string]versions.VersionChange{"pkg1": {Changed: true}, "pkg2": {Changed: false}})
		})
	})

	Describe("printErrors and printUpdates", func() {
		It("handles empty and non-empty slices", func() {
			printErrors("Title:", nil)
			printErrors("Errors:", []string{"err1", "err2"})
			printUpdates("Title:", nil)
			printUpdates("Updates:", []string{"u1", "u2"})
		})
	})

	Describe("fetchAllVersions", func() {
		It("returns non-nil VersionsFile", func() {
			v, _ := fetchAllVersions()
			Expect(v).NotTo(BeNil())
		})
	})

	Describe("updateToolVersions", func() {
		It("returns empty updates for missing files", func() {
			defer withTempDir()()
			updates, _ := updateToolVersions()
			Expect(updates).To(BeEmpty())
		})
	})

	Describe("renderTemplates", func() {
		It("renders templates and skips node_modules", func() {
			defer withTempDir()()
			Expect(os.MkdirAll("packages/test-pkg", 0o755)).To(Succeed())
			Expect(os.MkdirAll("packages/node_modules", 0o755)).To(Succeed())

			// Valid template
			Expect(os.WriteFile("packages/test-pkg/test.txt.tpl", []byte(`v={{ .Versions.test }}`), 0o600)).To(Succeed())
			// Template in node_modules (should be skipped)
			Expect(os.WriteFile("packages/node_modules/skip.tpl", []byte("skip"), 0o600)).To(Succeed())

			Expect(renderTemplates(versions.VersionsFile{"test": "1.0.0"})).To(Succeed())
			Expect("packages/test-pkg/test.txt").To(BeAnExistingFile())
			Expect("packages/node_modules/skip").NotTo(BeAnExistingFile())
		})

		It("returns error for invalid template syntax", func() {
			defer withTempDir()()
			Expect(os.MkdirAll("packages/test-pkg", 0o755)).To(Succeed())
			Expect(os.WriteFile("packages/test-pkg/bad.tpl", []byte(`{{ .Invalid`), 0o600)).To(Succeed())
			Expect(renderTemplates(versions.VersionsFile{})).ToNot(Succeed())
		})

		It("uses ORG and REPO env vars", func() {
			defer withTempDir()()
			os.Setenv("ORG", "testorg")
			os.Setenv("REPO", "testrepo/")
			defer os.Unsetenv("ORG")
			defer os.Unsetenv("REPO")

			Expect(os.MkdirAll("packages/test-pkg", 0o755)).To(Succeed())
			Expect(os.WriteFile("packages/test-pkg/env.tpl", []byte(`org={{ .Org }} repo={{ .Repository }}`), 0o600)).To(Succeed())

			Expect(renderTemplates(versions.VersionsFile{})).To(Succeed())
			data, err := os.ReadFile("packages/test-pkg/env")
			Expect(err).NotTo(HaveOccurred())
			Expect(string(data)).To(And(ContainSubstring("testorg"), ContainSubstring("testrepo/")))
		})
	})

	Describe("downloadCRDs", func() {
		It("succeeds with empty or missing packages dir", func() {
			defer withTempDir()()
			Expect(downloadCRDs()).To(Succeed())

			Expect(os.MkdirAll("packages", 0o755)).To(Succeed())
			Expect(downloadCRDs()).To(Succeed())
		})
	})

	Describe("syncVersions", func() {
		It("syncs package.json and renders templates", func() {
			defer withTempDir()()
			Expect(os.MkdirAll("packages/compute-keda", 0o755)).To(Succeed())
			Expect(os.WriteFile("versions.json", []byte(`{"compute-keda": "2.11.0"}`), 0o600)).To(Succeed())
			Expect(os.WriteFile("packages/compute-keda/package.json", []byte(`{"name": "compute-keda", "version": "1.0.0", "versions": {}}`), 0o600)).To(Succeed())

			// Add a template
			Expect(os.WriteFile("packages/compute-keda/config.tpl", []byte(`v={{ index .Versions "compute-keda" }}`), 0o600)).To(Succeed())

			Expect(syncVersions()).To(Succeed())

			data, err := os.ReadFile("packages/compute-keda/package.json")
			Expect(err).NotTo(HaveOccurred())
			Expect(string(data)).To(ContainSubstring("2.11.0"))

			tplData, err := os.ReadFile("packages/compute-keda/config")
			Expect(err).NotTo(HaveOccurred())
			Expect(string(tplData)).To(ContainSubstring("2.11.0"))
		})
	})

	Describe("updateVersions", func() {
		It("creates and updates versions.json", func() {
			defer withTempDir()()
			Expect(os.MkdirAll("packages/compute-keda", 0o755)).To(Succeed())
			Expect(os.WriteFile("packages/compute-keda/package.json", []byte(`{"name": "compute-keda", "version": "1.0.0", "versions": {}}`), 0o600)).To(Succeed())

			err := updateVersions()
			Expect(err).NotTo(HaveOccurred())
			Expect("versions.json").To(BeAnExistingFile())

			data, err := os.ReadFile("versions.json")
			Expect(err).NotTo(HaveOccurred())
			Expect(data).ToNot(BeEmpty())
		})
	})
})
