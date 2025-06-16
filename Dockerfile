ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:28501c7f389ac36d0954f84dc9d34860bb3a26bcbae5c6a5c0264f1af9362597 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:547530736ec5abd6b1fb47e125f819a07650d0c3229b15417403e96612cefb3b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c6975fd30c5a2bfcafd2ef933a681be22dec2bf81315d5ee6230a4e8a98acf33 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6af015a52b4dd51fea621392e64d76d7067cffde7f04330a763343c98ba4a98f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8f5ee780b3f311f9bf4953a0f52ba0c52f1cefe3fec2601559b33016d25ff691 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:24d68d510e4f05a2e61de23ee5e3848b9354275189cbfeca1ac38d6428431f52 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:6b245dfb2dba45177b389dcc84d293f786604d7c91e346212dcb4f3c3ecc6212 AS pgrstdevel

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
