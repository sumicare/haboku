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
	"os/exec"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

const (
	// tofuBinary is the path to the tofu binary.
	tofuBinary = "tofu"
)

// isDeploymentTestEnabled checks if deployment testing is enabled via TEST_DEPLOYMENT env var.
func isDeploymentTestEnabled() bool {
	val := os.Getenv("TEST_DEPLOYMENT")
	return val == "1" || val == "true"
}

var (
	// terraformOptions is the Terraform options for the test.
	terraformOptions *terraform.Options

	// kindClusterName is the name of the kind cluster.
	kindClusterName = "kind-argo-workflows-test"
)

// TestArgoWorkflowsSuite bootstraps argo-workflows terraform module test, with Terratest.
func TestArgoWorkflowsSuite(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "ArgoWorkflows Chart test suite")
}

var _ = BeforeSuite(func() {
	if !isDeploymentTestEnabled() {
		GinkgoT().Log("Skipping deployment tests (set TEST_DEPLOYMENT=1 to enable)")
		return
	}

	// Get the test directory
	testDir, err := os.Getwd()
	Expect(err).NotTo(HaveOccurred())

	// Delete existing kind cluster if it exists (cleanup from previous failed runs)
	GinkgoT().Logf("Checking for existing kind cluster: %s", kindClusterName)
	getClustersCmd := exec.Command("kind", "get", "clusters")
	output, err := getClustersCmd.Output()
	if err == nil && strings.Contains(string(output), kindClusterName) {
		GinkgoT().Logf("Found existing cluster, deleting: %s", kindClusterName)
		deleteCmd := exec.Command("kind", "delete", "cluster", "--name", kindClusterName)
		if err := deleteCmd.Run(); err != nil {
			GinkgoT().Logf("Warning: Failed to delete existing cluster: %v", err)
		} else {
			GinkgoT().Logf("Successfully deleted existing cluster: %s", kindClusterName)
		}
	} else {
		GinkgoT().Logf("No existing cluster found (this is normal for first run)")
	}

	// Create kind cluster manually using kind CLI
	GinkgoT().Logf("Creating kind cluster: %s", kindClusterName)
	cmd := exec.Command("kind", "create", "cluster", "--name", kindClusterName)
	err = cmd.Run()
	Expect(err).NotTo(HaveOccurred(), "Failed to create kind cluster")

	// Configure Terratest options to use OpenTofu
	terraformOptions = &terraform.Options{
		TerraformDir:    testDir,
		TerraformBinary: tofuBinary,
		Vars:            map[string]any{},
		NoColor:         true,
	}

	// Initialize OpenTofu
	terraform.Init(GinkgoT(), terraformOptions)

	// Apply OpenTofu configuration to deploy argo-workflows
	terraform.Apply(GinkgoT(), terraformOptions)
})

var _ = AfterSuite(func() {
	if !isDeploymentTestEnabled() {
		return
	}

	// Destroy Terraform resources
	if terraformOptions != nil {
		terraform.Destroy(GinkgoT(), terraformOptions)
	}

	// Delete kind cluster manually
	GinkgoT().Logf("Deleting kind cluster: %s", kindClusterName)
	cmd := exec.Command("kind", "delete", "cluster", "--name", kindClusterName)
	_ = cmd.Run() // Ignore errors during cleanup
})
