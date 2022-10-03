ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:29f88b985f73fce379b7618bbf173efc410ba662578f8fb4fd6b38b4c6b8cebe AS pg10
FROM technowledgy/pg_dev:pg11@sha256:0f8b82191100ce9474d244bc4534d5f1b1031a44aa0f448228a154e27a3c0aec AS pg11
FROM technowledgy/pg_dev:pg12@sha256:c6228d8661a5136578c70a08e0c5095e0989ca2f8b2ac6e83a85f784b892b02c AS pg12
FROM technowledgy/pg_dev:pg13@sha256:5f9eec4a3d4a8214afe33d03a5525abfd6984724eb5d3b65e1b1756a883e57d4 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:56962b65227cdd9132821a5a9d0be1c3d519d613c09eaa52a1d8014501c3cc24 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:bdd4687c84c77007cc3648125c485646905eddb1f947473b28add108b4daa11f AS pg14-invoker

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:db9dd042f5a4f7528b09723e08434b1ffadabeec8079e33ff38ebd8273177100 AS pgrst10

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL org.opencontainers.image.authors Wolfgang Walther
LABEL org.opencontainers.image.source https://github.com/technowledgy/pgrst_dev
LABEL org.opencontainers.image.licences MIT

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
