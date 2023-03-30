ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:77de3588efb047950653fa7e413a2ed56b9ea9399bb2557f6ddb8a1a02746579 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:b473d11857d3a4174a205e3f953867b7eb7765fbb4b950ac739e31a06ed1bdb1 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:45f9ab435ad702c0b2cec8bd35e1f62a334371b47fef3b2fa7ac197e46a54523 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:2cff41624957e26be27adaf002b9aed57ece233192da897696d45a710f371c90 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9785e0e2cf5a1a82e5d89d5d3e69a471c30e4c280e02e644dc025a79d2384364 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:360d033bdc0526ca1d5f544829ead7e195647bc73a9ea451a8ff3aafd21d30ca AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e5445c35bb22995b5839f2336f4427158400d03f2da7660110eedf875fd7e287 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.2@sha256:058d34b648f80f7782e1e062df13eb9b541825b38a6b521f3848af86c85be26b AS pgrst10
FROM postgrest/postgrest:v10.2.0.20230209@sha256:cedfaa2cdad6492d8f757cdfb989e65e115f5b61a97c184909dca53d8c5b26a6 AS pgrst11

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
