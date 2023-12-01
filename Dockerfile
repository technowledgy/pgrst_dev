ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:35ac1bc305d4197daf66c818b243c8dd226f79574fc89ef00c2eb537c56399f2 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:da6d2da48b4a6bba628fbe0726d5c3b0e7fa692c29e5d4b1396304d4b3cb8235 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:b64398520f9e5d191beea8546c16108b7107953675d33e49e14ebfb9f3d25c51 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:6f30b79beb4cd788f266e1ec8fbd8074ef9a77885d60178190441ceba95946f0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:24ddc5750776fe50a6edc9ff910ecb4301430eb53716eaf5552cbee5983bf1ee AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1fba8c2297f531414a067324c91b5213c324c4fa1323cd82caf178ad7fe1653e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f7cba40e23850eb2c7f9e5440e0e9e7bcb347ebb3bc5a64ceeef8bc9828c420e AS pg15

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
