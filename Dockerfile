ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:256f73a072e713bdd5a6849fc67dffbdccd66014d09990a8eeb9cbf0cf3b7373 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:0310694c78181494a088662446a341aa391a2f85e3c6cd4aea5457e0fa6e84e0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:af2ad049ce6b12bdcd1755369f40cc847f6820901f70813662c5b8bc99e49c2a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:64353023c3fa4b454e53067e0b4768007278c9191cfb48cd8b4f483b94ae9868 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3ba7797b4bec00436ddea4a12ee24540b30f28945cb32e4ff3b74d1fa4c98405 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:1ac2e2ea97e83a76c92093202346d4ef096e310b62729e16e10946a1b9af8f82 AS pg16

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
