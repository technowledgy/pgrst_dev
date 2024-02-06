ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:7602bd08789dc127b387c5da07ffbebd12b1bca574ae2cd10c0c22ec275d8ef0 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:2f287fd7da5f9f4a1c17005203acff5e397bc16ae314ecee33e5327346779a96 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3e40109a6bc1de41fb8d743144d1f7c1e657b070d2912a3e1e1539c2024b1fcb AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b620931a265836dc927f01c2b427e171a95d23e381410cd35cb4db36cfb17319 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:59e9281042b144fd9039216aa2fe349ff04ab6f393f57ef89764a77b409691d8 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:9da760a1d14810df97b6a09bb9c1bdb6cfe2681017c0a0d235fd83a299da0467 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.2@sha256:79369c0cdf9d7112ed4e327bc1b80156be11575dd66fbda245077a2d13b803bc AS pgrst12

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
