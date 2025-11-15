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

ARG GRAFANA_VERSION="12.3.0"
ARG GRAFANA_REPO="https://github.com/grafana/grafana.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${GRAFANA_REPO}#v${GRAFANA_VERSION} ${HOMEDIR}/grafana

WORKDIR ${HOMEDIR}/grafana

RUN --mount=type=cache,id=yarn-grafana-${TARGETARCH},target=${HOMEDIR}/grafana/.yarn/cache,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    corepack enable ; \
    NODE_ENV=production yarn install --immutable ; \
    NODE_ENV=production yarn build ; \
    rm -rf node_modules .yarn .pnp.* ; \
    rm -rf ${HOMEDIR}/.cache

ARG LD_FLAGS="-s -w"
ARG GO_TAGS="oss"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    mkdir -p ${HOMEDIR}/out ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/grafana ./pkg/cmd/grafana-server ; \
    upx --best --lzma --exact ${HOMEDIR}/out/grafana ; \
    go clean -cache

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/out/grafana /usr/bin/grafana
COPY --chown=0:0 --from=build ${HOMEDIR}/grafana/public /usr/share/grafana/public
COPY --chown=0:0 --from=build ${HOMEDIR}/grafana/conf /etc/grafana
COPY --chown=0:0 --from=build ${HOMEDIR}/grafana/LICENSE /usr/share/grafana/LICENSE

USER nonroot

ENTRYPOINT ["/usr/bin/grafana"]

