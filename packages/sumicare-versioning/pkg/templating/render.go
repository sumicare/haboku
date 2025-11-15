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

package templating

import (
	"bytes"
	"fmt"
	"os"
	"text/template"

	"sumi.care/util/sumicare-versioning/pkg"
	"sumi.care/util/sumicare-versioning/pkg/templating/chunks"
)

const (

	// FilePermission applied to all written files.
	FilePermission = 0o600
)

// TemplateData represents the data structure for template rendering.
type TemplateData struct {
	Versions   map[string]string
	Org        string
	Repository string
}

// RenderTemplate renders a template file with the provided data and returns the result.
func RenderTemplate(templatePath string, data TemplateData) (string, error) {
	// Read the template file
	templateContent, err := os.ReadFile(templatePath)
	if err != nil {
		return "", fmt.Errorf("failed to read template file %s: %w", templatePath, err)
	}

	repos := pkg.Repos()

	// Parse the template
	tmpl, err := template.New("terraform").Funcs(template.FuncMap{
		"GeneratedComment":                       chunks.GeneratedComment,
		"TerraformProvidersDocker":               chunks.TerraformProvidersDocker,
		"TerraformProvidersKubernetes":           chunks.TerraformProvidersKubernetes,
		"TerraformVariableOrg":                   chunks.TerraformVariableOrg,
		"TerraformVariableRepository":            chunks.TerraformVariableRepository,
		"TerraformVariableEnv":                   chunks.TerraformVariableEnv,
		"TerraformVariableReplicas":              chunks.TerraformVariableReplicas,
		"TerraformVariableDeployCustomResources": chunks.TerraformVariableDeployCustomResources,
		"TerraformVariableMonitoringNamespace":   chunks.TerraformVariableMonitoringNamespace,
		"TerraformVariableResources":             chunks.TerraformVariableResources,
		"TerraformVariableProbeTimeouts":         chunks.TerraformVariableProbeTimeouts,
		"TerraformVariableRunAsUserGroup":        chunks.TerraformVariableRunAsUserGroup,
		"TerraformVariableDebianVersion": func() string {
			return chunks.TerraformVariableDebianVersion(data.Versions["debian"])
		},
		"TerraformVariableRegistryAuth": chunks.TerraformVariableRegistryAuth,
		"TerraformVariablesImage": func() string {
			return chunks.TerraformVariablesImage(data.Versions["debian"])
		},
		"TerraformVariablesChart":               chunks.TerraformVariablesChart,
		"TerraformResourceDockerImage":          chunks.TerraformResourceDockerImage,
		"TerraformResourceServiceAccount":       chunks.TerraformResourceServiceAccount,
		"TerraformResourceServiceAccountNamed":  chunks.TerraformResourceServiceAccountNamed,
		"TerraformResourceServiceMonitor":       chunks.TerraformResourceServiceMonitor,
		"TerraformResourceServiceMonitorSimple": chunks.TerraformResourceServiceMonitorSimple,
		"TerraformResourceService":              chunks.TerraformResourceService,
		"TerraformResourceServiceNamed":         chunks.TerraformResourceServiceNamed,
		"TerraformResourcePDB":                  chunks.TerraformResourcePDB,
		"TerraformResourceCommonPDB":            chunks.TerraformResourceCommonPDB,
		"TerraformResourcePDBNamed":             chunks.TerraformResourcePDBNamed,
		"TerraformResourceTLSCertificate":       chunks.TerraformResourceTLSCertificate,
		"TerraformResourceCACertificate":        chunks.TerraformResourceCACertificate,
		"TerraformResourceTLSCertificates":      chunks.TerraformResourceTLSCertificates,
		"TerraformVariableRevisionHistoryLimit": chunks.TerraformVariableRevisionHistoryLimit,
		"TerraformVariableClusterDomain":        chunks.TerraformVariableClusterDomain,
		"TerraformVariableTLSIssuers":           chunks.TerraformVariableTLSIssuers,
		"TerraformVariablesTLS":                 chunks.TerraformVariablesTLS,
		"TerraformNumberVariable":               chunks.TerraformNumberVariable,
		"TerraformVariablePort":                 chunks.TerraformVariablePort,
		"TerraformOutputImageDigest":            chunks.TerraformOutputImageDigest,
		"TerraformOutputImageName":              chunks.TerraformOutputImageName,
		"TerraformOutputImageNameWithDigest":    chunks.TerraformOutputImageNameWithDigest,
		"DockerfileHeader": func() string {
			return chunks.DockerfileHeader(data.Versions["debian"])
		},
		"Version": func(alias string) string {
			return data.Versions[alias]
		},
		"Repo": func(alias string) string {
			return repos[alias]
		},
		"DockerfileBuildHeader": func(name, alias string) string {
			return chunks.DockerfileBuildHeader(name, data.Versions["debian"], data.Versions[alias], repos[alias])
		},
		"DockerfileGoBinary": func(name, alias, ldflags, versionPrefix, workdir, pkg string) string {
			return chunks.DockerfileGoBinary(name, data.Versions["debian"], data.Versions[alias], repos[alias], ldflags, versionPrefix, workdir, pkg)
		},
		"DockerfileGoBinaries": func(name, alias, versionPrefix, workdir string, namePkgLDFlags ...string) string {
			return chunks.DockerfileGoBinaries(name, data.Versions["debian"], data.Versions[alias], repos[alias], versionPrefix, workdir, namePkgLDFlags...)
		},
		"DockerfileBuildGoBinaries":  chunks.DockerfileBuildGoBinaries,
		"DockerfileDistrolessUnpack": chunks.DockerfileDistrolessUnpack,

		// Workload Chunks
		"Probe":                    chunks.Probe,
		"ContainerSecurityContext": chunks.ContainerSecurityContext,
		"PodSecurityContext":       chunks.PodSecurityContext,
		"ContainerResources":       chunks.ContainerResources,
		"NotFargateSelector":       chunks.NotFargateSelector,
		"NotSpotSelector":          chunks.NotSpotSelector,
		"PodAntiAffinity":          chunks.PodAntiAffinity,
		"TopologySpreadConstraint": chunks.TopologySpreadConstraint,
		"DeploymentRollingUpdate":  chunks.DeploymentRollingUpdate,
	}).Parse(string(templateContent))
	if err != nil {
		return "", fmt.Errorf("failed to parse template: %w", err)
	}

	// Execute the template
	var buf bytes.Buffer

	err = tmpl.Execute(&buf, data)
	if err != nil {
		return "", fmt.Errorf("failed to execute template: %w", err)
	}

	return buf.String(), nil
}

// RenderTemplateToFile renders a template and writes the result to a file.
func RenderTemplateToFile(templatePath, outputPath string, data TemplateData) error {
	content, err := RenderTemplate(templatePath, data)
	if err != nil {
		return fmt.Errorf("render template: %w", err)
	}

	err = os.WriteFile(outputPath, []byte(content), FilePermission)
	if err != nil {
		return fmt.Errorf("write file: %w", err)
	}

	return nil
}
