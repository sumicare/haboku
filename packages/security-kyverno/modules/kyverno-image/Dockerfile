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

ARG KYVERNO_VERSION="1.16.1"
ARG KYVERNO_REPO="https://github.com/kyverno/kyverno.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${KYVERNO_REPO}#v${KYVERNO_VERSION} ${HOMEDIR}/kyverno

WORKDIR ${HOMEDIR}/kyverno


ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/kyverno/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ${HOMEDIR}/cached-vendor/* vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o kyverno ./cmd/kyverno ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o kyverno-init ./cmd/kyverno-init ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o background-controller ./cmd/background-controller ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o cleanup-controller ./cmd/cleanup-controller ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o reports-controller ./cmd/reports-controller ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o cli ./cmd/cli ; \
    upx --best --lzma --exact kyverno ; \
    upx --best --lzma --exact kyverno-init ; \
    upx --best --lzma --exact background-controller ; \
    upx --best --lzma --exact cleanup-controller ; \
    upx --best --lzma --exact reports-controller ; \
    upx --best --lzma --exact cli ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/kyverno/kyverno /usr/bin/kyverno
COPY --chown=0:0 --from=build ${HOMEDIR}/kyverno/kyverno-init /usr/bin/kyverno-init
COPY --chown=0:0 --from=build ${HOMEDIR}/kyverno/background-controller /usr/bin/background-controller
COPY --chown=0:0 --from=build ${HOMEDIR}/kyverno/cleanup-controller /usr/bin/cleanup-controller
COPY --chown=0:0 --from=build ${HOMEDIR}/kyverno/reports-controller /usr/bin/reports-controller
COPY --chown=0:0 --from=build ${HOMEDIR}/kyverno/cli /usr/bin/cli

USER nonroot

ENTRYPOINT ["/usr/bin/kyverno"]
