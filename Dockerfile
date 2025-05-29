ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:1cd63a7c001753fd25c6513896b7be4a78cc311af6ec645ff725d33d7f72a5c7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3790860df0fa855801760218e4e5c6ba7dca61475828768ca47184417e5caa66 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d01f809bd41ac62ecbd6d46658a6279db96ef10af7e09e4c397ef888f03ea4f2 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:109d3536bdffaea19c2aba5a9f7637d1fcef0ae98e0fd27b0334877e209b785e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c0fadb0fce53f25adfb5aa0908995a37a5ef1d9fa4297c888fac4da7282dcad6 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:2f7db7aec3af11c0daf658b34cf46f6f3edad7541798a0a0dfb1f70a9a4d2e0d AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:422750d514f8130be2f799e02bd48ff9e09d62cd219705abf3114d942bab47d6 AS pgrstdevel

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
