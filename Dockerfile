ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:18a4aee97a270ad5e5296a63c8ac5569c7d1f320ca147dbd61fb6e24d2575e31 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:13e5b6b4655b1446937d10bf7d04d897dbe1fe0b4e938c137a8e11adc2d97573 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:62019a8b68ada85e07d9f8be01989d59d4c7c32d5a793f8466e7d0fabb9bfcdc AS pg12
FROM technowledgy/pg_dev:pg13@sha256:c6f69ec9b8524fe678ef4c952b4976f66bc03882904ad85b6d1aac3a6638c7f8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:18aaf1f9ab4c962097986fa51275e407d74154e57eb22614e5e14f73f199e6af AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:47953aef13c5ec94a626e0ab90cbfef842da96a612885ba8d91608516f03ef96 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:24fca3e7192f55699926d25abf65cbcb741d062a8b5e225c32785860fd9c554e AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.0.20221104@sha256:6efcded152e7751d3df22c22c1323cfdce48266da48e90ab1b0cfc1787d37884 AS pgrst11

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
