ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:dd8c8aba94b3813d6242d593640d5a26a74f5c470ddaea1f1fec4eceab1d32fd AS pg12
FROM technowledgy/pg_dev:pg13@sha256:41d4de96806bc9037232628a75293d356da79be216e5e27411a05224ba812f8c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:76f9bcfb0c354a0c368069534ce1e47245bb7b21ba9f0b4a7a5be12874e6a1b3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:4e05e6b4b5a2ab7c804ff3953c98af90564b38bef770d2c1ca656be5e35210b7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e99533db17e1ef6b7beb298c4d11f068973e7fb9dff8ea6fb85af917bf01b4b7 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:d7fd83ae0d04af305c843cc71e7e1e0260b605aefcf35d1cd0fe922787017f2d AS pg16

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
