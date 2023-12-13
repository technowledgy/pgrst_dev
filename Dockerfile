ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:c9f78a60d8afea02017007d8be3439a5d9b7891adeaf9edf376a50dc0c86b575 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:7fc8aaa981d13a6cbed605084184ff9b758ad9db829069c966593daf0320b0da AS pg11
FROM technowledgy/pg_dev:pg12@sha256:ac48ff3cabadc71f0395a6cffb1010a7a144c241949e40a4b90175f1e469449e AS pg12
FROM technowledgy/pg_dev:pg13@sha256:512bb61fe3d191a168c25997102b19871c3ad714f440616d08019e0146fb3f92 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0784043b799f3a281a6b8f6a04cff8a04cab8f2460fb2e5c1eb2c24b4a7dc884 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:3979b08d2abc2f040ccd468f583c039cbb50b36e9e1529d786def26e2c0dd619 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e9e77266036e49e359816e237c73b2b7a819e8fa0f6395712d92f6694d101698 AS pg15

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
