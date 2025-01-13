ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:c1f770ecad1a54a53eeaf49fe85f63d1d29d48c06cc41b987c8e9c308bf6f930 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:55371149a0ed22a2df74313795de58b0c3f8de1285913d73deb0a0cefaeebaee AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c698c7602a3faaa132239b2cdd3924ee68739c8984ee1df4b99731e7625a476d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a7f533092af9ef0a46bf10b96151ea3035e07c3394e53ebb51381bc0101659e4 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e6cccf87736cf2a2be6abef5f12ecd848bc24214712363884642a6f611e1bc36 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:847adebcf2fee4ff2c1f315755ed1fd1390e3edba6ca70f8526cd664132dc12a AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:abfadff103fa4135ed1e4b87ef8c7182e01d7ea3528b0bc3cd33a9d2e1cf8367 AS pgrstdevel

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
