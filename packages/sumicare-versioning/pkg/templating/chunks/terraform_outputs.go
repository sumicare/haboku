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

// TerraformOutputImageDigest generates a Terraform output for the image digest.
func TerraformOutputImageDigest(name string) string {
	return `output "` + name + `_image_digest" {
  value       = trimprefix(docker_image.` + name + `.repo_digest, "${var.org}/` + name + `@sha256:")
  description = "` + name + ` image digest"
}`
}

// TerraformOutputImageName generates a Terraform output for the image name.
func TerraformOutputImageName(name string) string {
	return `output "` + name + `_image_name" {
  value       = "${var.repository}${var.org}/` + name + `:${var.descheduler_version}"
  description = "` + name + ` image name"
}`
}

// TerraformOutputImageNameWithDigest generates a Terraform output for the image name with digest.
func TerraformOutputImageNameWithDigest(name string) string {
	return `output "` + name + `_image_name_with_digest" {
  value       = "${var.repository}${var.org}/` + name + `@sha256:${trimprefix(docker_image.` + name + `.repo_digest, "${var.org}/` + name + `@sha256:")}"
  description = "` + name + ` image name with SHA256 digest"
}`
}
