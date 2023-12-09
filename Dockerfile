ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:fbb64c3316f2cd206e56402a2b520727805975c815c8421d5935a83d3db1fe28 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:49a41df60dbd69c75c0740059e993e3e3f7399656b67a16ce14650da97f6e988 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:891177d61f145aa6cf00edeb07b443e067a4887b1117a26a33b904b5a5695aeb AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e92964440174d9ba3596eb96f1afcc8e63ce7e802de68ccf1b09c2eb1bd48c60 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e18acb6373a9337153db9b5ef57c20dbb8e9b92b0cfb4345646ad86c9f60eafb AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:fcaa5669881dc4d76e72ee1753368d0b806fa7308cae10300155456c8e6dd8fb AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:acfd76545bb6db573a5e325e389597efc201330dd433a870b5c011001be801b7 AS pg15

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
