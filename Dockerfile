ARG PG_MAJOR=14
ARG PGRST_MAJOR=9

FROM technowledgy/pg_dev:pg10@sha256:75af7a5bbeee3f72028f5ea13864836ce1ccf14c479a28697d5db45aee8b34e5 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:a3fe7ea0a2df6ed4d134d632e8f2827be88e6dbff09c251bc3f46f07b9af1bf2 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:cd8ff44548b6093a72d09638eaf0a2e28288b5fe0fdb346583ef3aa0ad067353 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4b666021f7d71f3634125d1899660113cc5799b07b0f9e646c059c5cdc073eac AS pg13
FROM technowledgy/pg_dev:pg14@sha256:1d625135b8e0f891262a2c15b3c740c5c42b5b1a5be4b3168dbdf833cc9be852 AS pg14

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL author Wolfgang Walther
LABEL maintainer opensource@technowledgy.de
LABEL license MIT

WORKDIR /usr/src
SHELL ["/bin/sh", "-eux", "-c"]

COPY --from=postgrest /bin/postgrest /bin
COPY tools /bin

RUN apk add \
        --no-cache \
        curl

EXPOSE 3000

FROM base AS test

RUN apk add \
        --no-cache \
        ncurses \
        yarn \
  ; yarn global add \
         bats \
         bats-assert \
         bats-support

FROM base
