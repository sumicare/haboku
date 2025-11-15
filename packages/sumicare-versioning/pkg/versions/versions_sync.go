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
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"unicode"
)

// embeddedVersionMapping maps virtual version entries to their target package directories.
// This allows base software versions (e.g., "storage-postgres") to be written to
// operator package directories (e.g., "storage-cnpg") that manage those components.
//
// For example, the PostgreSQL version is tracked as "storage-postgres" but written
// to the "storage-cnpg" package since CloudNativePG manages PostgreSQL instances.
//
//nolint:gochecknoglobals // Configuration mapping required at package level.
var embeddedVersionMapping = map[string]string{
	"development-theia-cloud":        "development-theia",
	"development-theia-ide":          "development-theia",
	"security-bank-vaults-operator":  "security-bank-vaults",
	"security-bank-vaults-webhook":   "security-bank-vaults",
	"security-openbao":               "security-bank-vaults",
	"storage-postgres":               "storage-cnpg",
	"storage-postgres-hypopg":        "storage-cnpg",
	"storage-postgres-index-advisor": "storage-cnpg",
	"storage-postgres-pgaudit":       "storage-cnpg",
	"storage-postgres-pg-repack":     "storage-cnpg",
	"storage-postgres-pgmq":          "storage-cnpg",
	"storage-postgres-pgroonga":      "storage-cnpg",
	"storage-postgres-pgrouting":     "storage-cnpg",
	"storage-postgres-pgvector":      "storage-cnpg",
	"storage-postgres-pgx-ulid":      "storage-cnpg",
	"storage-postgres-rum":           "storage-cnpg",
	"storage-valkey":                 "storage-valkey-operator",
	"messaging-nats-server":          "messaging-nats",
}

// ReadVersionsFile reads and parses the versions.json file from the current directory.
// Returns an empty [VersionsFile] if the file doesn't exist.
func ReadVersionsFile() (VersionsFile, error) {
	data, err := os.ReadFile(VersionsFileName)
	if err != nil {
		if os.IsNotExist(err) {
			return make(VersionsFile), nil
		}

		return nil, fmt.Errorf("read versions file: %w", err)
	}

	var versions VersionsFile
	if err := json.Unmarshal(data, &versions); err != nil {
		return nil, fmt.Errorf("unmarshal versions: %w", err)
	}

	return versions, nil
}

// SoftwareVersionKey converts a package name to a camelCase key for use in package.json.
// It strips the category prefix and converts remaining parts to camelCase.
//
// Examples:
//   - "compute-keda" -> "keda"
//   - "observability-grafana-operator" -> "grafanaOperator"
//   - "storage-postgres-pgvector" -> "postgresPgvector"
func SoftwareVersionKey(packageName string) string {
	idx := strings.Index(packageName, "-")
	if idx == -1 {
		return packageName
	}

	parts := strings.Split(packageName[idx+1:], "-")

	var builder strings.Builder
	for i, part := range parts {
		if i == 0 {
			builder.WriteString(part)
		} else if part != "" {
			builder.WriteString(string(unicode.ToUpper(rune(part[0]))) + part[1:])
		}
	}

	return builder.String()
}

// UpdatePackageJSONFiles synchronizes version information from the versions map
// to individual package.json files in the packages directory.
//
// It handles both direct package versions and embedded versions (via [embeddedVersionMapping])
// where base software versions are written to operator package directories.
//
// Returns a map of package names to their [VersionChange] results.
func UpdatePackageJSONFiles(versions VersionsFile, packagesDir string) (map[string]VersionChange, error) {
	entries, err := os.ReadDir(packagesDir)
	if err != nil {
		return nil, fmt.Errorf("read packages dir: %w", err)
	}

	updated := make(map[string]VersionChange)

	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}

		ver, ok := versions[entry.Name()]
		if !ok {
			continue
		}

		change, err := updateVersion(packagesDir, entry.Name(), entry.Name(), ver)
		if err == nil {
			updated[entry.Name()] = change
		}
	}

	for versionName, targetPkg := range embeddedVersionMapping {
		ver, ok := versions[versionName]
		if !ok {
			continue
		}

		change, err := updateVersion(packagesDir, targetPkg, versionName, ver)
		if err == nil {
			updated[versionName] = change
		}
	}

	return updated, nil
}

// updateVersion updates a single version entry in a package.json file's "versions" object.
// It reads the file, updates the specified key, sorts the versions object for consistent output,
// and writes the file back.
func updateVersion(packagesDir, pkgName, versionName, newVersion string) (VersionChange, error) {
	pkgPath := filepath.Join(packagesDir, pkgName, "package.json")
	key := SoftwareVersionKey(versionName)

	data, err := os.ReadFile(pkgPath)
	if err != nil {
		return VersionChange{}, fmt.Errorf("read package.json: %w", err)
	}

	var pkg map[string]any
	if err := json.Unmarshal(data, &pkg); err != nil {
		return VersionChange{}, fmt.Errorf("unmarshal package.json: %w", err)
	}

	// Get or create the versions object
	versionsObj, ok := pkg["versions"].(map[string]any)
	if !ok {
		versionsObj = make(map[string]any)
		pkg["versions"] = versionsObj
	}

	var oldVersion string

	v, exists := versionsObj[key]
	if exists {
		s, isString := v.(string)
		if !isString {
			return VersionChange{}, ErrVersionFieldNotString
		}

		oldVersion = s
	}

	if oldVersion == newVersion {
		return VersionChange{OldVersion: oldVersion, NewVersion: newVersion, Changed: false}, nil
	}

	versionsObj[key] = newVersion

	// Sort versions object keys for consistent output
	pkg["versions"] = sortedVersions(versionsObj)

	var buf bytes.Buffer

	enc := json.NewEncoder(&buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")

	if err := enc.Encode(pkg); err != nil {
		return VersionChange{}, fmt.Errorf("encode package.json: %w", err)
	}

	if err := os.WriteFile(pkgPath, buf.Bytes(), FilePermissions); err != nil {
		return VersionChange{}, fmt.Errorf("write package.json: %w", err)
	}

	return VersionChange{OldVersion: oldVersion, NewVersion: newVersion, Changed: true}, nil
}

// orderedVersions is a JSON-serializable map that maintains sorted key order.
// This ensures consistent, deterministic output when writing package.json files.
type orderedVersions struct {
	values map[string]string
	keys   []string
}

// sortedVersions creates an [orderedVersions] from a map[string]any.
// Keys are sorted alphabetically for consistent JSON output.
func sortedVersions(m map[string]any) *orderedVersions {
	keys := make([]string, 0, len(m))

	values := make(map[string]string, len(m))
	for k, v := range m {
		keys = append(keys, k)
		if s, ok := v.(string); ok {
			values[k] = s
		}
	}

	sort.Strings(keys)

	return &orderedVersions{keys: keys, values: values}
}

// MarshalJSON implements [json.Marshaler] with alphabetically sorted keys.
// This ensures package.json versions objects have consistent ordering.
func (ov *orderedVersions) MarshalJSON() ([]byte, error) {
	var buf bytes.Buffer
	buf.WriteByte('{')

	for i, key := range ov.keys {
		if i > 0 {
			buf.WriteByte(',')
		}

		keyJSON, err := json.Marshal(key) //nolint:errchkjson // key is always string
		if err != nil {
			return nil, fmt.Errorf("marshal key: %w", err)
		}

		val, err := json.Marshal(ov.values[key]) //nolint:errchkjson // value is always string
		if err != nil {
			return nil, fmt.Errorf("marshal value: %w", err)
		}

		buf.Write(keyJSON)
		buf.WriteByte(':')
		buf.Write(val)
	}

	buf.WriteByte('}')

	return buf.Bytes(), nil
}
