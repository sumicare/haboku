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

package versions

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

// EnsureCorrectDirectory locates and changes to the repository root directory.
// It walks up the directory tree from the current working directory until it finds
// a package.json with name matching [ExpectedPackageName].
//
// This ensures CLI commands work correctly regardless of where they're invoked from
// within the repository.
//
// Returns [ErrRepositoryRootNotFound] if no matching package.json is found.
func EnsureCorrectDirectory() error {
	startDir, err := os.Getwd()
	if err != nil {
		return fmt.Errorf("get working directory: %w", err)
	}

	currentDir, previousDir := startDir, ""

	for currentDir != "/" && currentDir != previousDir {
		data, err := os.ReadFile(filepath.Join(currentDir, RootPackageJSONPath))
		if err == nil {
			var pkg PackageJSON
			if json.Unmarshal(data, &pkg) == nil && pkg.Name == ExpectedPackageName { //nolint:revive // must unmarshal first
				if currentDir != startDir {
					err := os.Chdir(currentDir)
					if err != nil {
						return fmt.Errorf("chdir to %s: %w", currentDir, err)
					}

					return nil
				}

				return nil
			}
		}

		previousDir, currentDir = currentDir, filepath.Dir(currentDir)
	}

	return fmt.Errorf("%w: searched from %q to root", ErrRepositoryRootNotFound, startDir)
}
