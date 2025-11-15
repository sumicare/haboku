# syntax=docker/dockerfile:1
# escape=\

#
# Copyright 2025 Sumicare
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

{{ GeneratedComment }}

ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
ARG DEBIAN_VERSION="{{ .Versions.debian }}"
ARG REPO="docker.io/"
ARG ORG="sumicare"

# Build stage: download pre-built RustFS binary from GitHub releases
FROM ${REPO}${ORG}/build:${DEBIAN_VERSION} AS build

ARG TARGETARCH

ARG RUSTFS_VERSION="{{index .Versions "storage-rustfs"}}"
ARG RUSTFS_REPO="https://github.com/rustfs/rustfs"
ARG HOMEDIR=/build

WORKDIR ${HOMEDIR}

# Download and extract RustFS binary from GitHub releases
# Asset naming: rustfs-linux-{arch}-musl-v{version}.zip
RUN set -eux ; \
    case "${TARGETARCH}" in \
    amd64) ARCH="x86_64" ;; \
    arm64) ARCH="aarch64" ;; \
    *) echo "Unsupported TARGETARCH=${TARGETARCH}" >&2 ; exit 1 ;; \
    esac ; \
    ASSET="rustfs-linux-${ARCH}-musl-v${RUSTFS_VERSION}.zip" ; \
    URL="${RUSTFS_REPO}/releases/download/${RUSTFS_VERSION}/${ASSET}" ; \
    echo "Downloading: ${URL}" ; \
    curl -fsSL "${URL}" -o rustfs.zip ; \
    unzip -q rustfs.zip ; \
    chmod +x rustfs ; \
    upx --best --lzma --exact rustfs ; \
    rm -f rustfs.zip

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/rustfs /usr/bin/rustfs

USER nonroot

ENTRYPOINT ["/usr/bin/rustfs"]
