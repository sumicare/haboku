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
	"path/filepath"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("Sources", func() {
	Describe("GetAllSources", func() {
		It("should return all configured sources", func() {
			sources := GetAllSources("/packages")
			Expect(sources).NotTo(BeEmpty(), "expected non-empty list of sources")
			Expect(len(sources)).To(BeNumerically(">=", 20), "expected at least 20 sources")
		})

		DescribeTable("source configuration",
			func(pkg, expectedName, expectedTargetSuffix string, hasHelm, hasGitHub bool) {
				source := GetSourceByPackage("/packages", pkg)
				Expect(source).NotTo(BeNil(), "source for package %s should exist", pkg)
				Expect(source.Name).To(Equal(expectedName), "source name for package %s should be %s", pkg, expectedName)
				Expect(source.TargetDir).To(HaveSuffix(expectedTargetSuffix), "source target dir for package %s should be %s", pkg, expectedTargetSuffix)

				if hasHelm {
					Expect(source.HelmRepo).NotTo(BeNil(), "package %s should have HelmRepo", pkg)
					Expect(source.ChartName).NotTo(BeEmpty(), "package %s should have ChartName", pkg)
				}

				//nolint:revive // we're fine with this
				if hasGitHub {
					Expect(source.GitHubDir).NotTo(BeNil(), "package %s should have GitHubDir", pkg)
					Expect(source.GitHubDir.Owner).NotTo(BeEmpty(), "package %s should have GitHubDir.Owner", pkg)
					Expect(source.GitHubDir.Repo).NotTo(BeEmpty(), "package %s should have GitHubDir.Repo", pkg)
					Expect(source.GitHubDir.Path).NotTo(BeEmpty(), "package %s should have GitHubDir.Path", pkg)
				}
			},
			// Compute
			Entry("compute-keda", "compute-keda", "keda", "keda-crds", false, true),
			Entry("compute-kamaji", "compute-kamaji", "kamaji", "kamaji-crds", false, true),
			Entry("compute-vpa", "compute-vpa", "vpa", "vpa-crds", false, false),

			// Development
			Entry("development-atlas-operator", "development-atlas-operator", "atlas-operator", "atlas-operator-crds", false, true),
			Entry("development-tekton-dashboard", "development-tekton-dashboard", "tekton-dashboard", "tekton-dashboard-crds", false, true),
			Entry("development-tekton-pipeline", "development-tekton-pipeline", "tekton-pipeline", "tekton-pipeline-crds", false, true),
			Entry("development-tekton-triggers", "development-tekton-triggers", "tekton-triggers", "tekton-triggers-crds", false, true),
			Entry("development-theia", "development-theia", "theia", "theia-crds", false, true),

			// GitOps
			Entry("gitops-argo-cd", "gitops-argo-cd", "argo-cd", "argo-cd-crds", false, true),
			Entry("gitops-argo-events", "gitops-argo-events", "argo-events", "argo-events-crds", false, false),
			Entry("gitops-argo-rollouts", "gitops-argo-rollouts", "argo-rollouts", "argo-rollouts-crds", false, true),
			Entry("gitops-argo-workflows", "gitops-argo-workflows", "argo-workflows", "argo-workflows-crds", false, true),

			// MLOps
			Entry("mlops-volcano", "mlops-volcano", "volcano", "volcano-crds", false, false),

			// Networking
			Entry("networking-external-dns", "networking-external-dns", "external-dns", "external-dns-crds", true, false),
			Entry("networking-gateway-api", "networking-gateway-api", "gateway-api", "gateway-api-crds", false, true),

			// Security
			Entry("security-cert-manager", "security-cert-manager", "cert-manager", "cert-manager-crds", false, true),
			Entry("security-falco", "security-falco", "falco", "falco-crds", false, true),
			Entry("security-kyverno", "security-kyverno", "kyverno", "kyverno-crds", false, true),

			// Storage
			Entry("storage-cnpg", "storage-cnpg", "cnpg", "cnpg-crds", false, true),
			Entry("storage-velero", "storage-velero", "velero", "velero-crds", true, false),
		)
	})

	Describe("GetSourceByName", func() {
		DescribeTable("should find source by name",
			func(name string) {
				source := GetSourceByName("packages", name)
				Expect(source).NotTo(BeNil(), "source for name %s should exist", name)
				Expect(source.Name).To(Equal(name), "source name for name %s should match expected value", name)
			},
			Entry("keda", "keda"),
			Entry("vpa", "vpa"),
			Entry("argo-cd", "argo-cd"),
			Entry("cert-manager", "cert-manager"),
		)

		It("should return nil for unknown name", func() {
			source := GetSourceByName("packages", "unknown-source")
			Expect(source).To(BeNil(), "source for name unknown-source should not exist")
		})
	})

	Describe("GetSourceByPackage", func() {
		DescribeTable("should find source by package",
			func(pkg, expectedName string) {
				source := GetSourceByPackage("packages", pkg)
				Expect(source).NotTo(BeNil(), "source for package %s should exist", pkg)
				Expect(source.Name).To(Equal(expectedName), "source name for package %s should match expected value", pkg)
			},
			Entry("compute-keda", "compute-keda", "keda"),
			Entry("security-cert-manager", "security-cert-manager", "cert-manager"),
			Entry("gitops-argo-cd", "gitops-argo-cd", "argo-cd"),
		)

		It("should return nil for unknown package", func() {
			source := GetSourceByPackage("packages", "unknown-package")
			Expect(source).To(BeNil(), "source for package unknown-package should not exist")
		})
	})

	Describe("TargetDir computation", func() {
		DescribeTable("should compute correct target directory",
			func(pkg, expectedPath string) {
				source := GetSourceByPackage("packages", pkg)
				Expect(source).NotTo(BeNil(), "source for package %s should exist", pkg)
				Expect(source.TargetDir).To(Equal(expectedPath), "target dir for package %s should match expected value", pkg)
			},
			Entry("compute-keda", "compute-keda", filepath.Join("packages", "compute-keda", "modules", "keda-crds")),
			Entry("security-cert-manager", "security-cert-manager", filepath.Join("packages", "security-cert-manager", "modules", "cert-manager-crds")),
			Entry("development-tekton-pipeline", "development-tekton-pipeline", filepath.Join("packages", "development-tekton-pipeline", "modules", "tekton-pipeline-crds")),
		)
	})
})
