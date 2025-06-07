ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:d5c56626067bae6c7c5265c9339d6c4d339acdd783daba8644c3934e92bd54f9 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:007dbc7d7d8c06c317c69b648c0a2c34be1ffbcc457c0377459240549d1d89d9 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:97871bd7f9f18ce372cf7b55a28d86d773c25fbc347601950213ba76126b4d56 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:871df9eb48e220d96b04f37d6244443c80ac28236d06a341e0b5484f9850fba4 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3b7c77f1f34e8328b8b187e58acde4e114c920602d0ab0e59922a07fcab38115 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:030c7d3bb4be9a4d4f6e43ed4b7b325b7ce1e6af917146238b43fccf04962b43 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:77408e575df1de88374d15f755cc846741d5d67cb0c70e87f191b390858acd51 AS pgrstdevel

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
