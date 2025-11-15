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

{{ DockerfileBuildHeader "prometheus" "observability-prometheus" }}
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PROMETHEUS_REPO}#v${PROMETHEUS_VERSION} ${HOMEDIR}/prometheus

WORKDIR ${HOMEDIR}/prometheus

# Build frontend assets
RUN --mount=type=cache,id=npm-prometheus-${TARGETARCH},target=${HOMEDIR}/prometheus/web/ui/node_modules,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    cd web/ui ; \
    npm install ; \
    CI="" npm run build ; \
    cd react-app && npm install ; \
    rm -rf ${HOMEDIR}/.cache

ARG LD_FLAGS="-s -w"
ARG GO_TAGS="netgo,builtinassets"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

# Build prometheus and promtool binaries
RUN --mount=type=cache,id=go-mod-${TARGETARCH},target=/go/pkg/mod,sharing=locked \
    --mount=type=cache,id=go-build-${TARGETARCH},target=${HOMEDIR}/.cache/go-build,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    mkdir -p ${HOMEDIR}/out ; \
    go mod download ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/prometheus ./cmd/prometheus ; \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -tags "${GO_TAGS}" -mod=readonly -ldflags="${LD_FLAGS}" -o ${HOMEDIR}/out/promtool ./cmd/promtool ; \
    upx --best --lzma --exact ${HOMEDIR}/out/prometheus ${HOMEDIR}/out/promtool ; \
    go clean -cache

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/out/prometheus /usr/bin/prometheus
COPY --chown=0:0 --from=build ${HOMEDIR}/out/promtool /usr/bin/promtool
COPY --chown=0:0 --from=build ${HOMEDIR}/prometheus/documentation/examples/prometheus.yml /etc/prometheus/prometheus.yml

USER nonroot

ENTRYPOINT ["/usr/bin/prometheus"]
