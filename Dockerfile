ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:77ea10ddbc14e061d7a1a4a395aeb3ddc73ddd15c4ec6569880e3ff256ccb133 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:5c75a6a17e406ab28434d32b57dbd196da63d971678506fea0cb6f64b6f66037 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0aea52db1fb972dd0baf1776e74e1ec65c2ea5094b042d926e7f4f0aeb89eddc AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:37005523ffc56be06c4155cdbf20c5f9523e96de04c7e2537e1be6d0c3188bd5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f5633441599ce09b26fc05485fda5eeac34bd31fe5deaca4fab8e17ad6ed9d68 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:a87d2d616b466dd0a8366d002c3850e7c2c7ab11a4cdc618f54aad712685f2d2 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:cb6d0add2c645fd4a8583638ba341cde759932cdf46f79dd7d5ae99782ce498a AS pgrstdevel

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
