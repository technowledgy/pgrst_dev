ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:6866ef5e0ff62fb73d84cc42a77f976a4dbc0bdf7f7ba847c6a21d5b817223b4 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:466325006310bf027661909211e3e0016f1f1b95e8fe6803071ea9e499b086f2 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:9fd7f85e4722023d9ec831a61727b85a5a22ee1eb0aea7971d43057d658e4d33 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:78f9e346cce63c868228bee3011fffe151ce0dd174e3169ee285a0df10f0dee7 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a000745fb411329766c8358015d9909ad8230b61aa346c5adc393d5cd237581d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:89cda04fbfb2dd1a3c755457ef119d72c6d37c12fda1bae0faedfef29fd1d0df AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ac36f0f569be2ed77a33e3416f9813046b214960a11b4f56e78278ffec8ad571 AS pg15

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
