ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:d52d5fc1ea65970a58e098f3983180cd1bab4f3e83b4be7a82153006300b2fbe AS pg12
FROM technowledgy/pg_dev:pg13@sha256:f4f6d4e583aae03b7eaef7b525e55374f95a551da5e09590f20dd00b9b635be8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:61545341b73dcb269696ad2b2c63c78c1ac5f61f323cfe52b8df8468852455d0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6bc37dc61d179fb87f3e06a06c71d370c40e8515d1951f5c4d5ad8f2c4b1aa2f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6396f50f8f828715fb0408d6fd162c64776baed3d0590deb39dfb0cd452210d2 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:e5bc2ee5b5283c36fb32bb12dbcc8970a7a37b5a7193eb454249d503faddbd2f AS pg16

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
