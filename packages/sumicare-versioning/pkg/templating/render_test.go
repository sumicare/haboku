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
package templating

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/sebdah/goldie/v2"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("Templating", func() {
	It("RenderTemplate renders data and handles errors", func() {
		tmpDir := GinkgoT().TempDir()
		tpl := filepath.Join(tmpDir, "t.tpl")

		os.WriteFile(tpl, []byte(`{{index .Versions "k"}}|{{.Org}}|{{.Repository}}`), 0o600)
		result, _ := RenderTemplate(tpl, TemplateData{
			Versions: map[string]string{"k": "1.0"}, Org: "test", Repository: "repo",
		})
		Expect(result).To(Equal("1.0|test|repo"))

		// Parse error
		os.WriteFile(tpl, []byte(`{{ .X }`), 0o600)
		_, err := RenderTemplate(tpl, TemplateData{})
		Expect(err).To(HaveOccurred())

		// Missing file
		_, err = RenderTemplate("missing.tpl", TemplateData{})
		Expect(err).To(HaveOccurred())

		// Execution error
		os.WriteFile(tpl, []byte(`{{ .Missing.Method }}`), 0o600)
		_, err = RenderTemplate(tpl, TemplateData{})
		Expect(err).To(HaveOccurred())
	})

	It("RenderTemplateToFile writes output and handles errors", func() {
		tmpDir := GinkgoT().TempDir()
		tpl := filepath.Join(tmpDir, "t.tpl")
		out := filepath.Join(tmpDir, "out")

		os.WriteFile(tpl, []byte(`V:{{index .Versions "k"}}`), 0o600)
		Expect(RenderTemplateToFile(tpl, out, TemplateData{Versions: map[string]string{"k": "2.0"}})).To(Succeed())
		data, _ := os.ReadFile(out)
		Expect(string(data)).To(Equal("V:2.0"))

		os.WriteFile(tpl, []byte(`{{ .X }`), 0o600)
		Expect(RenderTemplateToFile(tpl, out, TemplateData{})).ToNot(Succeed())
	})
})

// testTemplate exercises template functions including closures.
const testTemplate = `{{ GeneratedComment }}
=== Data ===
Org: {{.Org}}
Repo: {{.Repository}}
Debian: {{index .Versions "debian"}}
Version: {{ Version "debian" }}
Repo Func: {{ Repo "keda" }}

=== Terraform Providers ===
{{ TerraformProvidersKubernetes }}
{{ TerraformProvidersDocker }}

=== Terraform Variables ===
{{ TerraformVariableOrg }}
{{ TerraformVariableRepository }}
{{ TerraformVariableEnv }}
{{ TerraformVariableReplicas }}
{{ TerraformVariableResources }}
{{ TerraformVariableDebianVersion }}
{{ TerraformVariablesImage }}
{{ TerraformVariablesChart }}
{{ TerraformVariableProbeTimeouts }}
{{ TerraformVariableRunAsUserGroup }}
{{ TerraformVariableRegistryAuth }}
{{ TerraformVariableRevisionHistoryLimit }}
{{ TerraformVariableClusterDomain }}

=== Dockerfile ===
{{ DockerfileHeader }}
{{ DockerfileBuildHeader "test" "keda" }}
{{ DockerfileGoBinary "test" "keda" "-s -w" "v" "/app" "main" }}
{{ DockerfileGoBinaries "test" "keda" "v" "/app" "bin1" "pkg1" "" "bin2" "pkg2" "" }}

=== Workload Chunks ===
{{ ContainerSecurityContext }}
{{ PodSecurityContext }}
{{ ContainerResources }}
{{ NotFargateSelector }}
{{ NotSpotSelector }}
`

// TestTemplateFunctions tests all template functions with goldie snapshot testing.
func TestTemplateFunctions(t *testing.T) {
	tmpDir := t.TempDir()
	tpl := filepath.Join(tmpDir, "t.tpl")
	os.WriteFile(tpl, []byte(testTemplate), FilePermission)

	data := TemplateData{
		Org: "sumicare", Repository: "ghcr.io/sumicare",
		Versions: map[string]string{"debian": "bookworm-20241111-slim", "keda": "2.16.0"},
	}

	result, err := RenderTemplate(tpl, data)
	if err != nil {
		t.Fatal(err)
	}

	goldie.New(t, goldie.WithFixtureDir("testdata")).Assert(t, "template_functions", []byte(result))
}
