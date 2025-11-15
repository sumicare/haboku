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
	"os"
	"path/filepath"
	"testing"

	"github.com/sebdah/goldie/v2"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"sumi.care/util/sumicare-versioning/pkg/versions"
)

var _ = Describe("Versions Sync", func() {
	DescribeTable("SoftwareVersionKey",
		func(pkg, expected string) { Expect(versions.SoftwareVersionKey(pkg)).To(Equal(expected)) },
		Entry("simple", "compute-keda", "keda"),
		Entry("operator", "observability-grafana-operator", "grafanaOperator"),
		Entry("no prefix", "debian", "debian"),
		Entry("multi-hyphen", "security-bank-vaults-operator", "bankVaultsOperator"),
	)

	It("ReadVersionsFile handles all cases", func() {
		tmpDir := GinkgoT().TempDir()
		origDir, err := os.Getwd()
		Expect(err).NotTo(HaveOccurred())
		defer func() { _ = os.Chdir(origDir) }()
		Expect(os.Chdir(tmpDir)).To(Succeed())

		vf, err := versions.ReadVersionsFile()
		Expect(err).NotTo(HaveOccurred())
		Expect(vf).To(BeEmpty())

		data, err := json.Marshal(versions.VersionsFile{"test": "1.0.0"})
		Expect(err).NotTo(HaveOccurred())
		Expect(os.WriteFile(versions.VersionsFileName, data, 0o600)).To(Succeed())
		vf, err = versions.ReadVersionsFile()
		Expect(err).NotTo(HaveOccurred())
		Expect(vf["test"]).To(Equal("1.0.0"))

		Expect(os.WriteFile(versions.VersionsFileName, []byte("invalid"), 0o600)).To(Succeed())
		_, err = versions.ReadVersionsFile()
		Expect(err).To(HaveOccurred())
	})

	It("UpdatePackageJSONFiles handles all cases", func() {
		tmpDir := GinkgoT().TempDir()

		// Setup packages
		for _, pkgName := range []string{"compute-keda", "storage-cnpg"} {
			Expect(os.MkdirAll(filepath.Join(tmpDir, pkgName), 0o755)).To(Succeed())
			data, err := json.Marshal(map[string]any{"name": pkgName})
			Expect(err).NotTo(HaveOccurred())
			Expect(os.WriteFile(filepath.Join(tmpDir, pkgName, "package.json"), data, 0o600)).To(Succeed())
		}

		vf := versions.VersionsFile{"compute-keda": "2.11.0", "storage-cnpg": "1.25.0", "storage-postgres": "18.1"}
		updated, err := versions.UpdatePackageJSONFiles(vf, tmpDir)
		Expect(err).NotTo(HaveOccurred())
		Expect(updated["compute-keda"].Changed).To(BeTrue())
		Expect(updated["storage-postgres"].Changed).To(BeTrue())

		// Malformed JSON
		Expect(os.WriteFile(filepath.Join(tmpDir, "compute-keda", "package.json"), []byte("invalid"), 0o600)).To(Succeed())
		updated, _ = versions.UpdatePackageJSONFiles(versions.VersionsFile{"compute-keda": "2.0.0"}, tmpDir)
		Expect(updated).To(BeEmpty())

		// Non-string version
		data, err := json.Marshal(map[string]any{"versions": map[string]any{"keda": 123}})
		Expect(err).NotTo(HaveOccurred())
		Expect(os.WriteFile(filepath.Join(tmpDir, "compute-keda", "package.json"), data, 0o600)).To(Succeed())
		updated, _ = versions.UpdatePackageJSONFiles(versions.VersionsFile{"compute-keda": "2.0.0"}, tmpDir)
		Expect(updated).To(BeEmpty())

		// Unchanged
		data, err = json.Marshal(map[string]any{"versions": map[string]any{"keda": "2.0.0"}})
		Expect(err).NotTo(HaveOccurred())
		Expect(os.WriteFile(filepath.Join(tmpDir, "compute-keda", "package.json"), data, 0o600)).To(Succeed())
		updated, _ = versions.UpdatePackageJSONFiles(versions.VersionsFile{"compute-keda": "2.0.0"}, tmpDir)
		Expect(updated["compute-keda"].Changed).To(BeFalse())

		// Missing dir
		_, err = versions.UpdatePackageJSONFiles(versions.VersionsFile{}, "/nonexistent")
		Expect(err).To(HaveOccurred())
	})
})

// TestPackageJSONOutput tests the package.json output format using golden files.
func TestPackageJSONOutput(t *testing.T) {
	golden := goldie.New(t, goldie.WithFixtureDir("testdata"))
	tmpDir := t.TempDir()
	pkgDir := filepath.Join(tmpDir, "storage-cnpg")

	if err := os.MkdirAll(pkgDir, versions.DirectoryPermissions); err != nil {
		t.Fatalf("failed to create pkg dir: %v", err)
	}

	data, err := json.Marshal(map[string]any{"name": "@test/cnpg", "version": "1.0.0"})
	if err != nil {
		t.Fatalf("failed to marshal json: %v", err)
	}

	if err := os.WriteFile(filepath.Join(pkgDir, "package.json"), data, versions.FilePermissions); err != nil {
		t.Fatalf("failed to write package.json: %v", err)
	}

	vf := versions.VersionsFile{
		"storage-cnpg": "1.27.1", "storage-postgres": "17_2",
		"storage-postgres-pgvector": "0.8.0", "storage-postgres-pgaudit": "18.0.0",
	}

	if _, err := versions.UpdatePackageJSONFiles(vf, tmpDir); err != nil {
		t.Fatalf("failed to update package.json files: %v", err)
	}

	content, err := os.ReadFile(filepath.Join(pkgDir, "package.json"))
	if err != nil {
		t.Fatalf("failed to read package.json: %v", err)
	}

	golden.Assert(t, "package_json_versions", content)
}
