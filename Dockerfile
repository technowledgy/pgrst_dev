ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:d9e0e60612db4c9f7d5ba3c9b11fd1f53c39411bd74b28164c4b8c47d7c8767f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a9ec3ff56e3aea33061fb3738db4335f7e5dc763db36d907313681ac40469e38 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:2c572a6a769f2c5ffc8b295fb0b501fe0eddc724df17ddaad86f099cf8178708 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:c223880fcb4509501ba7c7eadbf361a8797515d0b3ab91d94c9542e85e6ce92e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8c5cedf851dbd92e0bfafefe73c60ffe228a4ce6833c6f9f27bb8540fc6cf7ed AS pg15
FROM technowledgy/pg_dev:pg16@sha256:b5807be6c4255c3a46a15c6b47717cf1e06491fb4e948ff3c70b4843388ec079 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:ef6215fbccfc64901fe16cdc3956854dda82d2c3c74c8dc862a22e46c1b3dc49 AS pgrstdevel

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
