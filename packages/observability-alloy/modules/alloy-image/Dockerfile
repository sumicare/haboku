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

ARG ALLOY_VERSION="1.12.0"
ARG ALLOY_REPO="https://github.com/grafana/alloy.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${ALLOY_REPO}#v${ALLOY_VERSION} ${HOMEDIR}/alloy

WORKDIR ${HOMEDIR}/alloy

RUN --mount=type=cache,id=npm-alloy-${TARGETARCH},target=${HOMEDIR}/alloy/internal/web/ui/cached-npm,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    cd internal/web/ui ; \
    [ -z "$(ls -A cached-npm)" ] && npm install && cp -r node_modules/* cached-npm/ 2>/dev/null || true ; \
    [ -n "$(ls -A cached-npm)" ] && mkdir -p node_modules && cp -r cached-npm/* node_modules/ 2>/dev/null || true && npm install ; \
    npm run build ; \
    rm -rf node_modules ; \
    rm -rf ${HOMEDIR}/.cache

ARG LD_FLAGS="-s -w"
ARG GO_TAGS="netgo builtinassets promtail_journal_enabled"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    mkdir -p ${HOMEDIR}/out ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/alloy . ; \
    upx --best --lzma --exact ${HOMEDIR}/out/alloy ; \
    go clean -cache

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/out/alloy /usr/bin/alloy

USER nonroot

ENTRYPOINT ["/usr/bin/alloy"]
