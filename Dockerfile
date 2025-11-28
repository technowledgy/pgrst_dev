ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:4f78064a155782bfca25f59d1a63b20d2171c6e6c8ee20e1430f09367290f9b0 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:1007e3fc27543c0391a507db42c18d5d9566281669c7f012508b3ef1fe7972a1 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d5a080e57811e8050d438ea5f2105c82c32c2e753d704255d8e55db16a72dce3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:80b48356fc2fb2450ef4cf5e7b66026d9a711d9466a3cca16ab5a0aaff412786 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9cdcf47d0391d944571e823b9d8c7f744ba05b5f2feec46d38b4f7c4b9f2f43a AS pg15
FROM technowledgy/pg_dev:pg16@sha256:8ed0222fade1c7cad3923f299c8fc050960992ef4381d5a7e28e28ef0e6aa2af AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:75fb820872a1a45e5473af734c2ad1987b65de19c98860822f5e93d5681f356c AS pgrstdevel

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
