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

ARG TOPOLVM_VERSION="0.38.1"
ARG TOPOLVM_REPO="https://github.com/topolvm/topolvm.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${TOPOLVM_REPO}#v${TOPOLVM_VERSION} ${HOMEDIR}/topolvm

WORKDIR ${HOMEDIR}/topolvm


ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/topolvm/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ${HOMEDIR}/cached-vendor/* vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o hypertopolvm ./cmd/hypertopolvm ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o lvmd ./cmd/lvmd ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o topolvm-controller ./cmd/topolvm-controller ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o topolvm-node ./cmd/topolvm-node ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o topolvm-scheduler ./cmd/topolvm-scheduler ; \
    upx --best --lzma --exact hypertopolvm ; \
    upx --best --lzma --exact lvmd ; \
    upx --best --lzma --exact topolvm-controller ; \
    upx --best --lzma --exact topolvm-node ; \
    upx --best --lzma --exact topolvm-scheduler ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/topolvm/hypertopolvm /usr/bin/hypertopolvm
COPY --chown=0:0 --from=build ${HOMEDIR}/topolvm/lvmd /usr/bin/lvmd
COPY --chown=0:0 --from=build ${HOMEDIR}/topolvm/topolvm-controller /usr/bin/topolvm-controller
COPY --chown=0:0 --from=build ${HOMEDIR}/topolvm/topolvm-node /usr/bin/topolvm-node
COPY --chown=0:0 --from=build ${HOMEDIR}/topolvm/topolvm-scheduler /usr/bin/topolvm-scheduler

USER nonroot

ENTRYPOINT ["/usr/bin/hypertopolvm"]
