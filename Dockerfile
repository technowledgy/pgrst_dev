ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:1fdbef85aaf957f553b5b3db04ee52282020bb99cac25583bc4a1dcda565c435 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3964555fae69d2a575079a946be74f0018283fbb53b0f125e8bb742fcabc9501 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5693c36cfafc043b10daa4a9813015093d9c02f1a9ecf6bcbb8108481abf5315 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:03cd7556aaa4d6a68657d9bb2e00227d59d2a5951251b79fd56cb9d9233b8f9b AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:04ff99e56e2c871d1f41682aa3453e5a2d434497a36754526745161777b9fc31 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ddeed2202ee07dbc128f7cc2320e5d4e45a1d47ad3921080e56c67b6bc06c174 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.3@sha256:25a7e698337da07976ea830fda7c513ed2e907094337a9833948fd30d9f77a06 AS pgrst12

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
