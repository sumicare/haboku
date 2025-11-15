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

ARG CALICO_VERSION="3.28.0"
ARG CALICO_REPO="https://github.com/projectcalico/calico.git"
ARG HOMEDIR=/build

ARG BUILDER_UID=10000
ARG BUILDER_GID=100

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${CALICO_REPO}#v${CALICO_VERSION} ${HOMEDIR}/calico

WORKDIR ${HOMEDIR}/calico


ARG LD_FLAGS="-s -w -extldflags '-static'"

ENV GOCACHE=${HOMEDIR}/.cache/go-build

RUN --mount=type=cache,id=go-vendor-${TARGETARCH},target=${HOMEDIR}/calico/cached-vendor,uid=${BUILDER_UID},gid=${BUILDER_GID},sharing=locked \
    set -eux ; \
    [ -z "$(ls -A cached-vendor)" ] && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    [ -n "$(ls -A cached-vendor)" ] && mkdir -p vendor && cp -r ${HOMEDIR}/cached-vendor/* vendor/ && go mod tidy && go mod vendor && cp -r vendor/* ${HOMEDIR}/cached-vendor/ ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../flexvol ./pod2daemon/flexvol/flexvoldriver.go ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../key-cert-provisioner ./key-cert-provisioner/cmd/main.go ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../calicoctl ./calicoctl/calicoctl/calicoctl.go ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../cni-install ./cni-plugin/cmd/install ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../cni-calico ./cni-plugin/cmd/calico ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../apiserver ./apiserver/cmd/apiserver ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../kube-controllers ./kube-controllers/cmd/kube-controllers ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../kube-controllers-wrapper ./kube-controllers/cmd/wrapper ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../check-status ./kube-controllers/cmd/check-status ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../dikastes ./app-policy/cmd/dikastes ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../healthz ./app-policy/cmd/healthz ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../typha ./typha/cmd/calico-typha ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../typha-client ./typha/cmd/typha-client ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../calico-node ./node/cmd/calico-node/main.go ; \
    GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -mod=vendor -ldflags="${LD_FLAGS}" -v -o ../mountns ./node/cmd/mountns ; \
    upx --best --lzma --exact ../flexvol ; \
    upx --best --lzma --exact ../key-cert-provisioner ; \
    upx --best --lzma --exact ../calicoctl ; \
    upx --best --lzma --exact ../cni-install ; \
    upx --best --lzma --exact ../cni-calico ; \
    upx --best --lzma --exact ../apiserver ; \
    upx --best --lzma --exact ../kube-controllers ; \
    upx --best --lzma --exact ../kube-controllers-wrapper ; \
    upx --best --lzma --exact ../check-status ; \
    upx --best --lzma --exact ../dikastes ; \
    upx --best --lzma --exact ../healthz ; \
    upx --best --lzma --exact ../typha ; \
    upx --best --lzma --exact ../typha-client ; \
    upx --best --lzma --exact ../calico-node ; \
    upx --best --lzma --exact ../mountns ; \
    go clean -cache -modcache ; \
    rm -rf vendor ; \
    rm -rf ${HOMEDIR}/.cache ; \
    rm -rf ${GOPATH}/pkg ${GOPATH}/src

FROM ${REPO}${ORG}/distroless:${DEBIAN_VERSION} AS distroless

ARG HOMEDIR=/build

COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../flexvol /usr/bin/../flexvol
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../key-cert-provisioner /usr/bin/../key-cert-provisioner
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../calicoctl /usr/bin/../calicoctl
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../cni-install /usr/bin/../cni-install
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../cni-calico /usr/bin/../cni-calico
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../apiserver /usr/bin/../apiserver
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../kube-controllers /usr/bin/../kube-controllers
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../kube-controllers-wrapper /usr/bin/../kube-controllers-wrapper
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../check-status /usr/bin/../check-status
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../dikastes /usr/bin/../dikastes
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../healthz /usr/bin/../healthz
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../typha /usr/bin/../typha
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../typha-client /usr/bin/../typha-client
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../calico-node /usr/bin/../calico-node
COPY --chown=0:0 --from=build ${HOMEDIR}/calico/../mountns /usr/bin/../mountns

USER nonroot

ENTRYPOINT ["/usr/bin/../flexvol"]