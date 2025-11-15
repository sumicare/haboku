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

ARG TEKTON_TRIGGERS_VERSION="0.34.0"
ARG TEKTON_TRIGGERS_REPO="https://github.com/tektoncd/triggers.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${TEKTON_TRIGGERS_REPO}#v${TEKTON_TRIGGERS_VERSION} ${HOMEDIR}/tekton-triggers

WORKDIR ${HOMEDIR}/tekton-triggers


ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/tekton-triggers/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ${HOMEDIR}/cached-vendor/* vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o binding-eval ./cmd/binding-eval ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o cel-eval ./cmd/cel-eval ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o controller ./cmd/controller ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o eventlistenersink ./cmd/eventlistenersink ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o interceptors ./cmd/interceptors ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o tkn-triggers ./cmd/tkn-triggers ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o triggerrun ./cmd/triggerrun ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o webhook ./cmd/webhook ; \
    upx --best --lzma --exact binding-eval ; \
    upx --best --lzma --exact cel-eval ; \
    upx --best --lzma --exact controller ; \
    upx --best --lzma --exact eventlistenersink ; \
    upx --best --lzma --exact interceptors ; \
    upx --best --lzma --exact tkn-triggers ; \
    upx --best --lzma --exact triggerrun ; \
    upx --best --lzma --exact webhook ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/binding-eval /usr/bin/binding-eval
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/cel-eval /usr/bin/cel-eval
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/controller /usr/bin/controller
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/eventlistenersink /usr/bin/eventlistenersink
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/interceptors /usr/bin/interceptors
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/tkn-triggers /usr/bin/tkn-triggers
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/triggerrun /usr/bin/triggerrun
COPY --chown=0:0 --from=build ${HOMEDIR}/tekton-triggers/webhook /usr/bin/webhook

USER nonroot

ENTRYPOINT ["/usr/bin/binding-eval"]
