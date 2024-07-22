ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:2f99bef74b65ab4674311cd294f49f644b080cfa50718471d96314cb0ad90e69 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a60f7e8f821a233b4814adc95f1bac76006372e40374e979d0dd7e0a9a79f448 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e07f30dca3842d1b75974d90d2049a2d4f1bd7fe285e84eba7cb05de0786b62f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:90aa6d863d3f279abb607752dda2b7813d204770857c1340a6b9f1ed23f97739 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:2e07fba8f21173becd83766c33bcd8545f88e63b94a748c5b2ae6216b729d829 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ced5062a40ff31146815dafc89ee1cd227730ae38a7e2daf8247762269608d41 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.2@sha256:7755805562a33c0359c768a87d43f2ef6b2d13621778d43d15e12437c83f53a6 AS pgrst12
FROM postgrest/postgrest:devel@sha256:1dbcafd373569d0a37c186ed6149b896de01f5b1027242572580d2ea53e15c59 AS pgrstdevel

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
