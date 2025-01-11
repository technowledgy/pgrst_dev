ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:b08a3904d5b3469792c7e0b05c7491c650d8df4b92a581aba6e585c6b6cc3dda AS pg12
FROM technowledgy/pg_dev:pg13@sha256:6e8d8fbd073f2e6b054980218161c858f03d455a91673e864bd3201f1b49bd10 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:4b56d0d82c2a2abe4504b97f77413647c2310b0be91dfcfe117d358e595858a7 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e2d8ea2618b42e62d1d2815dd753da69c8e1d0393005a1aefcbc420aec7cc0d7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:78ef9a7c82817aa959f6d656b529cb00ffb66b68ef48e2dc085da14d3bc7f7db AS pg15
FROM technowledgy/pg_dev:pg16@sha256:8298e5ddd44b7eecbf76560b22ad9a77fabf305055ea133dc72ca2d26bd7a96d AS pg16

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
