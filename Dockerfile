ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:a02ef6b0e8cb779dbbdc11e0ac50841bbcdf418382bf8fab539fa3f74f275ac2 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:fdab0c0cdcf48ec8a86a4a18b242e5781ae0ea5076b2d8288dc12815aaa890a4 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:9b7b0770cc0ab883c32e0e720a2703b3ea1745cfadd569612649c602ee079c77 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:fa1a9e3b437f4a7a983e14fef45ef09437bc1c639eb182cc4e21e132d5735399 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:f5e4ea645ec0893b340a426a64dde17ba3cdaa6c4e5964afbbfcbfc70af0fc0a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:250680c77bfe5a194077b9d52e9d463c80b9867b3d3f553568f4b0e4e42609f7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f031b8941ed5bb6ca6e0408407767d1ca690bf858207cc6cf3097f23a7f0a5e0 AS pg15

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
