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
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("CRD Extraction", func() {
	DescribeTable("splitMultiDocYAML",
		func(content string, expectedCount int, expectedNames []string) {
			result, err := ExtractCRDsFromContent(content)
			Expect(err).NotTo(HaveOccurred(), "expected no error when extracting CRDs from content")
			Expect(result).To(HaveLen(expectedCount), "expected %d CRDs, got %d", expectedCount, len(result))

			for _, name := range expectedNames {
				Expect(result).To(HaveKey(name+".yaml"), "expected CRD %s to be extracted", name)
			}
		},
		Entry("single CRD",
			`apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: foos.example.com
spec:
  group: example.com`,
			1,
			[]string{"foos.example.com"},
		),
		Entry("multi-doc YAML",
			`---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: foos.example.com
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: bars.example.com
---
apiVersion: v1
kind: ConfigMap`,
			2,
			[]string{"foos.example.com", "bars.example.com"},
		),
		Entry("empty content", "", 0, make([]string, 0)),
		Entry("no CRDs", `apiVersion: v1
kind: ConfigMap`, 0, make([]string, 0)),
	)

	DescribeTable("extractCRDInfo",
		func(content string, expectedIsCRD bool, expectedName string) {
			isCRD, name := extractCRDInfo(content)
			Expect(isCRD).To(Equal(expectedIsCRD), "expected isCRD to be %v", expectedIsCRD)
			if expectedIsCRD {
				Expect(name).To(Equal(expectedName), "expected name to be %s", expectedName)
			}
		},
		Entry("valid CRD",
			`apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: foos.example.com`,
			true,
			"foos.example.com",
		),
		Entry("not a CRD",
			`apiVersion: v1
kind: ConfigMap
metadata:
  name: test-config`,
			false,
			"",
		),
		Entry("CRD without name",
			`apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition`,
			true,
			"unknown-crd",
		),
	)

	Describe("extractCRDName", func() {
		It("should extract CRD name from metadata", func() {
			content := `apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: foos.example.com`
			name := extractCRDName(content)
			Expect(name).To(Equal("foos.example.com"), "expected name to be foos.example.com")
		})

		It("should return unknown-crd for missing metadata", func() {
			content := `apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition`
			name := extractCRDName(content)
			Expect(name).To(Equal(unknownCRDName), "expected name to be unknown-crd")
		})

		It("should return unknown-crd for missing name", func() {
			content := `apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  labels: test`
			name := extractCRDName(content)
			Expect(name).To(Equal(unknownCRDName), "expected name to be unknown-crd")
		})

		It("should handle quoted names", func() {
			content := `apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: "foos.example.com"`
			name := extractCRDName(content)
			Expect(name).To(Equal("foos.example.com"), "expected name to be foos.example.com")
		})
	})

	Describe("generateTerraform", func() {
		It("should generate Terraform code for CRDs", func() {
			crds := make(map[string]string)
			crds["foos.example.com.yaml"] = "content1"
			crds["bars.example.com.yaml"] = "content2"
			result := generateTerraform(crds)
			Expect(result).To(ContainSubstring("customresourcedefinition_foos_example_com"), "should contain resource for foos.example.com")
			Expect(result).To(ContainSubstring("customresourcedefinition_bars_example_com"), "should contain resource for bars.example.com")
			// Check for file references
			Expect(result).To(ContainSubstring("foos.example.com.yaml"), "should reference the correct file")
			Expect(result).To(ContainSubstring("bars.example.com.yaml"), "should reference the correct file")
		})

		It("should handle empty CRDs map", func() {
			crds := make(map[string]string)
			result := generateTerraform(crds)
			Expect(result).NotTo(ContainSubstring("resource"), "should not contain any resources")
			Expect(result).To(ContainSubstring(autoGenLicenseHeader), "should contain license header")
		})
	})
})
