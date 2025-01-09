ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:e4d22e4157727742afdfcf487f20863eadd93cb827221854a5c195aa5a98d620 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:f9456674c441cafb3f31d615d6525283afb1bf3c320d38b34dc1dcc1fb7c7ae7 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9b7d284f1edbe7212f9ccbc6c5cb46cf8bfceeed3cdf45d91e919ed6a05396a1 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9982ecf12cb7db4a7f49d056dfa819ec80a8b087237263fa16e6aa1755b835eb AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c8b7d85598be809d9b74c1465cd276cb1d3c3b509083896899680bd572fb131c AS pg15
FROM technowledgy/pg_dev:pg16@sha256:c65cd12bd372358b6ddba5afc01f6a952abdff457d079cce1dc3d8fc886e3f02 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:abfadff103fa4135ed1e4b87ef8c7182e01d7ea3528b0bc3cd33a9d2e1cf8367 AS pgrstdevel

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
