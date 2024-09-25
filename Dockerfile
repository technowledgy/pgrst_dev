ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:1e844dfc3eb95498422b7d45547d042dbee987e9d2c5b14a37076217cbb0872d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:faec541d21d8525488d99b66855805d858f01e88b0b1ac51dae10b3dbc141b1b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b5d945fb412d79c55662b0eff5932ed25c0f749aea03a526b6e1f3be25bbd46a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:687f027504d726dc54c247d7f88d1cd0d99482ec117885f418b60aabf97a28ab AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:a6b94abbfcd0926059111a072f6faa8b12e20e4532d047c44fed97c6469a6ce2 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:5e084f219bd24237c5d40663ea1c0caf23c3d2a689161baabc8261adf399695d AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:10b097ac4fc9b2b4d0884f14171576685530da66dfe3cfbeab7691a96249eb83 AS pgrstdevel

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
