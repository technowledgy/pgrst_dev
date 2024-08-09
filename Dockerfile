ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:758d4d67518c6797546166a7844c857129d86f9ca0123921fc93c30958ec0316 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d6c5bd55638a4f6e06cdffc1a5b1049a5d0ece563c005a43610df794884f6fb7 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5d7a7fd9df22189426964d996454bb318541e6ffa2fdaa8bef704a28bdddc89c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:db2493b080809874644ac899e4577c76c30d1eb2339b46827aa7f8543e90da2e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:31bf868050d0bc84bd3019ab3b3f1d58a1a32923bc5dfb3d631a27e6b6aa6551 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:0f5fd810bee09e1fbfba1ff92c290eaa9ff8749f2f05f51996ab3b2923e62d88 AS pg16

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
