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

// Package main provides the sumicare-versioning CLI tool for managing version
// information across packages in the terraform-kubernetes-modules monorepo.
//
// # Commands
//
// The tool supports the following commands:
//
//	update - Fetch latest versions from upstream sources and update versions.json
//	         and package.json files
//	sync   - Synchronize package.json files from the existing versions.json
//	crds   - Download CRDs for all configured packages
//
// # Usage
//
// Run from the repository root directory:
//
//	go run . update    # Fetch and update all versions
//	go run . sync      # Sync versions to package.json files
//	go run . crds      # Download CRDs
//
// # Environment Variables
//
//   - GITHUB_TOKEN: GitHub personal access token for API authentication
//   - ORG: Organization name for template rendering (default: "sumicare")
//   - REPO: Docker repository prefix for template rendering (default: "docker.io/")
package main

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"sync"

	"sumi.care/util/sumicare-versioning/pkg/asdf"
	"sumi.care/util/sumicare-versioning/pkg/crds"
	"sumi.care/util/sumicare-versioning/pkg/templating"
	"sumi.care/util/sumicare-versioning/pkg/versions"
)

const (
	// packagesDir is the directory containing package subdirectories.
	packagesDir = "packages"
	// debianToolVersionsPath is the .tool-versions file for Debian images.
	debianToolVersionsPath = "packages/debian/modules/debian-images/.tool-versions"
)

// main is the CLI entry point.
func main() {
	if err := versions.EnsureCorrectDirectory(); err != nil {
		fatalf("Error: %v\nPlease run from the repository root directory.", err)
	}

	if len(os.Args) < 2 {
		fmt.Println("Usage: sumicare-versioning <command>\nCommands:\n  update - Fetch and update versions\n  sync   - Sync package.json files\n  crds   - Download CRDs")
		os.Exit(1)
	}

	var err error
	switch os.Args[1] {
	case "update":
		err = updateVersions()
	case "sync":
		err = syncVersions()
	case "crds":
		err = downloadCRDs()
	default:
		fatalf("Unknown command: %s", os.Args[1])
	}

	if err != nil {
		fatalf("Error: %v", err)
	}
}

// fatalf prints an error message and exits.
func fatalf(format string, args ...any) {
	fmt.Fprintf(os.Stderr, format+"\n", args...)
	os.Exit(1) //nolint:revive // intentional exit in main package
}

// printVersionsJSONSummary prints a summary of version synchronization results,
// showing how many packages were actually updated.
func printVersionsJSONSummary(updated map[string]versions.VersionChange) {
	actuallyUpdated := 0

	for i := range updated {
		if updated[i].Changed {
			actuallyUpdated++
		}
	}

	fmt.Println("\nsynchronized package.json versions")

	if actuallyUpdated > 0 {
		fmt.Printf("  ✓ %d packages updated\n", actuallyUpdated)
	}
}

// updateVersions fetches latest versions and updates versions.json and package.json files.
func updateVersions() error {
	toolUpdates, toolErrors := updateToolVersions()
	v, versionErrors := fetchAllVersions()

	if err := versions.UpdateVersionsJSON(v); err != nil {
		return fmt.Errorf("update versions.json: %w", err)
	}

	updated, err := versions.UpdatePackageJSONFiles(v, packagesDir)
	if err != nil {
		return fmt.Errorf("update package.json files: %w", err)
	}

	printErrors(".tool-versions errors:", toolErrors)
	printUpdates(".tool-versions updates:", toolUpdates)
	printErrors("versions.json errors:", versionErrors)
	printVersionsJSONSummary(updated)

	return nil
}

// updateToolVersions updates .tool-versions files and returns updates and errors.
func updateToolVersions() ([]string, []string) {
	updates := make([]string, 0, 2) //nolint:mnd // 2 tool-versions files

	var errs []string

	cfgs := []struct{ Path, Label string }{
		{".tool-versions", ""},
		{debianToolVersionsPath, "debian-images"},
	}
	for i := range cfgs {
		cfg := &cfgs[i]
		if err := asdf.InstallPluginsForFile(cfg.Path); err != nil {
			errs = append(errs, fmt.Sprintf("%s: %v", cfg.Path, err))
		}

		results, err := asdf.UpdateToolsToLatestForFile(cfg.Path)
		if err != nil {
			errs = append(errs, fmt.Sprintf("%s: %v", cfg.Path, err))
			continue
		}

		var changed, installed int
		for j := range results {
			if results[j].Changed {
				changed++
			}

			if results[j].Installed {
				installed++
			}
		}

		if changed == 0 && installed == 0 {
			continue
		}

		label := cfg.Path
		if cfg.Label != "" {
			label = cfg.Label
		}

		var parts []string
		if changed > 0 {
			parts = append(parts, fmt.Sprintf("%d updated", changed))
		}

		if installed > 0 {
			parts = append(parts, fmt.Sprintf("%d installed", installed))
		}

		updates = append(updates, fmt.Sprintf("%s: %s", label, strings.Join(parts, ", ")))
	}

	return updates, errs
}

// fetchAllVersions fetches versions for all projects in parallel.
func fetchAllVersions() (versions.VersionsFile, []string) {
	result := make(versions.VersionsFile)

	var (
		errs []string
		mu   sync.Mutex
		wg   sync.WaitGroup
	)
	for name, fetch := range versions.GetProjectFetchers() {
		// capture loop variable
		// capture loop variable
		wg.Go(func() {
			vers, err := fetch(1)

			mu.Lock()
			defer mu.Unlock()

			switch {
			case err != nil:
				errs = append(errs, fmt.Sprintf("%s: %v", name, err))
			case len(vers) == 0:
				errs = append(errs, name+": no versions found")
			default:
				result[name] = vers[0]
			}
		})
	}

	wg.Wait()

	return result, errs
}

// printErrors prints a list of errors if non-empty.
func printErrors(title string, errs []string) {
	if len(errs) == 0 {
		return
	}

	fmt.Println("\n" + title)

	for _, e := range errs {
		fmt.Printf("  ⚠ %s\n", e)
	}
}

// printUpdates prints a list of updates if non-empty.
func printUpdates(title string, updates []string) {
	if len(updates) == 0 {
		return
	}

	fmt.Println("\n" + title)

	for _, u := range updates {
		fmt.Printf("  ✓ %s\n", u)
	}
}

// downloadCRDs downloads CRDs for all configured packages from their upstream sources.
func downloadCRDs() error {
	if err := crds.NewDownloader().DownloadAll(context.Background(), packagesDir); err != nil {
		return fmt.Errorf("failed to download CRDs: %w", err)
	}

	fmt.Println("✓ CRDs downloaded successfully")

	return nil
}

// getEnv retrieves an environment variable or returns a default value.
func getEnv(key, fallback string) string {
	if v, ok := os.LookupEnv(key); ok {
		return v
	}

	return fallback
}

// renderTemplates finds and renders all .tpl files in the packages directory.
func renderTemplates(vers versions.VersionsFile) error {
	data := templating.TemplateData{
		Org:        getEnv("ORG", "sumicare"),
		Repository: getEnv("REPO", "docker.io/"),
		Versions:   vers,
	}
	//nolint:wrapcheck // error context is clear from caller
	return filepath.Walk(packagesDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() && info.Name() == "node_modules" {
			return filepath.SkipDir
		}

		if info.IsDir() || !strings.HasSuffix(path, ".tpl") {
			return nil
		}

		if err := templating.RenderTemplateToFile(path, strings.TrimSuffix(path, ".tpl"), data); err != nil {
			return fmt.Errorf("render %s: %w", path, err)
		}

		return nil
	})
}

// syncVersions reads versions.json and synchronizes package.json files and templates.
func syncVersions() error {
	versionsFile, err := versions.ReadVersionsFile()
	if err != nil {
		return fmt.Errorf("read versions file: %w", err)
	}

	missing := versions.FetchMissingVersions(versionsFile)
	if len(missing) > 0 {
		if err := versions.UpdateVersionsJSON(versionsFile); err != nil {
			return fmt.Errorf("update versions.json: %w", err)
		}

		fmt.Printf("\nversions.json: Added %d missing projects\n", len(missing))
	}

	updated, err := versions.UpdatePackageJSONFiles(versionsFile, packagesDir)
	if err != nil {
		return fmt.Errorf("update package.json files: %w", err)
	}

	if err := renderTemplates(versionsFile); err != nil {
		return fmt.Errorf("render templates: %w", err)
	}

	printVersionsJSONSummary(updated)

	return nil
}
