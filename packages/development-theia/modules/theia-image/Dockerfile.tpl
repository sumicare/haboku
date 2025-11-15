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

{{ DockerfileHeader }}

# Comprehensive Theia standalone image combining:
# - Theia IDE (browser application from eclipse-theia/theia-ide)
# - Theia Cloud components (operator, service, conversion-webhook, landing-page)
#
# Sources:
# - https://github.com/eclipse-theia/theia-ide
# - https://github.com/eclipse-theia/theia-cloud

ARG THEIA_IDE_VERSION="{{ Version "development-theia-ide" }}"
ARG THEIA_IDE_REPO="{{ Repo "development-theia-ide" }}"
ARG THEIA_CLOUD_VERSION="{{ Version "development-theia-cloud" }}"
ARG THEIA_CLOUD_REPO="{{ Repo "development-theia-cloud" }}"

# =============================================================================
# Stage 1: Build Theia IDE (browser application)
# Based on: https://github.com/eclipse-theia/theia-ide/blob/master/browser.Dockerfile
# =============================================================================
FROM node:22-bullseye AS theia-ide-builder

RUN apt-get update && apt-get install -y libxkbfile-dev libsecret-1-dev && rm -rf /var/lib/apt/lists/*

ARG THEIA_IDE_VERSION
ARG THEIA_IDE_REPO

WORKDIR /home/theia

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --keep-git-dir=false ${THEIA_IDE_REPO}#${THEIA_IDE_VERSION} /home/theia

RUN --mount=type=cache,id=yarn-theia-ide,target=/usr/local/share/.cache/yarn,sharing=locked \
    set -eux ; \
    yarn config set network-timeout 600000 -g ; \
    yarn --pure-lockfile ; \
    yarn build:extensions ; \
    yarn download:plugins ; \
    yarn browser build ; \
    yarn ; \
    yarn autoclean --init ; \
    echo "*.ts" >> .yarnclean ; \
    echo "*.ts.map" >> .yarnclean ; \
    echo "*.spec.*" >> .yarnclean ; \
    yarn autoclean --force ; \
    yarn cache clean ; \
    rm -rf .git applications/electron theia-extensions/launcher theia-extensions/updater node_modules

# =============================================================================
# Stage 2: Build Theia Cloud Java components (operator, service, conversion-webhook)
# =============================================================================
FROM eclipse-temurin:21-jdk AS java-builder

RUN apt-get update && apt-get install -y maven git && rm -rf /var/lib/apt/lists/*

ARG THEIA_CLOUD_VERSION
ARG THEIA_CLOUD_REPO

WORKDIR /build

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --keep-git-dir=false ${THEIA_CLOUD_REPO}#v${THEIA_CLOUD_VERSION} /build/theia-cloud

WORKDIR /build/theia-cloud

# Build common modules first
RUN --mount=type=cache,id=maven-cache,target=/root/.m2,sharing=locked \
    set -eux ; \
    cd java/common/maven-conf && mvn clean install --no-transfer-progress ; \
    cd ../org.eclipse.theia.cloud.common && mvn clean install --no-transfer-progress

# Build operator
RUN --mount=type=cache,id=maven-cache,target=/root/.m2,sharing=locked \
    set -eux ; \
    cd java/operator/org.eclipse.theia.cloud.operator && mvn clean install --no-transfer-progress ; \
    cd ../org.eclipse.theia.cloud.defaultoperator && mvn clean verify --no-transfer-progress

# Build service
RUN --mount=type=cache,id=maven-cache,target=/root/.m2,sharing=locked \
    set -eux ; \
    cd java/service/org.eclipse.theia.cloud.service && mvn clean package -Dmaven.test.skip=true -Dquarkus.package.type=uber-jar --no-transfer-progress

# Build conversion webhook
RUN --mount=type=cache,id=maven-cache,target=/root/.m2,sharing=locked \
    set -eux ; \
    cd java/conversion/org.eclipse.theia.cloud.conversion && mvn clean package -Dmaven.test.skip=true -Dquarkus.package.type=uber-jar --no-transfer-progress

# =============================================================================
# Stage 3: Build Theia Cloud landing page (Node.js)
# =============================================================================
FROM node:20-alpine AS landing-page-builder

ARG THEIA_CLOUD_VERSION
ARG THEIA_CLOUD_REPO

WORKDIR /build

#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --keep-git-dir=false ${THEIA_CLOUD_REPO}#v${THEIA_CLOUD_VERSION} /build/theia-cloud

WORKDIR /build/theia-cloud/node

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    set -eux ; \
    npm ci ; \
    npm run build -w common ; \
    npm run build -w landing-page ; \
    chmod 644 /build/theia-cloud/node/landing-page/dist/favicon.ico

# =============================================================================
# Stage 4: Final runtime image (Theia IDE + Cloud components)
# =============================================================================
FROM node:22-bullseye-slim AS runtime

# Create theia user and directories
RUN adduser --system --group theia && \
    chmod g+rw /home && \
    mkdir -p /home/project /templates /log-config /operator /service /conversion /landing-page && \
    chown -R theia:theia /home/theia /home/project

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    git openssh-client openssh-server bash libsecret-1-0 \
    openjdk-17-jre-headless \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV HOME=/home/theia
WORKDIR /home/theia

# Copy Theia IDE application
COPY --from=theia-ide-builder --chown=theia:theia /home/theia /home/theia

# Copy Theia Cloud operator
COPY --from=java-builder /build/theia-cloud/java/operator/org.eclipse.theia.cloud.defaultoperator/target/defaultoperator-*-jar-with-dependencies.jar /operator/operator.jar
COPY --from=java-builder /build/theia-cloud/java/operator/org.eclipse.theia.cloud.defaultoperator/log4j2.xml /log-config/

# Copy Theia Cloud service
COPY --from=java-builder /build/theia-cloud/java/service/org.eclipse.theia.cloud.service/target/service-*-runner.jar /service/service.jar

# Copy Theia Cloud conversion webhook
COPY --from=java-builder /build/theia-cloud/java/conversion/org.eclipse.theia.cloud.conversion/target/conversion-webhook-*-runner.jar /conversion/conversion-webhook.jar

# Copy Theia Cloud landing page
COPY --from=landing-page-builder /build/theia-cloud/node/landing-page/dist /landing-page/

# Environment variables
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins \
    USE_LOCAL_GIT=true \
    SERVICE_AUTH_TOKEN=default-app-id \
    SERVICE_PORT=8081 \
    KEYCLOAK_ENABLE=true \
    KEYCLOAK_SERVERURL=https://keycloak.url/auth/realms/TheiaCloud \
    KEYCLOAK_CLIENTID=theia-cloud \
    KEYCLOAK_CLIENTSECRET=publicbutoauth2proxywantsasecret \
    KEYCLOAK_ADMIN_GROUP=theia-cloud/admin \
    CERT_RELOAD_PERIOD=604800 \
    THEIA_MINI_BROWSER_HOST_PATTERN="{{ "{{hostname}}" }}" \
    THEIA_WEBVIEW_ENDPOINT="{{ "{{hostname}}" }}"

# Create entrypoint script supporting all modes
RUN printf '#!/bin/bash\ncase "$1" in\n  ide|theia)\n    cd /home/theia/applications/browser\n    exec node /home/theia/applications/browser/lib/backend/main.js "${@:2:-/home/project --hostname=0.0.0.0}"\n    ;;\n  operator)\n    exec java -Dlog4j2.configurationFile=/log-config/log4j2.xml -jar /operator/operator.jar "${@:2}"\n    ;;\n  service)\n    exec java \\\n      -Dtheia.cloud.service.auth.token=${SERVICE_AUTH_TOKEN} \\\n      -Dquarkus.http.port=${SERVICE_PORT} \\\n      -Dtheia.cloud.auth.admin.group=${KEYCLOAK_ADMIN_GROUP} \\\n      -Dtheia.cloud.use.keycloak=${KEYCLOAK_ENABLE} \\\n      -Dquarkus.oidc.auth-server-url=${KEYCLOAK_SERVERURL} \\\n      -Dquarkus.oidc.client-id=${KEYCLOAK_CLIENTID} \\\n      -Dquarkus.oidc.credentials.secret=${KEYCLOAK_CLIENTSECRET} \\\n      -jar /service/service.jar "${@:2}"\n    ;;\n  conversion-webhook)\n    exec java -Dquarkus.http.ssl.certificate.reload-period=${CERT_RELOAD_PERIOD} -jar /conversion/conversion-webhook.jar "${@:2}"\n    ;;\n  *)\n    echo "Theia Cloud Standalone Image"\n    echo "Usage: $0 {ide|operator|service|conversion-webhook}"\n    echo ""\n    echo "Modes:"\n    echo "  ide                 - Run Theia IDE (browser application on port 3000)"\n    echo "  operator            - Run Theia Cloud operator"\n    echo "  service             - Run Theia Cloud service API"\n    echo "  conversion-webhook  - Run CRD conversion webhook"\n    exit 1\n    ;;\nesac\n' > /entrypoint.sh && chmod +x /entrypoint.sh

# Expose ports
EXPOSE 3000 8081

USER theia
WORKDIR /home/theia/applications/browser

ENTRYPOINT ["/entrypoint.sh"]
CMD ["ide"]