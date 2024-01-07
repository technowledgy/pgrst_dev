ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:b2d9b97b94909625151059c6e0d22ee21c75f1766afd492411b79a9ec5bd1af7 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:e577172ffa1fe3c2de5020fef9ab42a093b3e6d9d77b7512a35c848b3f0b24ae AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6a2d78fd3c6a4993c0d66f0f71d07783b810796421f4ee9eb96375098de94a0e AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9d07900e2fea3b9304a064eb4ba764ba6f0363c6403299452dbf26f3045191ab AS pg13
FROM technowledgy/pg_dev:pg14@sha256:ac8448894206064def80fccf1083ca67cbecf7e2c3e706db2104bf53568bafa5 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:31a4ae1ae6aad8d75286d375efb7ff864b6c4c4f13004c16cfea17e9e7d20bb7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6f7ab484665c7c8f39a89c3b72c8d7845b45516611917b9c3fa3c3e5ce040e19 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11

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
