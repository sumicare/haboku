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

package crds

import (
	"context"
	"fmt"
	"os"
	"path/filepath"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("Downloader", func() {
	var (
		tempDir    string
		downloader *Downloader
		ctx        context.Context
	)

	BeforeEach(func() {
		var err error
		tempDir, err = os.MkdirTemp("", "crds-test-*")
		Expect(err).NotTo(HaveOccurred(), "failed to create temp dir")

		downloader = NewDownloader()
		ctx = context.Background()
	})

	AfterEach(func() {
		if tempDir != "" {
			os.RemoveAll(tempDir)
		}
	})

	Describe("cleanupExistingFiles", func() {
		It("should remove YAML files and crds.tf", func() {
			// Create test directory structure
			targetDir := filepath.Join(tempDir, "test-crds")
			err := os.MkdirAll(targetDir, DirectoryPermissions)
			Expect(err).NotTo(HaveOccurred(), "failed to create test directory")

			// Create some test files
			testFiles := []string{
				filepath.Join(targetDir, "test1.yaml"),
				filepath.Join(targetDir, "test2.yaml"),
				filepath.Join(targetDir, "crds.tf"),
				filepath.Join(targetDir, "should-not-delete.txt"),
			}

			for _, file := range testFiles {
				err := os.WriteFile(file, []byte("test content"), FilePermission)
				Expect(err).NotTo(HaveOccurred(), "failed to create test file "+file)
			}

			// Create test sources
			sources := []Source{
				{
					Name:      "test",
					TargetDir: targetDir,
				},
			}

			// Run cleanup
			err = downloader.cleanupExistingFiles(sources)
			Expect(err).NotTo(HaveOccurred(), "cleanupExistingFiles should not return an error")

			// Check that YAML files and crds.tf are gone
			for _, file := range testFiles[:3] { // First three files should be deleted
				_, err := os.Stat(file)
				Expect(os.IsNotExist(err)).To(BeTrue(), fmt.Sprintf("file %s should be deleted", file))
			}

			// Check that non-YAML file is still there
			_, err = os.Stat(testFiles[3])
			Expect(err).NotTo(HaveOccurred(), "non-YAML file should not be deleted")
		})

		It("should handle non-existent directories", func() {
			// Create test sources with non-existent directory
			sources := []Source{
				{
					Name:      "test",
					TargetDir: filepath.Join(tempDir, "non-existent"),
				},
			}

			// Run cleanup
			err := downloader.cleanupExistingFiles(sources)
			Expect(err).NotTo(HaveOccurred(), "cleanupExistingFiles should not return an error for non-existent directories")
		})
	})

	Describe("NewDownloader", func() {
		It("should create a new downloader", func() {
			d := NewDownloader()
			Expect(d).NotTo(BeNil(), "NewDownloader should return a non-nil downloader")
			Expect(d.helm).NotTo(BeNil(), "helm downloader should be initialized")
			Expect(d.github).NotTo(BeNil(), "github downloader should be initialized")
			Expect(d.url).NotTo(BeNil(), "url downloader should be initialized")
		})
	})

	Describe("DownloadSource", func() {
		It("should return error for source with no configuration", func() {
			source := &Source{
				Name:      "test",
				TargetDir: filepath.Join(tempDir, "test-crds"),
			}
			err := downloader.DownloadSource(ctx, source)
			Expect(err).To(HaveOccurred(), "DownloadSource should return an error for source with no configuration")
			Expect(err).To(Equal(ErrNoSourceConfigured), "error should be ErrNoSourceConfigured")
		})
	})
})
