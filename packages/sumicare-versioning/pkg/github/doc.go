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

// Package github provides a client for interacting with the GitHub REST API.
//
// # Overview
//
// This package provides functionality to:
//   - Fetch repository tags and releases
//   - Parse GitHub repository URLs
//   - Handle pagination for large result sets
//
// # Authentication
//
// The client supports authentication via the GITHUB_TOKEN environment variable.
// Authenticated requests have higher rate limits (5000/hour vs 60/hour).
//
// # Usage
//
// Basic usage to fetch tags from a repository:
//
//	client := github.NewClient()
//	tags, err := client.GetTags("https://github.com/owner/repo", token, nil)
package github
