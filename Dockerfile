ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:22c7b549bae725d575c34e7dabfd5bde66fb0fc614f794f19b63f0e0a7b42149 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:0fa248512ea35b98b31ca313f31ad7054cf56c52a36453f40ffb864dec406dc1 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:7b8a2235abe45149a711d837ea433bdb3cb1b728a340504c2760799a551eae39 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f845ea27d579cfe795d1fa837d2d1ac7108375f69dd406ade78dbe6d434434e9 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c21061c9bb08c8b613f0067ab777a92f7800888cb5b65d1a83f8cb29fb48e203 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:421f3a1fbca1a9155effc7e2351c84a9cb6cd6beb3a8cac214c7c2d762129866 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:9404264648dec26e7581f8dbcc0ccaa0d9c907f11896de3c3d7d12c2735d1aba AS pgrstdevel

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
