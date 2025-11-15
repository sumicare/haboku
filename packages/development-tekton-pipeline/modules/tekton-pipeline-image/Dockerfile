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

ARG TEKTON_PIPELINE_VERSION="1.7.0"
ARG TEKTON_PIPELINE_REPO="https://github.com/tektoncd/pipeline.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${TEKTON_PIPELINE_REPO}#v${TEKTON_PIPELINE_VERSION} ${HOMEDIR}/tekton-pipeline

WORKDIR ${HOMEDIR}/tekton-pipeline


ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/tekton-pipeline/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ${HOMEDIR}/cached-vendor/* vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o controller ./cmd/controller ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o entrypoint ./cmd/entrypoint ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o events ./cmd/events ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o nop ./cmd/nop ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o resolvers ./cmd/resolvers ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o sidecarlogresults ./cmd/sidecarlogresults ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o webhook ./cmd/webhook ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o workingdirinit ./cmd/workingdirinit ; \
    upx --best --lzma --exact controller ; \
    upx --best --lzma --exact entrypoint ; \
    upx --best --lzma --exact events ; \
    upx --best --lzma --exact nop ; \
    upx --best --lzma --exact resolvers ; \
    upx --best --lzma --exact sidecarlogresults ; \
    upx --best --lzma --exact webhook ; \
    upx --best --lzma --exact workingdirinit ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/controller /usr/bin/controller
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/entrypoint /usr/bin/entrypoint
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/events /usr/bin/events
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/nop /usr/bin/nop
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/resolvers /usr/bin/resolvers
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/sidecarlogresults /usr/bin/sidecarlogresults
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/webhook /usr/bin/webhook
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-pipeline/workingdirinit /usr/bin/workingdirinit

USER nonroot

ENTRYPOINT ["/usr/bin/controller"]
