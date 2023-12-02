ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:bec627f674c83c3e3d4baba3006b47ca1fcc35acb8c0a16cae6df91528816ddf AS pg10
FROM technowledgy/pg_dev:pg11@sha256:892a1c4046f75df5fb05bff475e61f581a858555f469ee2005b681a62da00661 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6e8a87c8c26a8a14b8caf0a175640417b78689450bee650cd3af94392fa297dd AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a67ca71e64272f7d4dafffbad9749d5cb1c2d97a6659b77680f665bc18373638 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c6bccfcb719af46c7b7672c215ee04c035507a99b5d48a5515c45b2a9f7ffada AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d95d564c5836cd0b97995e06f3a57186178e8a87cc9986c2a68a8dc1b6a84af9 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9d39923a395bed75cd47970079853b2c8b843d2aa983404f74445012c2e05403 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11

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
