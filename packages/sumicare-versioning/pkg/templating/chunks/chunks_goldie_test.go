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
	"testing"

	"github.com/sebdah/goldie/v2"
)

// TestDockerfileChunks tests Dockerfile chunk generation using golden files.
func TestDockerfileChunks(t *testing.T) {
	golden := goldie.New(t)

	t.Run("DockerfileHeader", func(t *testing.T) {
		content := DockerfileHeader("bookworm")
		golden.Assert(t, "dockerfile_header", []byte(content))
	})

	t.Run("DockerfileGoBinary", func(t *testing.T) {
		content := DockerfileGoBinary("test-app", "bookworm", "1.0.0", "test-repo/", "-X main.version=1.0.0", "v", "test-app", "./cmd/test-app")
		golden.Assert(t, "dockerfile_go_binary", []byte(content))
	})

	t.Run("DockerfileGoBinaries", func(t *testing.T) {
		content := DockerfileGoBinaries("test-app", "bookworm", "1.0.0", "test-repo/", "v", "workdir",
			"bin1--./cmd/bin1--",
			"bin2--./cmd/bin2---X main.v=1",
		)
		golden.Assert(t, "dockerfile_go_binaries", []byte(content))
	})

	t.Run("DockerfileDistrolessUnpack", func(t *testing.T) {
		content := DockerfileDistrolessUnpack()
		golden.Assert(t, "dockerfile_distroless_unpack", []byte(content))
	})
}

// TestTerraformCertificateChunks tests Terraform certificate chunk generation using golden files.
func TestTerraformCertificateChunks(t *testing.T) {
	golden := goldie.New(t)

	t.Run("TerraformResourceTLSCertificate", func(t *testing.T) {
		content := TerraformResourceTLSCertificate("test-app", "local.namespace", "api,metrics", "tls", "var.issuer", "issuer", "server auth,client auth")
		golden.Assert(t, "terraform_tls_certificate", []byte(content))
	})

	t.Run("TerraformResourceCACertificate", func(t *testing.T) {
		content := TerraformResourceCACertificate("test-app", "local.namespace", "${local.app_name}-ca", "${local.app_name}-ca", "var.ca_issuer", "ca-issuer")
		golden.Assert(t, "terraform_ca_certificate", []byte(content))
	})
}
