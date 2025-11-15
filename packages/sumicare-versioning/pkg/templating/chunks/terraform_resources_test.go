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

var _ = Describe("TerraformResources", func() {
	Describe("TerraformResourceService", func() {
		It("generates service with ports", func() {
			res := TerraformResourceService("test", "http--TCP--80,https--TCP--443", "", "ClusterIP")
			Expect(res).To(ContainSubstring(`resource "kubernetes_service" "test"`))
			Expect(res).To(ContainSubstring(`port        = 80`))
			Expect(res).To(ContainSubstring(`port        = 443`))
			Expect(res).To(ContainSubstring(`type     = "ClusterIP"`))
		})

		It("generates service with clusterIP and dependencies", func() {
			res := TerraformResourceService("test", "http--TCP--80", "None", "ClusterIP", "dep1", "dep2")
			Expect(res).To(ContainSubstring(`cluster_ip = "None"`))
			Expect(res).To(ContainSubstring(`depends_on = [`))
			Expect(res).To(ContainSubstring(`dep1`))
			Expect(res).To(ContainSubstring(`dep2`))
		})

		It("generates service with appProtocol", func() {
			res := TerraformResourceService("test", "http--TCP--80--target--http", "", "ClusterIP")
			Expect(res).To(ContainSubstring(`app_protocol = "http"`))
		})
	})

	Describe("TerraformResourceServiceNamed", func() {
		It("generates service with custom name suffix", func() {
			res := TerraformResourceServiceNamed("test", "suffix", "local.ns", "local.sel", "http--TCP--80", "", "ClusterIP")
			Expect(res).To(ContainSubstring(`name      = "${local.app_name}-suffix"`))
		})
	})

	// Add more resource tests as needed for coverage
})
