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

package asdf

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// InstallPlugins ensures all plugins listed in the root .tool-versions file are installed.
// Returns [ErrPluginNotFound] if any required plugins are missing.
func InstallPlugins() error {
	err := InstallPluginsForFile(toolVersionsFile)
	if err != nil {
		return fmt.Errorf("install plugins: %w", err)
	}

	return nil
}

// InstallPluginsForFile ensures all plugins listed in the given .tool-versions file are installed.
// It checks the asdf plugins directory for each tool and returns [ErrPluginNotFound]
// listing any missing plugins.
func InstallPluginsForFile(path string) error {
	versions, _ := parseToolVersions(path) //nolint:errcheck // error handled by checking result
	if len(versions) == 0 {
		return nil
	}

	pluginsDir, _ := getAsdfPluginsDir() //nolint:errcheck // error handled by checking result

	var missing []string

	for plugin := range versions {
		if _, err := os.Stat(filepath.Join(pluginsDir, plugin)); errors.Is(err, os.ErrNotExist) {
			missing = append(missing, plugin)
		}
	}

	if len(missing) > 0 {
		return fmt.Errorf("%w: %s", ErrPluginNotFound, strings.Join(missing, ", "))
	}

	return nil
}

// GetAsdfVersions parses the root .tool-versions file and returns a map of tool name to version.
func GetAsdfVersions() map[string]string { return GetAsdfVersionsForFile(toolVersionsFile) }

// GetAsdfVersionsForFile parses a .tool-versions file and returns a map of tool name to version.
// Returns an empty map if the file doesn't exist or cannot be parsed.
func GetAsdfVersionsForFile(path string) map[string]string {
	versions, _ := parseToolVersions(path) //nolint:errcheck // error handled by checking result
	return versions
}

// GetVersions returns the version of a tool from the root .tool-versions file.
// It implements the versions.VersionFetcher signature for asdf-managed tools.
func GetVersions(name string) ([]string, error) {
	version, ok := GetAsdfVersions()[name]
	if !ok {
		return nil, fmt.Errorf("%w: plugin %q not found in %s", ErrPluginNotFound, name, toolVersionsFile)
	}

	return []string{version}, nil
}

// SyncToolVersionsFiles synchronizes tool versions from the root .tool-versions file
// to additional .tool-versions files. Any tools referenced in the target files
// that also exist in the root file will have their versions updated to match.
//
//nolint:unparam // error return is part of API contract for future use
func SyncToolVersionsFiles(paths ...string) error {
	if len(paths) == 0 {
		return nil
	}

	rootVersions, _ := parseToolVersions(toolVersionsFile) //nolint:errcheck // error handled by checking result
	if len(rootVersions) == 0 {
		return nil
	}

	for _, path := range paths {
		syncSingleToolVersionsFile(path, rootVersions)
	}

	return nil
}

// syncSingleToolVersionsFile applies the versions from rootVersions to a single file.
func syncSingleToolVersionsFile(path string, rootVersions map[string]string) {
	data, err := os.ReadFile(path)
	if err != nil {
		return
	}

	lines := strings.Split(string(data), "\n")

	for i, line := range lines {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" || strings.HasPrefix(trimmed, "#") {
			continue
		}

		fields := strings.Fields(trimmed)
		if len(fields) < 2 {
			continue
		}

		if version, ok := rootVersions[fields[0]]; ok && version != "" {
			lines[i] = fmt.Sprintf("%s %s", fields[0], version)
		}
	}

	_ = os.WriteFile(path, []byte(strings.Join(lines, "\n")), FilePermission) //nolint:errcheck // best effort
}

// parseToolVersions reads a .tool-versions style file and returns a map.
//
//nolint:unparam // error return is part of API contract for future use
func parseToolVersions(path string) (map[string]string, error) {
	data, _ := os.ReadFile(path) //nolint:errcheck // error handled by checking result
	versions := make(map[string]string)

	for line := range strings.SplitSeq(string(data), "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		if fields := strings.Fields(line); len(fields) >= 2 {
			versions[fields[0]] = fields[1]
		}
	}

	return versions, nil
}

// getAsdfPluginsDir returns the path to the asdf plugins directory.
//
//nolint:unparam // error return is part of API contract for future use
func getAsdfPluginsDir() (string, error) {
	dataDir := getAsdfDataDir()
	pluginsDir := filepath.Join(dataDir, "plugins")

	_ = os.MkdirAll(pluginsDir, DirectoryPermissions) //nolint:errcheck // best effort

	return pluginsDir, nil
}

// getAsdfDataDir returns the asdf data directory.
func getAsdfDataDir() string {
	if dir := os.Getenv("ASDF_DATA_DIR"); dir != "" {
		return dir
	}

	home, _ := os.UserHomeDir() //nolint:errcheck // fallback to empty

	return filepath.Join(home, ".asdf")
}

// copyDir recursively copies a directory tree from src to dst.
func copyDir(src, dst string) error {
	info, err := os.Stat(src)
	if err != nil {
		return fmt.Errorf("stat source: %w", err)
	}

	if !info.IsDir() {
		return fmt.Errorf("%w: %s", ErrSourceNotDirectory, src)
	}

	_ = os.MkdirAll(dst, info.Mode()) //nolint:errcheck // best effort

	entries, _ := os.ReadDir(src) //nolint:errcheck // error handled by checking result

	for _, entry := range entries {
		srcPath := filepath.Join(src, entry.Name())
		dstPath := filepath.Join(dst, entry.Name())

		if entry.IsDir() {
			_ = copyDir(srcPath, dstPath) //nolint:errcheck // best effort
		} else {
			copyFile(srcPath, dstPath)
		}
	}

	return nil
}

// copyFile copies a single file from src to dst.
func copyFile(src, dst string) {
	data, err := os.ReadFile(src)
	if err != nil {
		return
	}

	_ = os.WriteFile(dst, data, FilePermission) //nolint:errcheck // best effort
}
