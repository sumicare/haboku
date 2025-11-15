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
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

const (
	// tofuBinary is the path to the OpenTofu binary used by Terratest.
	tofuBinary = "tofu"
)

// terraformOptions holds the Terratest Terraform options used for this suite.
var terraformOptions *terraform.Options

// BeforeSuite applies the Terraform configuration in this test directory using OpenTofu.
var _ = BeforeSuite(func() {
	testDir, err := os.Getwd()
	Expect(err).NotTo(HaveOccurred())

	terraformOptions = &terraform.Options{
		TerraformDir:    testDir,
		TerraformBinary: tofuBinary,
		NoColor:         true,
	}
})

// AfterSuite destroys the Terraform-managed resources and cleans up Docker images.
var _ = AfterSuite(func() {
	if terraformOptions != nil {
		terraform.Destroy(GinkgoT(), terraformOptions)
	}
})

// TestSumicareImagesSuite bootstraps sumicare images build test, with Terratest.
func TestSumicareImagesSuite(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Sumicare Images suite test")
}
