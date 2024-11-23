ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:e8be4fdb28ac02282a3ec60d7c968175cd7e2b1632eab08e7aff23b7fa85ba42 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d888e74f7e25bf49d4433255dfb3acdd0ecbfd504d58e43a41bdc10793757907 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9e4685d41b206818c56182927ba3944051393d8be0090f60798c52f85f2641e1 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e36c98dee3687a8756544aa058ad1d05a3ed0c25f16d2b07eeb9ca018921c2cd AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:82d856e649d879478a241be0b5380165a04adba1f8e8b893b75a370a3efe0b8d AS pg15
FROM technowledgy/pg_dev:pg16@sha256:b3866ccf8aab05f789c0c6b7f59f09f313454d0d7ea1d966c5bfba99573a45b4 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:f9c262da9d632b94125f494c55ccb37dc692ef573a1e1f624a6fd2a4cf96f97d AS pgrstdevel

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
