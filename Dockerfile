ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:f5c7c70ba2c4826bc7fde63950bf8b05639460c5ca398ea3695f4caca5f00b14 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ca64d638ec5a28fa877023ea49b7411ce531ccf0543fce473b7c96aa0829d434 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6adae1fd713300b891e3969ac6d40b9a57c459010317facf4b56e07c3880e910 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:763152c1ab9fb7758cc8be691f12a4f42e110be91de8272ef804620a7e948810 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:89ba16ab867a4ca62c0c3ec74977fbe704323cbb23ddcd571cc1faaf5a40ee84 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:faccfbb830d9bb1d3d8ea55007afc0fd6e8a8b6a11a6f6b918fcb1c92565d372 AS pg16

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
