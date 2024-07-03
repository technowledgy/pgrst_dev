ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:492f490680fdb23496731f6675f2e539e5eb0a2ca4b773b07ba36be34aa3ba10 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9dd7f2b2cc22fe2f2610ebb84f414d28771b86137124670d4a90b61ac193c15a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9fc0ed2c0b6d3af2dce337e62edd87bc5a59dbc9e3a466937c44fc2becffc5cd AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:337e23bd15ff8ce3f9b6d8517fef3ed8001422f29738e117848ce2f1a15ef01c AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:50f872b7d6aa228ceb68c6b7c7e13200b5f986e3e925f0f010eb08e4a45fbb03 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:b67874b2eaf1bdfa67f1a9074519bb0b715ef777319095517e79f47839e4a7e1 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.1@sha256:7991389d194ddbba3dffd551682601784cbb1650a815ad9d6caaaf07b094458e AS pgrst12

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
