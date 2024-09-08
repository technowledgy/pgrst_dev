ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:c00f61323af9ef15be427b415ceb0ce0c49b5f0b73da11dfd4ba8c66fb6fb869 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:84dea05cf2046a969387534e094def38822b14b882ca69e9f3ba756c4dab5c13 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:299b34c2f79ad3e893f29c9b8538f7e5bfdfc06ab8613a7fb557a48a1f70a41d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:5265c671fb5d30d102fb74b0f09021f3401657dd0389c80cba508ccadf2034f7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e749cfce6ae91fff3610345053ac2d8fbec1267a275ab8db1157dd6cec5e2c07 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ea5ba446823b70f99eb8f3847ecbddfd2eaa202e5e7f9b1fdea7f6527eb50d05 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:d90942f7b5fe79c8190565b648e35f12b3578882c19a8eb3059af03a4ad9ff99 AS pgrstdevel

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
