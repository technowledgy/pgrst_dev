ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:8c9fc18f6092e201bd70f7e25c0a13a9355d6420ea3607a697b5c56c25ebe656 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:1c4709b70e2785e279fa82cf764a4ace36f8059ecb464e66257e6470550cff45 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:d8d6e2d287f88d907ad72d954e0261108ea0cd4066484ce21bfeb26c5eecf6aa AS pg12
FROM technowledgy/pg_dev:pg13@sha256:454dc2c2da7dad72ff8c3e4703a5638e283962e7be92bd80ab079ada41fe2827 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:41925da0dba8ff368b920d8b74b37ec603ffbabd8939642055e2e0fcf254bef6 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:cff4dfb78a3e4d4581e3283c7ee2362681662696b0d44bef800a6df5c7e8a4ab AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d90c497175fbf7f9574dd8df71ec3f0b47ffa4bde7bab8354e9836e4c77a35e1 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.2@sha256:058d34b648f80f7782e1e062df13eb9b541825b38a6b521f3848af86c85be26b AS pgrst10
FROM postgrest/postgrest:v10.2.0.20230407@sha256:e843f6e2ed340a0944669cb6907ff321b4b804c4660c4cf0cab7fc947bae077b AS pgrst11

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
