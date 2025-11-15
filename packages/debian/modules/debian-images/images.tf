/*
   Copyright 2025 Sumicare

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

data "docker_registry_image" "debian" {
  name = "debian:${var.debian_version}"
}

resource "docker_image" "base" {
  name         = "${var.repository}${var.org}/base:${var.debian_version}"
  keep_locally = true
  triggers = {
    debian_digest = data.docker_registry_image.debian.sha256_digest
  }

  build {
    context    = path.module
    builder    = "default"
    dockerfile = "${path.module}/Dockerfile.base"
    tag        = ["${var.repository}${var.org}/base:${var.debian_version}"]
    build_args = {
      DEBIAN_VERSION : "${var.debian_version}"
      REPO : var.repository
      ORG : var.org
    }
    label = {
      author : "${var.org}"
    }
  }
}

resource "docker_image" "build" {
  name         = "${var.repository}${var.org}/build:${var.debian_version}"
  keep_locally = true
  triggers = {
    base_digest = docker_image.base.repo_digest
  }

  build {
    context    = path.module
    builder    = "default"
    dockerfile = "${path.module}/Dockerfile.build"
    tag        = ["${var.repository}${var.org}/build:${var.debian_version}"]
    build_args = {
      DEBIAN_VERSION : "${var.debian_version}"
      REPO : var.repository
      ORG : var.org
    }
    label = {
      author : "${var.org}"
    }
  }

  depends_on = [docker_image.base]
}


resource "docker_image" "distroless" {
  name         = "${var.repository}${var.org}/distroless:${var.debian_version}"
  keep_locally = true
  triggers = {
    base_digest = docker_image.base.repo_digest
  }

  build {
    context    = path.module
    builder    = "default"
    dockerfile = "${path.module}/Dockerfile.distroless"
    tag        = ["${var.repository}${var.org}/distroless:${var.debian_version}"]
    build_args = {
      DEBIAN_VERSION : "${var.debian_version}"
      REPO : var.repository
      ORG : var.org
    }
    label = {
      author : "${var.org}"
    }
  }

  depends_on = [docker_image.base]
}
