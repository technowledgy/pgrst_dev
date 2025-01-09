ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:87c1948408d52156491634ac8c0add2803048a83440b8db7e59919e6d3a8c99e AS pg12
FROM technowledgy/pg_dev:pg13@sha256:09f2d54c8fa8744db1f1d804a4e5661bebc616698a0af6d4fd51e758a2ba5b5c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0ebabb0cad46e39685502579ed37e3a250f2444d3ccc06c03b36bdde898bf1ad AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d487fc072837f14e4d645923fff84e4e18152d1a3372599498570c106c5e19a1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f82ed9fc077e4810d6f0eb012442f293cf7c32375e31d0aa49894f329f909820 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:21eb37d0e7a430a82feeb1863bd450828b08dc367e0ef5e008835a60fa888ac6 AS pg16

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
