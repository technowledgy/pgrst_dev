ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:25f7b21080efec7b993494f6a50479985c8c1a54f6047d62fa45abad40e6f85c AS pg10
FROM technowledgy/pg_dev:pg11@sha256:fa414fb8df1973211e5e6c61e7c5d0b2d09f245031bbafafa09914e61e07f6df AS pg11
FROM technowledgy/pg_dev:pg12@sha256:1cd94fc0970a25d20dc78bb7bef4398e30435bdd93c309e55f0df4b0c96847f7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d1f7327374a98a3fb4f3b5aef1e2571db117e34dd013cf06be0a3a630714ca20 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:bfb87bf59e51ec8e043b022de54259456d85cb62a7dbbecf6536981c650d0a32 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:28fa91c6b4b4fdc4c572fe92e08312b5d95016737094adbc5b15c3156ed0d129 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:2a9add388462f8cec6b469ec6ce4c4e1db3a17cda9d630a4cc0755fc6e0e2de5 AS pg15

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
