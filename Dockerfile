ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:5f7291521e3ed32268593e22a383923513137124fc4f4127efbc629e34514112 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e78a66ca237fd6b069064af9600bde681eb0688aa46c033097623da3f8268d5e AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6d427f579291734e1a9c0942892e700e2e561c95b84e96aa7b25553b19dae8ce AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:7692ff5ae13ad17e0fa90923caf81a8572753677c842539bede69ee7428608ef AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:49aa5d981e5f02e32e78fc29dc5f7858222ec33d0daf4ad4bee60bdb1e8b741d AS pg15
FROM technowledgy/pg_dev:pg16@sha256:bcd5189774415ecfa08c160986e557cff64cc790b276e9e12c004709fff52f60 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:7a73d51080c21d6ef49603027aca564e6aeaec9b7bb56666af4e5a08efbf3eac AS pgrstdevel

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
