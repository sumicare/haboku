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

package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

// Basic sanity check to ensure Terraform options are configured and apply succeeded.
var _ = Describe("Debian base images Terraform module", func() {
	It("successfully applies Terraform test module", func() {
		Expect(terraformOptions).NotTo(BeNil())
		terraform.Init(GinkgoT(), terraformOptions)
		terraform.Apply(GinkgoT(), terraformOptions)
	})
})
