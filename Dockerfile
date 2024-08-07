ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:04e2ec147f6adb067d344f5115f7b3da7fdd33498d766d134c8b9efce257e962 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:716bd9a579c502c95fdb141389422a06d3c4f8ca06edfa2b673d0d0153f62140 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:7739bdfcec8c097da5fb8ddc1fb5253656ff0ff08082ab25929fde3fc0eda17d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d6e05b357b5421f6f1adc1aa8b00c55c02289b1e26d8028c5628e48494e236f7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d3e05d9706548cdcdb64df9d7c5d5c5273d1663055392c65db30045310bcf6f8 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:83f407abac6090fc58840d42af4d7d53b8aafc027ec2aeb7bdb012be0b6b580a AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:2d98cbab676c08e164099cae9e16d48b7983b78ff904f81290d1fdd7d1bb9e13 AS pgrstdevel

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
