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

ARG SECRETS_WEBHOOK_VERSION="0.3.0"
ARG SECRETS_WEBHOOK_REPO="https://github.com/bank-vaults/secrets-webhook.git"
ARG VAULT_OPERATOR_VERSION="1.23.0"
ARG VAULT_OPERATOR_REPO="https://github.com/bank-vaults/vault-operator.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

# Build secrets-webhook from bank-vaults/secrets-webhook repo
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${SECRETS_WEBHOOK_REPO}#v${SECRETS_WEBHOOK_VERSION} ${HOMEDIR}/secrets-webhook

WORKDIR ${HOMEDIR}/secrets-webhook

ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    mkdir -p ${HOMEDIR}/out ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/secrets-webhook . ; \
    upx --best --lzma --exact ${HOMEDIR}/out/secrets-webhook

# Build vault-operator from bank-vaults/vault-operator repo
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${VAULT_OPERATOR_REPO}#v${VAULT_OPERATOR_VERSION} ${HOMEDIR}/vault-operator

WORKDIR ${HOMEDIR}/vault-operator

RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/vault-operator ./cmd ; \
    upx --best --lzma --exact ${HOMEDIR}/out/vault-operator ; \
    go clean -cache

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/out/secrets-webhook /usr/bin/secrets-webhook
COPY --chown=0:0 --from=build ${HOMEDIR}/out/vault-operator /usr/bin/vault-operator

USER nonroot

ENTRYPOINT ["/usr/bin/vault-operator"]
