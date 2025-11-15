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

// Package asdf provides utilities for managing asdf tool versions.
//
// # Overview
//
// This package integrates with the asdf version manager to:
//   - Parse and write .tool-versions files
//   - Install missing asdf plugins
//   - Update tools to their latest versions
//   - Synchronize versions across multiple .tool-versions files
//
// # Usage
//
// Basic usage to update all tools to latest versions:
//
//	results, err := asdf.UpdateToolsToLatest()
//	for _, r := range results {
//	    if r.Changed {
//	        fmt.Printf("%s: %s -> %s\n", r.Name, r.OldVersion, r.NewVersion)
//	    }
//	}
//
// # Environment Variables
//
// The package respects the following environment variables:
//   - ASDF_DATA_DIR: Custom asdf data directory (default: ~/.asdf)
//   - GITHUB_TOKEN: Used as GITHUB_API_TOKEN for plugin installations
package asdf
