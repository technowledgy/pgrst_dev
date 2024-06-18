ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:809638b05c90f445a4cfdf0b8cad8ea0b6c5c7ac3ae47ec9fae54d689b7978c1 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:fc14993fa29a2d892cc967f0862319ceed25ac0f64ea41b05be262c6f1c63979 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d78c6bef70f5e72fcd9a4dbca19f0cd70252fe4f724a05da9e598ad2ed2844c1 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a6d39e0c6a00ce63e10af65a8bbb6e23853960adf21f4c30b9715e7a4fbb2484 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:72fa104e1095d14654a7a41607f6dd6e742a199aee36586d933a4b91fc22ec3f AS pg15
FROM technowledgy/pg_dev:pg16@sha256:c71e4a6cf9ef99c5ee7bbb382a0277389012d896039e546612001cca9454c73c AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.0@sha256:2cf1efd2c9c2e7606610c113cc73e936d8ce9ba089271cb9cbf11aa564bc30c7 AS pgrst12

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
