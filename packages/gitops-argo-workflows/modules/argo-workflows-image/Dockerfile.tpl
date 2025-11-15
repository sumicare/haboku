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

{{ DockerfileBuildHeader "argo-workflows" "gitops-argo-workflows" }}

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
{{
DockerfileBuildGoBinaries 
"argo-workflows" 
"${HOMEDIR}/argo-workflows" 

"workflow-controller--./cmd/workflow-controller--"
"argo--./cmd/argo--"
"argoexec--./cmd/argoexec--"
}}
