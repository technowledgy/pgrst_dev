ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:38b47b70bc6a896f7d0e07810f0600cb1411997274fcd7ce3c51e63fe41e35ef AS pg12
FROM technowledgy/pg_dev:pg13@sha256:13e3a8db68e29b81bfbe3a28151ba2a58c2156603eb7343f2faffd06286bf92a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6679dcbde91e5b428328e9aced50235aa14971bf998811203bcfd862d6fac293 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6898253ea882248124032fc3e4ff599049c6cb8869b96793c4c566f657cf3bd5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c1d9271da4216f4293ee1560afe77e7ecaa0bc613521d01d4a6e024073a53557 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:bf985ce40035df8561144eb33ff6a94dd6d81cb4a9a446923ff8db7dff92f3ef AS pg16

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
