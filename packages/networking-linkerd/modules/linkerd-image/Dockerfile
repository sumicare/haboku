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

ARG LINKERD_VERSION="25.11.3"
ARG LINKERD_REPO="https://github.com/linkerd/linkerd2.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${LINKERD_REPO}#edge-${LINKERD_VERSION} ${HOMEDIR}/linkerd

WORKDIR ${HOMEDIR}/linkerd

RUN --mount=type=cache,id=yarn-linkerd-${TARGETARCH},target=${HOMEDIR}/linkerd/web/app/cached-yarn,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    cd web/app ; \
    [ -z "$(ls -A cached-yarn)" ] && yarn install && cp -r .yarn/* cached-yarn/ 2>/dev/null || true && cp yarn.lock cached-yarn/ 2>/dev/null || true ; \
    [ -n "$(ls -A cached-yarn)" ] && mkdir -p .yarn && cp -r cached-yarn/* .yarn/ 2>/dev/null || true && [ -f .yarn/yarn.lock ] && mv .yarn/yarn.lock . || true && yarn install ; \
    yarn lingui compile || true ; \
    NODE_ENV='production' yarn webpack ; \
    rm -rf node_modules .yarn .pnp.cjs ; \
    rm -rf ${HOMEDIR}/.cache

ARG LD_FLAGS="-s -w"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    mkdir -p ${HOMEDIR}/out ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags prod -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/controller ./controller/cmd ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags prod -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/linkerd ./cli ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/proxy-identity ./proxy-identity ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags prod -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/metrics-api ./viz/metrics-api/cmd ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags prod -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/tap ./viz/tap/cmd ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/web ./web ; \
    upx --best --lzma --exact ${HOMEDIR}/out/controller ; \
    upx --best --lzma --exact ${HOMEDIR}/out/linkerd ; \
    upx --best --lzma --exact ${HOMEDIR}/out/proxy-identity ; \
    upx --best --lzma --exact ${HOMEDIR}/out/metrics-api ; \
    upx --best --lzma --exact ${HOMEDIR}/out/tap ; \
    upx --best --lzma --exact ${HOMEDIR}/out/web ; \
    go clean -cache

RUN --mount=type=cache,id=cargo-registry-${TARGETARCH},target=${HOMEDIR}/.cargo/registry,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    --mount=type=cache,id=cargo-target-${TARGETARCH},target=${HOMEDIR}/linkerd/target,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    export RUSTFLAGS="--cfg tokio_unstable" ; \
    cargo build --release --package=linkerd-policy-controller ; \
    cp target/release/linkerd-policy-controller ${HOMEDIR}/out/ ; \
    strip ${HOMEDIR}/out/linkerd-policy-controller ; \
    upx --best --lzma --exact ${HOMEDIR}/out/linkerd-policy-controller

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/out/controller /usr/bin/controller
COPY --chown=0:0 --from=build ${HOMEDIR}/out/linkerd /usr/bin/linkerd
COPY --chown=0:0 --from=build ${HOMEDIR}/out/proxy-identity /usr/bin/proxy-identity
COPY --chown=0:0 --from=build ${HOMEDIR}/out/linkerd-policy-controller /usr/bin/linkerd-policy-controller
COPY --chown=0:0 --from=build ${HOMEDIR}/out/metrics-api /usr/bin/metrics-api
COPY --chown=0:0 --from=build ${HOMEDIR}/out/tap /usr/bin/tap
COPY --chown=0:0 --from=build ${HOMEDIR}/out/web /usr/bin/web
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

USER nonroot

ENTRYPOINT ["/usr/bin/controller"]
