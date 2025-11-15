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

ARG PYROSCOPE_VERSION="1.16.0"
ARG PYROSCOPE_REPO="https://github.com/grafana/pyroscope.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PYROSCOPE_REPO}#v${PYROSCOPE_VERSION} ${HOMEDIR}/pyroscope

WORKDIR ${HOMEDIR}/pyroscope

# Build frontend assets
RUN --mount=type=cache,id=yarn-pyroscope-${TARGETARCH},target=/usr/local/share/.cache/yarn/v6,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    yarn --frozen-lockfile ; \
    yarn build ; \
    rm -rf node_modules ; \
    rm -rf ${HOMEDIR}/.cache

ARG LD_FLAGS="-s -w -extldflags '-static'"
ARG GO_TAGS="netgo,embedassets"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

# Build pyroscope and profilecli binaries
RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    mkdir -p ${HOMEDIR}/out ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/pyroscope ./cmd/pyroscope ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/profilecli ./cmd/profilecli ; \
    upx --best --lzma --exact ${HOMEDIR}/out/pyroscope ${HOMEDIR}/out/profilecli ; \
    go clean -cache

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/out/pyroscope /usr/bin/pyroscope
COPY --chown=0:0 --from=build ${HOMEDIR}/out/profilecli /usr/bin/profilecli

USER nonroot

ENTRYPOINT ["/usr/bin/pyroscope"]
