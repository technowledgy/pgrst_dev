ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:7de7c831d168b1a885694b63064be6b0c7abba69136f6af29b1cf41d0bde5363 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:01da0e44e2a92bfdd0cb09651300998bbffb2af0a19189835d9544f1b84207a5 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:366cef66dd35e3c575ba0a9ae30cafe6e67d0b7e21deef49e4a34d9e1337ffe0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9b678a285b472ae249eae4d824b09178fea2adfe49475c6f4588a7c60d2db945 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8771ed69aba41324a7a092101d6e927ccbc4949b4cef7a11ae06c520c1fe0a97 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:d0053907c1d41d017d5afd7f9a63e6f74354090fe6b6a1b8e0e582ebf5953a7e AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:18376c0882f85697412906ed7c76789b9513a0c07c2b8aa41e6db9f4ced763e4 AS pgrstdevel

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
