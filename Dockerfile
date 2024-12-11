ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:829f8077e5b4f795d8908687cb0e136245600ff9cdfd91509f9485f659b75dcc AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a4f4bd307806f882c6bd8ac79cbf301d53332ff2eb28240c30f651684f0a3772 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:2da5f6f1807162963c6e48ea4aa28dabd7ab3f573cea328d1a8e76a3529ea2a9 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f244b526704a341e6c86d7eb0c012e83c7659c8d6e919892d6db14471dc238c1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:fe1f2f7233ac54597ebd08b78e1be81bf2fba1e74f124681dd7fc2b2457a4bc7 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:8ceb3f34cb6758e4836754ec44e73cfc019f16cd71d6195f4347ba2db34b9fe7 AS pg16

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
