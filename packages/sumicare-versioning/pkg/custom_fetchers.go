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

package pkg

import (
	"errors"
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"

	"sumi.care/util/sumicare-versioning/pkg/dockerhub"
)

const (
	// fetchMultiplier is the multiplier for fetching extra tags to ensure enough results after filtering.
	fetchMultiplier = 10
	// currentDebianRelease is the current stable Debian release name.
	currentDebianRelease = "trixie"

	// defaultFetchLimit is the default number of tags/releases to fetch.
	defaultFetchLimit = 200

	// postgresRepo is the PostgreSQL repository URL.
	postgresRepo = "https://github.com/postgres/postgres.git"
	// postgresPrefix is the tag prefix used by PostgreSQL releases.
	postgresPrefix = "REL_"
	// postgresFetchLimit is how many tags to fetch to account for filtering.
	postgresFetchLimit = 1000

	// rustfsRepo is the RustFS repository URL.
	rustfsRepo = "https://github.com/rustfs/rustfs.git"

	// semverPartCount is the number of parts in a semver version (major, minor, patch).
	semverPartCount = 3
)

var (
	// ErrNoDebianTagsFound is returned when no matching Debian tags are found.
	ErrNoDebianTagsFound = errors.New("no matching debian tags found")

	// postgresVersionPattern matches PostgreSQL version format after transformation: X.Y or X.Y.Z.
	postgresVersionPattern = regexp.MustCompile(`^\d+\.\d+(\.\d+)?$`)
)

// GetDebianVersion fetches the latest Debian slim image tags from Docker Hub.
// Filters for tags matching the pattern: {releasename}-{currentyear}****-slim
// Versions are sorted in descending order.
//
// Parameters:
//   - limit: number of versions to fetch (default: 5)
//
// Returns list of Debian slim tag names (e.g., "trixie-20251117-slim"), or error.
func GetDebianVersion(limit int) ([]string, error) {
	currentYear := time.Now().Year()
	yearPrefix := strconv.Itoa(currentYear)

	// Filter for tags matching {releasename}-{currentyear}****-slim pattern
	releaseFilter := func(tag string) bool {
		pattern := fmt.Sprintf("%s-%s", currentDebianRelease, yearPrefix)
		return strings.HasPrefix(tag, pattern) && strings.HasSuffix(tag, "-slim")
	}

	// Fetch many more tags to ensure we have enough after filtering
	tags, err := dockerhub.FetchImageTags("debian", releaseFilter, limit*fetchMultiplier*5)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch debian tags: %w", err)
	}

	if len(tags) == 0 {
		return nil, fmt.Errorf("%w: %s-%s*-slim", ErrNoDebianTagsFound, currentDebianRelease, yearPrefix)
	}

	// Sort tags in descending order (most recent first)
	// Tags are in format: trixie-20251117-slim, trixie-20251116-slim, etc.
	sort.Slice(tags, func(i, j int) bool {
		return tags[i] > tags[j]
	})

	// Return up to limit tags
	if len(tags) > limit {
		tags = tags[:limit]
	}

	return tags, nil
}

// GetPostgresVersion fetches the latest PostgreSQL versions from GitHub.
// PostgreSQL uses "REL_" prefix with underscore-separated versioning (REL_X_Y or REL_X_Y_Z).
// Returns versions in non-semver format (e.g., "18.1" instead of "18.1.0").
//
// Parameters:
//   - limit: number of versions to fetch (default: 5)
//
// Returns list of version strings without prefix and with dots instead of underscores, or error.
func GetPostgresVersion(limit int) ([]string, error) {
	effectiveLimit := limit
	if effectiveLimit <= 0 {
		effectiveLimit = DefaultVersionLimit
	}

	client := githubClientFactory()
	fetchLimit := postgresFetchLimit

	tags, err := client.GetTags(postgresRepo, "", &fetchLimit)
	if err != nil {
		return nil, fmt.Errorf("error fetching PostgreSQL tags: %w", err)
	}

	// Filter and parse PostgreSQL versions
	validVersions := make([]string, 0, fetchLimit)
	for _, tag := range tags {
		// Skip tags that don't start with REL_
		if !strings.HasPrefix(tag, postgresPrefix) {
			continue
		}

		// Remove REL_ prefix
		versionStr := strings.TrimPrefix(tag, postgresPrefix)

		// Transform underscores to dots (e.g., "18_1" -> "18.1")
		versionStr = strings.ReplaceAll(versionStr, "_", ".")

		// Check if it matches the version pattern (X.Y or X.Y.Z)
		// This filters out beta/RC versions like "18.0.BETA1"
		if !postgresVersionPattern.MatchString(versionStr) {
			continue
		}

		// Skip prerelease versions (those with more than 2 dots or non-numeric parts)
		parts := strings.Split(versionStr, ".")

		const maxVersionParts = 3
		if len(parts) > maxVersionParts {
			continue
		}

		// Verify all parts are numeric
		allNumeric := true
		for _, part := range parts {
			if _, err := strconv.Atoi(part); err != nil {
				allNumeric = false
				break
			}
		}

		if !allNumeric {
			continue
		}

		validVersions = append(validVersions, versionStr)
	}

	// Sort versions in descending order
	// We need custom sorting for version numbers
	sort.Slice(validVersions, func(i, j int) bool {
		return compareVersions(validVersions[i], validVersions[j]) > 0
	})

	// Apply limit
	if len(validVersions) > effectiveLimit {
		return validVersions[:effectiveLimit], nil
	}

	return validVersions, nil
}

// GetRustFSVersion fetches the latest RustFS versions from GitHub releases.
// RustFS uses semver with pre-release tags (e.g., "1.0.0-alpha.71").
// Returns versions sorted by semver descending (newest first), including pre-releases.
//
// Parameters:
//   - limit: number of versions to fetch (default: 5)
//
// Returns list of version strings, or error.
func GetRustFSVersion(limit int) ([]string, error) {
	effectiveLimit := limit
	if effectiveLimit <= 0 {
		effectiveLimit = DefaultVersionLimit
	}

	client := githubClientFactory()
	fetchLimit := defaultFetchLimit

	releases, err := client.GetReleases(rustfsRepo, "", &fetchLimit)
	if err != nil {
		return nil, fmt.Errorf("error fetching RustFS releases: %w", err)
	}

	// Filter and parse RustFS versions (including pre-releases)
	validVersions := make([]string, 0, fetchLimit)

	validVersions = append(validVersions, releases...)

	// Sort versions in descending order using semver-aware comparison
	sort.Slice(validVersions, func(i, j int) bool {
		return compareSemverWithPrerelease(validVersions[i], validVersions[j]) > 0
	})

	// Apply limit
	if len(validVersions) > effectiveLimit {
		return validVersions[:effectiveLimit], nil
	}

	return validVersions, nil
}

// compareSemverWithPrerelease compares two semver strings including pre-release versions.
// Returns: 1 if v1 > v2, -1 if v1 < v2, 0 if equal.
//
//nolint:gosec // G602: parts is a fixed-size [4]int array, all indices are valid
func compareSemverWithPrerelease(v1, v2 string) int {
	// Parse major.minor.patch-prerelease
	parts1 := parseSemverParts(v1)
	parts2 := parseSemverParts(v2)

	// Compare major, minor, patch
	for i := range semverPartCount {
		if parts1[i] > parts2[i] {
			return 1
		}

		if parts1[i] < parts2[i] {
			return -1
		}
	}

	// Compare pre-release (higher number = newer)
	//nolint:gosec // G602: parts is a fixed-size [4]int array, index 3 is always valid
	if parts1[semverPartCount] > parts2[semverPartCount] {
		return 1
	}

	if parts1[semverPartCount] < parts2[semverPartCount] {
		return -1
	}

	return 0
}

// parseSemverParts extracts [major, minor, patch, prerelease] from a semver string.
// For "1.0.0-alpha.71", returns [1, 0, 0, 71].
func parseSemverParts(v string) [4]int {
	var result [4]int

	// Split on hyphen to separate version from prerelease
	mainAndPre := strings.SplitN(v, "-", 2)
	main := mainAndPre[0]

	// Parse main version parts
	mainParts := strings.Split(main, ".")
	for i := 0; i < len(mainParts) && i < semverPartCount; i++ {
		result[i], _ = strconv.Atoi(mainParts[i]) //nolint:errcheck // Best effort parsing
	}

	// Parse prerelease number if present (e.g., "alpha.71" -> 71)
	if len(mainAndPre) > 1 {
		preParts := strings.Split(mainAndPre[1], ".")
		if len(preParts) > 1 {
			result[semverPartCount], _ = strconv.Atoi(preParts[len(preParts)-1]) //nolint:errcheck // Best effort parsing
		}
	}

	return result
}

// compareVersions compares two version strings (e.g., "18.1" vs "17.2").
// Returns: 1 if v1 > v2, -1 if v1 < v2, 0 if equal.
func compareVersions(v1, v2 string) int {
	parts1 := strings.Split(v1, ".")
	parts2 := strings.Split(v2, ".")

	maxLen := max(len(parts2), len(parts1))

	for i := range maxLen {
		var n1, n2 int

		if i < len(parts1) {
			n1, _ = strconv.Atoi(parts1[i]) //nolint:errcheck // Already validated as numeric
		}

		if i < len(parts2) {
			n2, _ = strconv.Atoi(parts2[i]) //nolint:errcheck // Already validated as numeric
		}

		if n1 > n2 {
			return 1
		}

		if n1 < n2 {
			return -1
		}
	}

	return 0
}
