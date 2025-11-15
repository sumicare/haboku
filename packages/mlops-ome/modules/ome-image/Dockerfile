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

###           DO NOT EDIT            ###
# This file is automagically generated #

ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
ARG DEBIAN_VERSION="trixie-20251117-slim"
ARG REPO="docker.io/"
ARG ORG="sumicare"
FROM ${REPO}${ORG}/build:${DEBIAN_VERSION} AS build

ARG TARGETARCH

ARG OME_VERSION="0.3.8"
ARG OME_REPO="https://github.com/sgl-project/ome.git"

ARG BUILDER_USER="developer"
ARG BUILDER_UID=10000
ARG BUILDER_GID=100
ARG HOMEDIR=/build

USER root

ARG DISTROLESS_PACKAGES="libssl3t64 libgcc-s1 zlib1g libzstd1"
ENV DISTROLESS_PACKAGES=${DISTROLESS_PACKAGES}

RUN --mount=type=cache,id=cache-apt-${TARGETARCH},target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=lib-apt-${TARGETARCH},target=/var/lib/apt,sharing=locked \
    set -eux ; \
    # Download and extract packages
    apt-get update -y ; \
    apt-get upgrade -y ; \
    echo ${DISTROLESS_PACKAGES} | xargs apt-get download -y --no-install-recommends --no-install-suggests ; \
    mkdir -p /dpkg/var/lib/dpkg/status.d/ ; \
    for deb in *.deb; do \
    package_name="$(dpkg-deb -I "${deb}" | awk '/^ Package: .*$/ {print $2}')" ; \
    echo "Processing: ${package_name}" ; \
    dpkg --ctrl-tarfile "$deb" | tar -Oxf - ./control > "/dpkg/var/lib/dpkg/status.d/${package_name}" ; \
    dpkg --extract "$deb" /dpkg || exit 10 ; \
    done ; \
    # Cleanup
    find /dpkg/ -type d -empty -delete ; \
    rm -rf /dpkg/usr/share/doc/ ; \
    apt-get purge -y --auto-remove ; \
    find /usr -name '*.pyc' -type f -exec bash -c 'for pyc; do dpkg -S "$pyc" &> /dev/null || rm -vf "$pyc"; done' -- '{}' + ; \
    rm -rf /var/lib/apt/lists/* 

USER ${BUILDER_USER}

ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${OME_REPO}#v${OME_VERSION} ${HOMEDIR}/ome

WORKDIR ${HOMEDIR}/ome

ARG LD_FLAGS="-s -w"

RUN set -eux ; \
    cd pkg/xet ; \
    cargo build --release ; \
    cp target/release/libxet.a . ; \
    go build -ldflags="${LD_FLAGS} -extldflags '-L./'" . ; \
    cd ../.. ; \
    GOARCH=${TARGETARCH} go build -ldflags="${LD_FLAGS}" -v -o manager ./cmd/manager ; \
    GOARCH=${TARGETARCH} go build -ldflags="${LD_FLAGS}" -v -o model-agent ./cmd/model-agent ; \
    GOARCH=${TARGETARCH} go build -ldflags="${LD_FLAGS}" -v -o ome-agent ./cmd/ome-agent ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -ldflags="${LD_FLAGS} -extldflags '-static'" -v -o multinode-prober ./cmd/multinode-prober ; \
    upx --best --lzma --exact manager ; \
    upx --best --lzma --exact model-agent ; \
    upx --best --lzma --exact ome-agent ; \
    upx --best --lzma --exact multinode-prober ; \
    go clean -cache -modcache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src ; \
    find ${HOMEDIR}/ome -type d -name target -exec rm -rf {} + 2>/dev/null || true ; \
    rm -rf ~/.cargo/registry ~/.cargo/git ~/.rustup

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build /dpkg /
COPY --chown=0:0 --from=build ${HOMEDIR}/ome/manager /usr/bin/manager
COPY --chown=0:0 --from=build ${HOMEDIR}/ome/model-agent /usr/bin/model-agent
COPY --chown=0:0 --from=build ${HOMEDIR}/ome/multinode-prober /usr/bin/multinode-prober
COPY --chown=0:0 --from=build ${HOMEDIR}/ome/ome-agent /usr/bin/ome-agent

ENTRYPOINT ["/usr/bin/manager"]
