ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:09ebd13c1ff29b581d4117f907492ce6b8ffebaa8166ccc16d6af0e7e83f6dd7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3d9c5d0eca99d4104f27de2d1e57f9a74096ae7e7d490f5f04b25c33b0eebe76 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:fcf6023c702179786d5fc0f225bd85ed630c8ec1c44bd3701ce21edeb11695c8 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:cd2b7af0f1bd73b75f40b0fcfc0500e4f63a502c84fba3cc4820a0a3eba52389 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e2e7b28bedca4fb2caa0eb08401769a34c1841fc8daeec60a0da2c90230650c4 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:9f588d5f87ce2e8bd57aa7d7a34fb7374301536a7924201fe14c02f59458a298 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:24477457b46b78864f108ef2ae966b3c839eaf21f13cd095e85ae46eb9c5ec2c AS pgrstdevel

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
