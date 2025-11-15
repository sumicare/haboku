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

{{ DockerfileBuildHeader "volcano" "mlops-volcano" }}

ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${VOLCANO_REPO}#v${VOLCANO_VERSION} ${HOMEDIR}/volcano

WORKDIR ${HOMEDIR}/volcano

ARG LD_FLAGS="-s -w"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/volcano/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod vendor && cp -r vendor/* cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r cached-vendor/* vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=1 go build -mod=vendor -ldflags="${LD_FLAGS} -linkmode=external" -v -o vc-scheduler ./cmd/scheduler ;\
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS} -extldflags '-static'" -v -o vc-controller-manager ./cmd/controller-manager ;\
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS} -extldflags '-static'" -v -o vc-webhook-manager ./cmd/webhook-manager ;\
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS} -extldflags '-static'" -v -o vc-agent ./cmd/agent ;\
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS} -extldflags '-static'" -v -o network-qos ./cmd/network-qos ;\
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS} -extldflags '-static'" -v -o vcctl ./cmd/cli ;\
    upx --best --lzma --exact vc-scheduler ; \
    upx --best --lzma --exact vc-controller-manager ; \
    upx --best --lzma --exact vc-webhook-manager ; \
    upx --best --lzma --exact vc-agent ; \
    upx --best --lzma --exact network-qos ; \
    upx --best --lzma --exact vcctl ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src  

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/volcano/vc-scheduler /usr/bin/vc-scheduler
COPY --chown=0:0 --from=build ${HOMEDIR}/volcano/vc-controller-manager /usr/bin/vc-controller-manager
COPY --chown=0:0 --from=build ${HOMEDIR}/volcano/vc-webhook-manager /usr/bin/vc-webhook-manager
COPY --chown=0:0 --from=build ${HOMEDIR}/volcano/vc-agent /usr/bin/vc-agent
COPY --chown=0:0 --from=build ${HOMEDIR}/volcano/network-qos /usr/bin/network-qos
COPY --chown=0:0 --from=build ${HOMEDIR}/volcano/vcctl /usr/bin/vcctl

ENTRYPOINT ["/usr/bin/vc-controller-manager"]
