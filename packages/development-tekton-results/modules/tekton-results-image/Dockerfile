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

ARG TEKTON_RESULTS_VERSION="0.17.1"
ARG TEKTON_RESULTS_REPO="https://github.com/tektoncd/results.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${TEKTON_RESULTS_REPO}#v${TEKTON_RESULTS_VERSION} ${HOMEDIR}/tekton-results

WORKDIR ${HOMEDIR}/tekton-results


ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/tekton-results/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ${HOMEDIR}/cached-vendor/* vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o api ./cmd/api ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o cli-docs ./cmd/cli-docs ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o retention-policy-agent ./cmd/retention-policy-agent ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o tkn-results ./cmd/tkn-results ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o watcher ./cmd/watcher ; \
    upx --best --lzma --exact api ; \
    upx --best --lzma --exact cli-docs ; \
    upx --best --lzma --exact retention-policy-agent ; \
    upx --best --lzma --exact tkn-results ; \
    upx --best --lzma --exact watcher ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-results/api /usr/bin/api
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-results/cli-docs /usr/bin/cli-docs
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-results/retention-policy-agent /usr/bin/retention-policy-agent
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-results/tkn-results /usr/bin/tkn-results
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-results/watcher /usr/bin/watcher

USER nonroot

ENTRYPOINT ["/usr/bin/api"]
