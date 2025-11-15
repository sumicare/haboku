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

package chunks

import (
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("TerraformVariables", func() {
	It("generates organization variable", func() {
		Expect(TerraformVariableOrg()).To(ContainSubstring(`variable "org"`))
	})

	It("generates repository variable", func() {
		Expect(TerraformVariableRepository()).To(ContainSubstring(`variable "repository"`))
	})

	It("generates env variable", func() {
		Expect(TerraformVariableEnv()).To(ContainSubstring(`variable "env"`))
	})

	It("generates debian version variable", func() {
		Expect(TerraformVariableDebianVersion("bookworm")).To(ContainSubstring(`default     = "bookworm"`))
	})

	It("generates registry auth variable", func() {
		Expect(TerraformVariableRegistryAuth()).To(ContainSubstring(`variable "registry_auth"`))
	})

	It("generates replicas variable", func() {
		Expect(TerraformVariableReplicas()).To(ContainSubstring(`variable "replicas"`))
	})

	It("generates deploy custom resources variable", func() {
		Expect(TerraformVariableDeployCustomResources()).To(ContainSubstring(`variable "deploy_custom_resources"`))
	})

	It("generates monitoring namespace variable", func() {
		Expect(TerraformVariableMonitoringNamespace()).To(ContainSubstring(`variable "monitoring_namespace"`))
	})

	It("generates resources variable", func() {
		Expect(TerraformVariableResources()).To(ContainSubstring(`variable "resources"`))
	})

	It("generates probe timeout variables", func() {
		vars := TerraformVariableProbeTimeouts()
		Expect(vars).To(ContainSubstring(`variable "probe_initial_delay"`))
		Expect(vars).To(ContainSubstring(`variable "probe_timeout"`))
		Expect(vars).To(ContainSubstring(`variable "probe_period"`))
		Expect(vars).To(ContainSubstring(`variable "probe_failure_threshold"`))
	})

	It("generates run as user/group variables", func() {
		vars := TerraformVariableRunAsUserGroup()
		Expect(vars).To(ContainSubstring(`variable "run_as_user"`))
		Expect(vars).To(ContainSubstring(`variable "run_as_group"`))
		Expect(vars).To(ContainSubstring(`variable "fs_group"`))
	})

	It("generates chart variables", func() {
		vars := TerraformVariablesChart()
		Expect(vars).To(ContainSubstring(`variable "org"`))
		Expect(vars).To(ContainSubstring(`variable "repository"`))
		Expect(vars).To(ContainSubstring(`variable "env"`))
	})

	It("generates image variables", func() {
		vars := TerraformVariablesImage("bookworm")
		Expect(vars).To(ContainSubstring(`variable "org"`))
		Expect(vars).To(ContainSubstring(`variable "repository"`))
		Expect(vars).To(ContainSubstring(`variable "registry_auth"`))
		Expect(vars).To(ContainSubstring(`default     = "bookworm"`))
	})

	It("generates revision history limit variable", func() {
		Expect(TerraformVariableRevisionHistoryLimit()).To(ContainSubstring(`variable "revision_history_limit"`))
	})

	It("generates number variable", func() {
		Expect(TerraformNumberVariable("http-metrics", "Metrics port", "8080")).
			To(ContainSubstring(`variable "http_metrics"`))
	})

	It("generates port variable", func() {
		Expect(TerraformVariablePort("http", "HTTP port", "80")).
			To(ContainSubstring(`variable "http_port"`))
	})

	It("generates cluster domain variable", func() {
		Expect(TerraformVariableClusterDomain()).To(ContainSubstring(`variable "cluster_domain"`))
	})

	It("generates TLS issuers variables", func() {
		vars := TerraformVariableTLSIssuers("")
		Expect(vars).To(ContainSubstring(`variable "issuer_name"`))
		Expect(vars).To(ContainSubstring(`variable "selfsigned_issuer_name"`))

		varsPrefixed := TerraformVariableTLSIssuers("operator")
		Expect(varsPrefixed).To(ContainSubstring(`variable "operator_issuer_name"`))
		Expect(varsPrefixed).To(ContainSubstring(`variable "operator_selfsigned_issuer_name"`))
	})

	It("generates TLS variables", func() {
		vars := TerraformVariablesTLS("operator")
		Expect(vars).To(ContainSubstring(`variable "cluster_domain"`))
		Expect(vars).To(ContainSubstring(`variable "operator_issuer_name"`))
	})
})
