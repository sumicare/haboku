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

ARG ARGO_WORKFLOWS_VERSION="3.7.4"
ARG ARGO_WORKFLOWS_REPO="https://github.com/argoproj/argo-workflows.git"

ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${ARGO_WORKFLOWS_REPO}#v${ARGO_WORKFLOWS_VERSION} ${HOMEDIR}/argo-workflows

WORKDIR ${HOMEDIR}/argo-workflows

ENV YARN_ENABLE_SCRIPTS=false

RUN --mount=type=cache,id=yarn-install-${TARGETARCH},target=${HOMEDIR}/argo-workflows/ui/cached-yarn,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    cd ui ; \ 
    [ -z "$(ls -A cached-yarn)" ] && yarn install && cp -r .yarn/* cached-yarn/ && cp yarn.lock cached-yarn/ ; \
    [ -n "$(ls -A cached-yarn)" ] && mkdir -p .yarn && cp -r cached-yarn/* .yarn/ && mv .yarn/yarn.lock . && yarn install ; \
    npm install -g webpack webpack-cli ; \
    NODE_ENV='production' NODE_OPTIONS="--max-old-space-size=2048" yarn build ; \
    rm -rf .pnp.cjs node_modules .yarn ; \
    rm -rf ${HOMEDIR}/.cache 

ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/argo-workflows/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ${HOMEDIR}/cached-vendor/* vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o workflow-controller ./cmd/workflow-controller ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o argo ./cmd/argo ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o argoexec ./cmd/argoexec ; \
    upx --best --lzma --exact workflow-controller ; \
    upx --best --lzma --exact argo ; \
    upx --best --lzma --exact argoexec ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/${HOMEDIR}/argo-workflows/workflow-controller /usr/bin/workflow-controller
COPY --chown=0:0 --from=build ${HOMEDIR}/${HOMEDIR}/argo-workflows/argo /usr/bin/argo
COPY --chown=0:0 --from=build ${HOMEDIR}/${HOMEDIR}/argo-workflows/argoexec /usr/bin/argoexec

USER nonroot

ENTRYPOINT ["/usr/bin/workflow-controller"]
