ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:d523f27957482aaff0bd67f570e37a953be2549b426da5032e1da5664d62f250 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4679732d83f56bec6393b19fa2692b5373c733bf7b40956786b59549b8250b81 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c1cd7e0a27f48422f8a5663992baed0d4779654c25a0ab5bc95f2ee2b99bb0da AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:8cd4f35c35d4815c39e6a5cab29475f8989062ff6a188c0729306561861a9429 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:dfe9f2fba7bd967707c912a045c7abd28ab03330e35b6821718763f58e6b7484 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:07e8615dcee322b815366dd72933f1da51266bdfbe495f0979aaa554b603a9ec AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:d90942f7b5fe79c8190565b648e35f12b3578882c19a8eb3059af03a4ad9ff99 AS pgrstdevel

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
