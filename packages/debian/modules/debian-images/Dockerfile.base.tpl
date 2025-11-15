# syntax=docker/dockerfile:1
# escape=\

{{ DockerfileHeader }}

FROM docker.io/debian:${DEBIAN_VERSION} AS base

ARG TARGETARCH

ENV LANG='C.UTF-8' \
    LC_ALL='C.UTF-8' \
    LANGUAGE='C' \
    TZ='UTC' \
    DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/apt/apt.conf.d/docker-clean ; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,id=cache-apt-${TARGETARCH},target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=lib-apt-${TARGETARCH},target=/var/lib/apt,sharing=locked \
    set -eux ; \
    apt-get update -y ; \
    apt-get upgrade -y ; \
    apt-get install -y --no-install-recommends --no-install-suggests bash curl openssl ca-certificates locales tzdata media-types ; \
    echo $TZ > /etc/timezone ; \
    cp "/usr/share/zoneinfo/${TZ}" /etc/localtime || true ; \
    echo "$LANG UTF-8" >> /etc/locale.gen ; \
    echo "sumicare" > /etc/hostname ; \
    locale-gen $LANG; \
    update-locale LC_CTYPE=$LANG ; \
    update-locale LANG=$LANG ; \
    update-locale LC_ALL=$LC_ALL ; \
    update-locale LANGUAGE=$LANGUAGE ; \
    dpkg-reconfigure locales ;\
    apt-get purge -y --auto-remove ; \
    find /usr -name '*.pyc' -type f -exec bash -c 'for pyc; do dpkg -S "$pyc" &> /dev/null || rm -vf "$pyc"; done' -- '{}' + ; \
    rm -rf /var/lib/apt/lists/*
