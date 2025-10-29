ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:926335fa29159e8bc7f8c91b7af52c119c0e4a9a8c0cba589109defd90d4b7a1 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:5ee11a68d7dcd70e3a9e26f410a893827702fd54b332ba99aa4059be848d812c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:1c10be354a8e85a806c1508c755fc4fb25a22293831ca3f7371980d15f10db4c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6fd8d25459b18acadf23bbe61c91aed4db9b03520ae976f285c786de67eba792 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:4980c3f9f6073e89e0498bd2e5547d36bb366f972e2b2bf9e300d1732adf4156 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:04d13f22b97daf4a45c33706cc7fc29b1a4ca256a4dfb46470e75796366dfa7b AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:a6c82d45fb76a3ce462bd6b32f28b84b6f80c005b6dbc2cb21d465a75144243f AS pgrstdevel

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
