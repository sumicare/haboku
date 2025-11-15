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

ARG BUILDKIT_SBOM_SCAN_CONTEXT=true
ARG BUILDKIT_SBOM_SCAN_STAGE=true
ARG DEBIAN_VERSION="{{index .Versions "debian"}}"
ARG REPO="docker.io/"
ARG ORG="sumicare"

# Build stage for PostgreSQL and extensions
FROM ${REPO}${ORG}/base:${DEBIAN_VERSION} AS build

ARG TARGETARCH

ARG POSTGRES_VERSION="{{index .Versions "storage-postgres"}}"
ARG POSTGRES_REPO="https://github.com/postgres/postgres.git"

ARG HYPOPG_VERSION="{{index .Versions "storage-postgres-hypopg"}}"
ARG HYPOPG_REPO="https://github.com/HypoPG/hypopg.git"

ARG INDEX_ADVISOR_VERSION="{{index .Versions "storage-postgres-index-advisor"}}"
ARG INDEX_ADVISOR_REPO="https://github.com/supabase/index_advisor.git"

ARG PG_REPACK_VERSION="{{index .Versions "storage-postgres-pg-repack"}}"
ARG PG_REPACK_REPO="https://github.com/reorg/pg_repack.git"

ARG PGAUDIT_VERSION="{{index .Versions "storage-postgres-pgaudit"}}"
ARG PGAUDIT_REPO="https://github.com/pgaudit/pgaudit.git"

ARG PGMQ_VERSION="{{index .Versions "storage-postgres-pgmq"}}"
ARG PGMQ_REPO="https://github.com/pgmq/pgmq.git"

ARG PGROONGA_VERSION="{{index .Versions "storage-postgres-pgroonga"}}"
ARG PGROONGA_REPO="https://github.com/pgroonga/pgroonga.git"

ARG PGROUTING_VERSION="{{index .Versions "storage-postgres-pgrouting"}}"
ARG PGROUTING_REPO="https://github.com/pgRouting/pgrouting.git"

ARG PGVECTOR_VERSION="{{index .Versions "storage-postgres-pgvector"}}"
ARG PGVECTOR_REPO="https://github.com/pgvector/pgvector.git"

ARG PGX_ULID_VERSION="{{index .Versions "storage-postgres-pgx-ulid"}}"
ARG PGX_ULID_REPO="https://github.com/pksunkara/pgx_ulid.git"

ARG RUM_VERSION="{{index .Versions "storage-postgres-rum"}}"
ARG RUM_REPO="https://github.com/postgrespro/rum.git"

ARG HOMEDIR=/build
ARG BUILDER_UID=10000
ARG BUILDER_GID=100

WORKDIR ${HOMEDIR}

# Install build dependencies
RUN --mount=type=cache,id=cache-apt-${TARGETARCH},target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=lib-apt-${TARGETARCH},target=/var/lib/apt,sharing=locked \
    set -eux ; \
    apt-get update -y ; \
    apt-get install -y --no-install-recommends --no-install-suggests \
    build-essential \
    bison \
    flex \
    libreadline-dev \
    zlib1g-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libicu-dev \
    libkrb5-dev \
    libldap2-dev \
    libpam0g-dev \
    libsystemd-dev \
    liblz4-dev \
    libzstd-dev \
    uuid-dev \
    pkg-config \
    python3-dev \
    tcl-dev \
    perl \
    gettext \
    cmake \
    libboost-graph-dev \
    libcgal-dev \
    groonga-dev \
    libgroonga-dev \
    libmsgpack-dev \
    cargo \
    rustc \
    git \
    curl \
    ca-certificates ; \
    rm -rf /var/lib/apt/lists/*

# Build PostgreSQL
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${POSTGRES_REPO}#REL_${POSTGRES_VERSION}_STABLE ${HOMEDIR}/postgres

WORKDIR ${HOMEDIR}/postgres

RUN set -eux ; \
    ./configure \
    --prefix=/usr/local/pgsql \
    --with-openssl \
    --with-libxml \
    --with-libxslt \
    --with-icu \
    --with-gssapi \
    --with-ldap \
    --with-pam \
    --with-systemd \
    --with-lz4 \
    --with-zstd \
    --with-uuid=e2fs \
    --with-python \
    --with-tcl \
    --with-perl \
    --enable-nls ; \
    make -j$(nproc) world ; \
    make install-world

ENV PATH="/usr/local/pgsql/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/pgsql/lib:$LD_LIBRARY_PATH"

WORKDIR ${HOMEDIR}

# Build pgvector
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PGVECTOR_REPO}#v${PGVECTOR_VERSION} ${HOMEDIR}/pgvector

RUN set -eux ; \
    cd ${HOMEDIR}/pgvector ; \
    make -j$(nproc) ; \
    make install

# Build HypoPG
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${HYPOPG_REPO}#${HYPOPG_VERSION} ${HOMEDIR}/hypopg

RUN set -eux ; \
    cd ${HOMEDIR}/hypopg ; \
    make -j$(nproc) ; \
    make install

# Build index_advisor
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${INDEX_ADVISOR_REPO}#v${INDEX_ADVISOR_VERSION} ${HOMEDIR}/index_advisor

RUN set -eux ; \
    cd ${HOMEDIR}/index_advisor ; \
    make -j$(nproc) ; \
    make install

# Build pg_repack
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PG_REPACK_REPO}#ver_${PG_REPACK_VERSION} ${HOMEDIR}/pg_repack

RUN set -eux ; \
    cd ${HOMEDIR}/pg_repack ; \
    make -j$(nproc) ; \
    make install

# Build pgaudit
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PGAUDIT_REPO}#${PGAUDIT_VERSION} ${HOMEDIR}/pgaudit

RUN set -eux ; \
    cd ${HOMEDIR}/pgaudit ; \
    make -j$(nproc) USE_PGXS=1 ; \
    make install USE_PGXS=1

# Build pgmq
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PGMQ_REPO}#v${PGMQ_VERSION} ${HOMEDIR}/pgmq

RUN set -eux ; \
    cd ${HOMEDIR}/pgmq/pgmq-extension ; \
    make -j$(nproc) ; \
    make install

# Build PGroonga
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PGROONGA_REPO}#${PGROONGA_VERSION} ${HOMEDIR}/pgroonga

RUN set -eux ; \
    cd ${HOMEDIR}/pgroonga ; \
    make -j$(nproc) ; \
    make install

# Build pgRouting
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PGROUTING_REPO}#v${PGROUTING_VERSION} ${HOMEDIR}/pgrouting

RUN set -eux ; \
    cd ${HOMEDIR}/pgrouting ; \
    mkdir build ; \
    cd build ; \
    cmake .. ; \
    make -j$(nproc) ; \
    make install

# Build RUM
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${RUM_REPO}#${RUM_VERSION} ${HOMEDIR}/rum

RUN set -eux ; \
    cd ${HOMEDIR}/rum ; \
    make -j$(nproc) USE_PGXS=1 ; \
    make install USE_PGXS=1

# Build pgx_ulid (Rust extension)
#checkov:skip=CKV_DOCKER_4:it's a remote git repo
ADD --chown=${BUILDER_UID}:${BUILDER_GID} --keep-git-dir=false ${PGX_ULID_REPO}#v${PGX_ULID_VERSION} ${HOMEDIR}/pgx_ulid

RUN --mount=type=cache,id=cargo-${TARGETARCH},target=/root/.cargo/registry,sharing=locked \
    set -eux ; \
    cargo install --locked cargo-pgrx ; \
    cd ${HOMEDIR}/pgx_ulid ; \
    cargo pgrx init --pg18=/usr/local/pgsql/bin/pg_config ; \
    cargo pgrx install --release

# Runtime stage
FROM ${REPO}${ORG}/base:${DEBIAN_VERSION} AS runtime

ARG TARGETARCH

# Install runtime dependencies
RUN --mount=type=cache,id=cache-apt-${TARGETARCH},target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=lib-apt-${TARGETARCH},target=/var/lib/apt,sharing=locked \
    set -eux ; \
    apt-get update -y ; \
    apt-get install -y --no-install-recommends --no-install-suggests \
    libreadline8 \
    zlib1g \
    libssl3 \
    libxml2 \
    libxslt1.1 \
    libicu72 \
    libkrb5-3 \
    libldap-2.5-0 \
    libpam0g \
    libsystemd0 \
    liblz4-1 \
    libzstd1 \
    libuuid1 \
    python3 \
    tcl \
    perl \
    libboost-graph1.83.0 \
    libgroonga0 \
    libmsgpackc2 \
    locales ; \
    rm -rf /var/lib/apt/lists/* ; \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# Copy PostgreSQL installation
COPY --from=build /usr/local/pgsql /usr/local/pgsql

# Copy Groonga libraries for PGroonga
COPY --from=build /usr/lib/*-linux-gnu/groonga /usr/lib/groonga

ENV PATH="/usr/local/pgsql/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/pgsql/lib:$LD_LIBRARY_PATH"
ENV PGDATA="/var/lib/postgresql/data"

RUN set -eux ; \
    groupadd -r postgres --gid=999 ; \
    useradd -r -g postgres --uid=999 --home-dir=/var/lib/postgresql --shell=/bin/bash postgres ; \
    mkdir -p /var/lib/postgresql/data ; \
    chown -R postgres:postgres /var/lib/postgresql ; \
    mkdir -p /var/run/postgresql ; \
    chown -R postgres:postgres /var/run/postgresql ; \
    chmod 2777 /var/run/postgresql

USER postgres

VOLUME /var/lib/postgresql/data

EXPOSE 5432

ENTRYPOINT ["postgres"]
CMD ["-D", "/var/lib/postgresql/data"]
