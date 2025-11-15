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

{{ GeneratedComment }}

{{ DockerfileBuildHeader "loki" "observability-loki" }}
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${LOKI_REPO}#v${LOKI_VERSION} ${HOMEDIR}/loki

WORKDIR ${HOMEDIR}/loki

ARG LD_FLAGS="-s -w"
ARG GO_TAGS="netgo"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

# Build all Loki binaries: loki (single binary / microservices), logcli, loki-canary, promtail
RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    mkdir -p ${HOMEDIR}/out ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/loki ./cmd/loki ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/logcli ./cmd/logcli ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/loki-canary ./cmd/loki-canary ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/promtail ./clients/cmd/promtail ; \
    upx --best --lzma --exact ${HOMEDIR}/out/loki ${HOMEDIR}/out/logcli ${HOMEDIR}/out/loki-canary ${HOMEDIR}/out/promtail ; \
    go clean -cache

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/out/loki /usr/bin/loki
COPY --chown=0:0 --from=build ${HOMEDIR}/out/logcli /usr/bin/logcli
COPY --chown=0:0 --from=build ${HOMEDIR}/out/loki-canary /usr/bin/loki-canary
COPY --chown=0:0 --from=build ${HOMEDIR}/out/promtail /usr/bin/promtail
COPY --chown=0:0 --from=build ${HOMEDIR}/loki/cmd/loki/loki-docker-config.yaml /etc/loki/local-config.yaml

USER nonroot

ENTRYPOINT ["/usr/bin/loki"]
